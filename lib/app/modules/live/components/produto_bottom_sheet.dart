import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:strapen_app/app/app_widget.dart';
import 'package:strapen_app/app/modules/live/components/user_bottom_sheet.dart';
import 'package:strapen_app/app/modules/live/controllers/live_controller.dart';
import 'package:strapen_app/app/modules/produto/components/produto_widget.dart';
import 'package:strapen_app/app/modules/produto/stores/produto_store.dart';
import 'package:strapen_app/app/modules/reserva/models/reserva_model.dart';
import 'package:strapen_app/app/shared/components/dialog/error_dialog.dart';

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
  LiveController controller = Modular.get<LiveController>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.of(widget.context).padding.top),
      child: Observer(
        builder: (_) => ProdutoWidget(
          produtoStore: widget.produto,
          reservaModel: widget.reserva,
          reservadoSuccess: !controller.isCriadorLive && controller.reservas.any((e) => e.idProduto == widget.produto.id),
          onPressedReserva: !controller.isCriadorLive ? () async {
            try {
              if (controller.liveEncerrada)
                throw Exception("A Live já foi encerrada.");

              await controller.reservarProduto(context, widget.produto.toModel());
            } catch(e) {
              ErrorDialog.show(context: context, content: e.toString());
            }
          } : null,
          onPressedAnunciante: !controller.isCriadorLive ? () async {
            await UserBottomSheet.show(context: widget.context, user: controller.liveModel!.user!);
          } : null,
          onPressedCliente: controller.isCriadorLive && widget.reserva != null ? () async {
            await UserBottomSheet.show(context: widget.context, user: widget.reserva!.user!);
          } : null,
        ),
      ),
    );
  }
}
