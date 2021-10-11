import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:strapen_app/app/app_widget.dart';
import 'package:strapen_app/app/modules/live/components/produto_bottom_sheet.dart';
import 'package:strapen_app/app/modules/live/controllers/live_controller.dart';
import 'package:strapen_app/app/modules/produto/stores/produto_store.dart';
import 'package:strapen_app/app/modules/reserva/models/reserva_model.dart';
import 'package:strapen_app/app/shared/components/padding/padding_scaffold.dart';
import 'package:strapen_app/app/shared/components/sized_box/vertical_sized_box.dart';
import 'package:strapen_app/app/shared/components/widgets/empty_list_widget.dart';
import 'package:strapen_app/app/shared/components/widgets/produto_grid_tile.dart';
import 'package:strapen_app/app/shared/components/widgets/produto_grid_view.dart';
import 'package:strapen_app/app/shared/components/widgets/snap_bottom_sheet.dart';

class ReservaBottomSheet extends StatefulWidget {
  final BuildContext context;

  const ReservaBottomSheet({required this.context});

  @override
  _ReservaBottomSheetState createState() => _ReservaBottomSheetState();

  static Future<void> show({required BuildContext context}) async {
    return await showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.background,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(44),
          topRight: Radius.circular(44),
        ),
      ),
      isScrollControlled: true,
      builder: (_) => ReservaBottomSheet(context: context),
    );
  }
}

class _ReservaBottomSheetState extends State<ReservaBottomSheet> {
  final LiveController controller = Modular.get<LiveController>();

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.7,
      child: Padding(
        padding: const PaddingScaffold(),
        child: Column(
          children: [
            const VerticalSizedBox(2),
            const SnapBottomSheet(),
            const VerticalSizedBox(3),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                controller.isCriadorLive ? "Reservas" : "Compras",
                style: Theme.of(context).textTheme.headline1!.copyWith(fontWeight: FontWeight.w600),
              ),
            ),
            const VerticalSizedBox(2),
            Expanded(
              child: Observer(builder: (_) {
                if (controller.reservas.isEmpty) {
                  return EmptyListWidget(
                    message: controller.isCriadorLive ? "Nenhuma reserva até o momento!" : "Sua lista de compras está vazia.\nAcesse um catálogo e compre produtos!",
                  );
                } else
                  return ProdutoGridView(
                    itemCount: controller.reservas.length,
                    itemBuilder: (_, i) {
                      final ReservaModel res = controller.reservas[i];
                      final ProdutoStore prod = controller.produtos.firstWhere((e) => e.id == res.idProduto);
                      return ProdutoGridTile(
                        image: res.fotos!.first,
                        descricao: res.descricao!,
                        data: res.dataHoraReserva,
                        preco: res.preco! * res.quantidade!,
                        onTap: () async {
                          await ProdutoBottomSheet.show(
                            context: widget.context,
                            produto: prod,
                            reserva: res,
                          );
                        },
                      );
                    },
                  );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
