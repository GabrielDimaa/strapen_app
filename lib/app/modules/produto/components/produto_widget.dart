import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:snapping_sheet/snapping_sheet.dart';
import 'package:strapen_app/app/app_widget.dart';
import 'package:strapen_app/app/modules/produto/components/button_cancelar_widget.dart';
import 'package:strapen_app/app/modules/produto/controllers/produto_info_controller.dart';
import 'package:strapen_app/app/modules/reserva/components/status_reserva_widget.dart';
import 'package:strapen_app/app/modules/reserva/enums/enum_status_reserva.dart';
import 'package:strapen_app/app/shared/components/app_bar_default/app_bar_default.dart';
import 'package:strapen_app/app/shared/components/app_bar_default/widgets/editar_app_bar_widget.dart';
import 'package:strapen_app/app/shared/components/button/elevated_button_default.dart';
import 'package:strapen_app/app/shared/components/button/outlined_button_default.dart';
import 'package:strapen_app/app/shared/components/dialog/error_dialog.dart';
import 'package:strapen_app/app/shared/components/padding/magin_button_without_scaffold.dart';
import 'package:strapen_app/app/shared/components/padding/padding_scaffold.dart';
import 'package:strapen_app/app/shared/components/sized_box/horizontal_sized_box.dart';
import 'package:strapen_app/app/shared/components/sized_box/vertical_sized_box.dart';
import 'package:strapen_app/app/shared/components/widgets/snap_bottom_sheet.dart';
import 'package:strapen_app/app/shared/extensions/double_extension.dart';
import 'package:transparent_image/transparent_image.dart';

class ProdutoWidget extends StatefulWidget {
  @override
  _ProdutoWidgetState createState() => _ProdutoWidgetState();
}

class _ProdutoWidgetState extends State<ProdutoWidget> {
  final ProdutoInfoController controller = Modular.get<ProdutoInfoController>();

  int currentImage = 0;

  void setCurrentImage(int value) => setState(() => currentImage = value);

