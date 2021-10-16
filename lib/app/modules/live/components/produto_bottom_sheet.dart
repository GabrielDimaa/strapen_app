import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:strapen_app/app/app_widget.dart';
import 'package:strapen_app/app/modules/live/components/user_bottom_sheet.dart';
import 'package:strapen_app/app/modules/live/controllers/live_controller.dart';
import 'package:strapen_app/app/modules/produto/components/produto_widget.dart';
import 'package:strapen_app/app/modules/produto/controllers/produto_info_controller.dart';
import 'package:strapen_app/app/modules/produto/stores/produto_store.dart';
import 'package:strapen_app/app/modules/reserva/models/reserva_model.dart';
import 'package:strapen_app/app/modules/user/models/user_model.dart';

class ProdutoBottomSheet extends StatefulWidget {
  final BuildContext context;
  final ProdutoStore produto;
  final ReservaModel? reserva;

  const ProdutoBottomSheet({required this.context, required this.produto, this.reserva});

  @override
  _ProdutoBottomSheetState createState() => _ProdutoBottomSheetState();

  static Future<void> show({required BuildContext context, required ProdutoStore produto, ReservaModel? reserva}) async {
    return await showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.background,
      isScrollControlled: true,
      useRootNavigator: true,
      builder: (_) => ProdutoBottomSheet(
        context: context,
        produto: produto,
        reserva: reserva,
      ),
    );
  }
}

class _ProdutoBottomSheetState extends State<ProdutoBottomSheet> {
  final LiveController controller = Modular.get<LiveController>();
  final ProdutoInfoController produtoInfoController = Modular.get<ProdutoInfoController>();

  @override
  void initState() {
    super.initState();
    _init();
  }

  void _init() {
    produtoInfoController.setHasLive(true);
    produtoInfoController.setProdutoStore(widget.produto);
    produtoInfoController.setReservaModel(widget.reserva);
    produtoInfoController.setReservado(controller.reservas.any((e) => e.idProduto == widget.produto.id) && !controller.isCriadorLive);
    produtoInfoController.setVerAnuncianteNaLiveFunction(!controller.isCriadorLive ? () async => anunciante() : null);
    produtoInfoController.setVerClienteNaLiveFunction(controller.isCriadorLive && widget.reserva != null ? () async => await cliente() : null);
    produtoInfoController.setReservarFunction(!controller.isCriadorLive ? () async => await reservar() : null);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.of(widget.context).padding.top),
      child: ProdutoWidget(),
    );
  }

  Future<void> anunciante() async {
    await UserBottomSheet.show(context: widget.context, user: controller.liveModel!.user!);
  }

  Future<void> cliente() async {
    final UserModel user = await controller.getCliente(widget.reserva!.user!.id!);
    await UserBottomSheet.show(context: widget.context, user: user);
  }

  Future<void> reservar() async {
    if (controller.liveEncerrada) throw Exception("A Live já foi encerrada.");

    await controller.reservarProduto(context, widget.produto.toModel());
    produtoInfoController.setReservado(controller.reservas.any((e) => e.idProduto == widget.produto.id) && !controller.isCriadorLive);
  }
}
