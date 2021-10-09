import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:strapen_app/app/modules/reserva/controllers/reserva_list_controller.dart';
import 'package:strapen_app/app/modules/reserva/models/reserva_model.dart';
import 'package:strapen_app/app/shared/components/app_bar_default/app_bar_default.dart';
import 'package:strapen_app/app/shared/components/loading/circular_loading.dart';
import 'package:strapen_app/app/shared/components/padding/padding_scaffold.dart';
import 'package:strapen_app/app/shared/components/widgets/empty_list_widget.dart';
import 'package:strapen_app/app/shared/components/widgets/produto_grid_tile.dart';
import 'package:strapen_app/app/shared/components/widgets/produto_grid_view.dart';

class ReservaListPage extends StatefulWidget {
  final bool reserva;

  const ReservaListPage({required this.reserva});

  @override
  _ReservaListPageState createState() => _ReservaListPageState();
}

class _ReservaListPageState extends ModularState<ReservaListPage, ReservaListController> {
  @override
  void initState() {
    super.initState();
    controller.load(widget.reserva);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarDefault(title: Text(widget.reserva ? "Reservas" : "Compras")),
      body: Column(
        children: [
          Padding(
            padding: const PaddingScaffold(),
            child: Text(widget.reserva
                ? "Aqui você poderá visualizar todas as suas reservas.\nCombine com o cliente do produto para realizar a retirada do mesmo."
                : "Aqui, você poderá visualizar todas as suas compras.\nCombine com o anunciante do produto para realizar a retirada do mesmo."),
          ),
          Expanded(
            child: Padding(
              padding: const PaddingScaffold(),
              child: Observer(builder: (_) {
                if (controller.loading) {
                  return const CircularLoading();
                } else {
                  if (controller.reservas?.isEmpty ?? true) {
                    return EmptyListWidget(
                      message: "Sua lista de ${widget.reserva ? "reservas" : "compras"} está vazia.",
                    );
                  } else {
                    return RefreshIndicator(
                      onRefresh: controller.buscarReservas,
                      child: ProdutoGridView(
                        aspectRatioWithStatus: true,
                        itemCount: controller.reservas!.length,
                        itemBuilder: (_, i) {
                          final ReservaModel res = controller.reservas![i];
                          return ProdutoGridTile(
                            image: res.fotos!.first,
                            descricao: res.descricao!,
                            data: res.dataHoraReserva,
                            preco: res.preco! * res.quantidade!,
                            status: res.status,
                            onTap: () async => await controller.toProdutoInfoPage(res),
                          );
                        },
                      ),
                    );
                  }
                }
              }),
            ),
          ),
        ],
      ),
    );
  }
}