  String qtdFormated(int qtd) => "$qtd ${qtd > 1 ? "unidades" : "unidade"}";

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    double height = MediaQuery.of(context).size.width + 66;
    return SnappingSheet(
      child: Stack(
        children: [
          Stack(
            children: [
              Observer(
                builder: (_) => CarouselSlider(
                  options: CarouselOptions(
                    autoPlay: controller.produtoStore!.fotos.length > 1,
                    scrollPhysics: controller.produtoStore!.fotos.length <= 1 ? NeverScrollableScrollPhysics() : null,
                    viewportFraction: 1,
                    aspectRatio: 1,
                    autoPlayInterval: const Duration(seconds: 10),
                    onPageChanged: (index, _) => setCurrentImage(index),
                  ),
                  items: controller.produtoStore!.fotos.map((e) {
                    return FadeInImage.memoryNetwork(placeholder: kTransparentImage, image: e);
                  }).toList(),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 120,
            child: AppBarDefault(
              backgroundColor: Colors.transparent,
              backgroundColorBackButton: AppColors.opaci.withOpacity(0.4),
              onPressedBackButton: () {
                if (controller.reservaModel != null && !controller.hasLive && !controller.editavel)
                  Modular.to.pop(controller.reservaModel!);
                else
                  Modular.to.pop(controller.produtoStore!.toModel());
              },
              actionsWidgets: [
                Observer(
                  builder: (_) => EditarAppBarWidget(
                    visible: controller.editavel,
                    onTap: () async => await controller.editarProduto(),
                    backgroundColor: AppColors.opaci.withOpacity(0.4),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      initialSnappingPosition: _snapPositionPixel(height),
      lockOverflowDrag: true,
      snappingPositions: [
        _snapPositionFactor(0.7),
        _snapPositionFactor(0.8),
        _snapPositionPixel(height),
      ],
      sheetBelow: SnappingSheetContent(
        draggable: true,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: controller.produtoStore!.fotos.asMap().entries.map((e) => _itemIndicator(e.key == currentImage)).toList(),
            ),
            const VerticalSizedBox(1),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(44),
                    topRight: Radius.circular(44),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const VerticalSizedBox(2),
                    const SnapBottomSheet(),
                    const VerticalSizedBox(4),
                    Expanded(
                      child: ListView(
                        padding: const PaddingScaffold(),
                        children: [
                          Observer(
                            builder: (_) => Text(
                              controller.produtoStore!.descricao!,
                              style: textTheme.headline1!.copyWith(fontWeight: FontWeight.w600),
                            ),
                          ),
                          const VerticalSizedBox(),
                          Observer(
                            builder: (_) => Visibility(
                              visible: controller.reservaModel == null,
                              child: _infoProdutoParaReservar(textTheme: textTheme),
                              replacement: _infoProdutoReservado(textTheme: textTheme),
                            ),
                          ),
                          const VerticalSizedBox(2.5),
                          const Divider(),
                          const VerticalSizedBox(2.5),
                          Text(
                            "Descrição do produto",
                            style: textTheme.bodyText2!.copyWith(color: AppColors.primary, fontWeight: FontWeight.w600),
                          ),
                          const VerticalSizedBox(),
                          Observer(
                            builder: (_) => Text(
                              controller.produtoStore!.descricaoDetalhada!,
                              style: textTheme.bodyText1,
                            ),
                          ),
                          const VerticalSizedBox(2.5),
                          const Divider(),
                          Observer(
                            builder: (_) => Visibility(
                              visible: controller.anuncianteVisible,
                              child: Column(
                                children: [
                                  _tileNavigation(
                                    label: "Anunciante",
                                    onTap: () async => await controller.verAnunciante(),
                                  ),
                                  const Divider(),
                                ],
                              ),
                            ),
                          ),
                          Observer(
                            builder: (_) => Visibility(
                              visible: controller.clienteVisible,
                              child: Column(
                                children: [
                                  _tileNavigation(
                                    label: "Cliente",
                                    onTap: () async => await controller.verCliente(),
                                  ),
                                  const Divider(),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Observer(
                      builder: (_) => Visibility(
                        visible: controller.comprarEnabled,
                        child: Padding(
                          padding: const MarginButtonWithoutScaffold(),
                          child: ElevatedButtonDefault(
                            child: const Text("Comprar"),
                            onPressed: (controller.produtoStore?.quantidade ?? 0) > 0 ? () async => await controller.reservar() : null,
                          ),
                        ),
                      ),
                    ),
                    Observer(
                      builder: (_) => Visibility(
                        visible: controller.statusVisible,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          child: Row(
                            children: [
                              Expanded(
                                child: Visibility(
                                  visible: controller.cancelarVisible,
                                  child: ButtonCancelarWidget(
                                    onPressed: () async {
                                      try {
                                        await controller.alterarStatus(context, EnumStatusReserva.Cancelado);
                                      } catch (e) {
                                        ErrorDialog.show(context: context, content: e.toString());
                                      }
                                    },
                                  ),
                                ),
                              ),
                              Observer(
                                builder: (_) => Visibility(
                                  visible: controller.finalizarVisible && controller. cancelarVisible,
                                  child: const HorizontalSizedBox(),
                                ),
                              ),
                              Expanded(
                                child: Observer(
                                  builder: (_) => Visibility(
                                    visible: controller.finalizarVisible,
                                    child: OutlinedButtonDefault(
                                      child: const Text("Finalizar"),
                                      padding: const EdgeInsets.all(12),
                                      onPressed: () async {
                                        try {
                                          await controller.alterarStatus(context, EnumStatusReserva.Finalizado);
                                        } catch (e) {
                                          ErrorDialog.show(context: context, content: e.toString());
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _itemIndicator(bool selected) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2),
      height: 5,
      width: selected ? 18 : 5,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: selected ? AppColors.primary : Colors.grey,
      ),
    );
  }

  SnappingPosition _snapPositionFactor(double positionFactor) {
    return SnappingPosition.factor(
      grabbingContentOffset: GrabbingContentOffset.bottom,
      snappingCurve: Curves.fastOutSlowIn,
      snappingDuration: Duration(milliseconds: 500),
      positionFactor: positionFactor,
    );
  }

  SnappingPosition _snapPositionPixel(double pixel) {
    return SnappingPosition.pixels(
      grabbingContentOffset: GrabbingContentOffset.top,
      snappingCurve: Curves.fastOutSlowIn,
      snappingDuration: Duration(milliseconds: 500),
      positionPixels: pixel,
    );
  }

  Widget _tileNavigation({required String label, required VoidCallback onTap}) {
    return Material(
      color: Colors.transparent,
      child: ListTile(
        title: Text(label),
        onTap: onTap,
        contentPadding: const EdgeInsets.all(0),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
        ),
      ),
    );
  }

  Widget _infoProdutoParaReservar({required TextTheme textTheme}) {
    return ButtonBar(
      alignment: MainAxisAlignment.spaceBetween,
      buttonPadding: EdgeInsets.zero,
      overflowButtonSpacing: 2,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Observer(
              builder: (_) => Visibility(
                visible: controller.produtoStore?.quantidade == 0,
                child: Text(
                  "Sem unidades",
                  style: textTheme.bodyText1!.copyWith(color: Colors.red, fontSize: 12),
                ),
                replacement: Text(
                  controller.textQtd,
                  style: textTheme.bodyText1!.copyWith(color: Colors.grey, fontSize: 12),
                ),
              ),
            ),
            const VerticalSizedBox(0.3),
            Observer(
              builder: (_) => Text(
                controller.produtoStore!.preco!.formatReal(),
                style: textTheme.bodyText2!.copyWith(color: AppColors.primary, fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
        Observer(
          builder: (_) => Visibility(
            visible: controller.reservado,
            child: Align(
              alignment: Alignment.centerRight,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppColors.primary),
                  color: AppColors.primaryOpaci,
                ),
                child: Text("Comprado", style: TextStyle(color: AppColors.primary)),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _infoProdutoReservado({required TextTheme textTheme}) {
    return ButtonBar(
      alignment: MainAxisAlignment.spaceBetween,
      buttonPadding: EdgeInsets.zero,
      overflowButtonSpacing: 2,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text("Quantidade:  ", style: textTheme.bodyText1),
                Observer(
                  builder: (_) => Text(
                    qtdFormated(controller.reservaModel?.quantidade ?? 0),
                    style: textTheme.bodyText1!.copyWith(fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
            const VerticalSizedBox(0.3),
            Row(
              children: [
                Text("Valor unitário:  ", style: textTheme.bodyText1),
                Observer(
                  builder: (_) => Text(
                    controller.reservaModel?.preco.formatReal() ?? "",
                    style: textTheme.bodyText1!.copyWith(fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
            const VerticalSizedBox(1.5),
            Text("Valor total:  ", style: textTheme.bodyText1),
            const VerticalSizedBox(0.3),
            Observer(
              builder: (_) => Text(
                controller.produtoStore!.preco!.formatReal(),
                style: textTheme.bodyText2!.copyWith(color: AppColors.primary, fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
        if (controller.reservaModel?.status != null)
          Align(
            alignment: Alignment.centerRight,
            child: Observer(
              builder: (_) => StatusReservaWidget(status: controller.reservaModel!.status!),
            ),
          ),
      ],
    );
  }
}
