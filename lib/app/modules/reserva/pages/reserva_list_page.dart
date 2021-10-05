import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:strapen_app/app/modules/reserva/components/status_reserva_widget.dart';
import 'package:strapen_app/app/modules/reserva/controllers/reserva_list_controller.dart';
import 'package:strapen_app/app/shared/components/app_bar_default/app_bar_default.dart';
import 'package:strapen_app/app/shared/components/loading/circular_loading.dart';
import 'package:strapen_app/app/shared/components/padding/padding_list.dart';
import 'package:strapen_app/app/shared/components/padding/padding_scaffold.dart';
import 'package:strapen_app/app/shared/components/widgets/empty_list_widget.dart';
import 'package:strapen_app/app/shared/components/widgets/list_tile_widget.dart';
import 'package:transparent_image/transparent_image.dart';

class ReservaListPage extends StatefulWidget {
  @override
  _ReservaListPageState createState() => _ReservaListPageState();
}

class _ReservaListPageState extends State<ReservaListPage> {
  final ReservaListController controller = Modular.get<ReservaListController>();

  @override
  void initState() {
    super.initState();
    controller.load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarDefault(title: Text("Reservas")),
      body: Column(
        children: [
          Padding(
            padding: const PaddingScaffold(),
            child: const Text("Aqui você poderá visualizar todos as suas reservas.\nCombine com o anunciante do produto para realizar a retirada do mesmo."),
          ),
          Expanded(
            child: Padding(
              padding: const PaddingList(),
              child: Observer(builder: (_) {
                if (controller.loading) {
                  return const CircularLoading();
                } else {
                  if (controller.reservas?.isEmpty ?? true) {
                    return const EmptyListWidget(
                      message: "Sua lista está vazia. Você pode reservar produtos enquanto assiste uma Live.",
                    );
                  } else {
                    return RefreshIndicator(
                      onRefresh: controller.buscarReservas,
                      child: ListView.builder(
                        itemCount: controller.reservas!.length,
                        itemBuilder: (_, i) {
                          final res = controller.reservas![i];
                          return ListTileWidget(
                            leadingImage: FadeInImage.memoryNetwork(
                              placeholder: kTransparentImage,
                              image: res.fotos!.first,
                              height: 64,
                              width: 64,
                            ),
                            title: Text(res.descricao!),
                            subtitle: StatusReservaWidget(status: res.status!),
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
