import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:snapping_sheet/snapping_sheet.dart';
import 'package:strapen_app/app/app_widget.dart';
import 'package:strapen_app/app/modules/produto/stores/produto_store.dart';
import 'package:strapen_app/app/shared/components/app_bar_default/app_bar_default.dart';
import 'package:strapen_app/app/shared/components/app_bar_default/widgets/circle_background_app_bar.dart';
import 'package:strapen_app/app/shared/components/button/elevated_button_default.dart';
import 'package:strapen_app/app/shared/components/padding/magin_button_without_scaffold.dart';
import 'package:strapen_app/app/shared/components/padding/padding_scaffold.dart';
import 'package:strapen_app/app/shared/components/sized_box/vertical_sized_box.dart';
import 'package:strapen_app/app/shared/components/widgets/snap_bottom_sheet.dart';
import 'package:strapen_app/app/shared/extensions/double_extension.dart';
import 'package:transparent_image/transparent_image.dart';

class ProdutoWidget extends StatefulWidget {
  final ProdutoStore produtoStore;
  final VoidCallback? onPressedReserva;

  const ProdutoWidget({required this.produtoStore, this.onPressedReserva});

  @override
  _ProdutoWidgetState createState() => _ProdutoWidgetState();
}

class _ProdutoWidgetState extends State<ProdutoWidget> {
  int currentImage = 0;

  void setCurrentImage(int value) => setState(() => currentImage = value);

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
                    autoPlay: widget.produtoStore.fotos.length > 1,
                    scrollPhysics: widget.produtoStore.fotos.length <= 1 ? NeverScrollableScrollPhysics() : null,
                    viewportFraction: 1,
                    aspectRatio: 1,
                    autoPlayInterval: const Duration(seconds: 10),
                    onPageChanged: (index, _) => setCurrentImage(index),
                  ),
                  items: widget.produtoStore.fotos.map((e) {
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
              actionsWidgets: [
                CircleButtonAppBar(
                  color: AppColors.opaci.withOpacity(0.4),
                  child: Icon(
                    Icons.edit,
                    color: Colors.white,
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
            Observer(
              builder: (_) => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: widget.produtoStore.fotos.asMap().entries.map((e) {
                  return Observer(
                    builder: (_) => _itemIndicator(e.key == currentImage),
                  );
                }).toList(),
              ),
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
                              widget.produtoStore.descricao!,
                              style: textTheme.headline1!.copyWith(fontWeight: FontWeight.w600),
                            ),
                          ),
                          const VerticalSizedBox(),
                          Observer(
                            builder: (_) => Visibility(
                              visible: widget.produtoStore.quantidade == 0,
                              child: Text(
                                "Sem unidades",
                                style: textTheme.bodyText1!.copyWith(color: Colors.red, fontSize: 12),
                              ),
                              replacement: Text(
                                "${widget.produtoStore.quantidade!} ${widget.produtoStore.quantidade! > 1 ? "unidades" : "unidade"}",
                                style: textTheme.bodyText1!.copyWith(color: Colors.grey, fontSize: 12),
                              ),
                            ),
                          ),
                          const VerticalSizedBox(0.3),
                          Observer(
                            builder: (_) => Text(
                              widget.produtoStore.preco!.formatReal(),
                              style: textTheme.bodyText2!.copyWith(color: AppColors.primary, fontSize: 18),
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
                              widget.produtoStore.descricaoDetalhada!,
                              style: textTheme.bodyText1,
                            ),
                          ),
                          const VerticalSizedBox(2.5),
                          const Divider(),
                          Visibility(
                            visible: widget.onPressedReserva == null,
                            child: Column(
                              children: [
                                _tileNavigation(label: "Reserva", onTap: () {}),
                                const Divider(),
                                _tileNavigation(label: "Catálogo", onTap: () {}),
                                const Divider(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Visibility(
                      visible: widget.onPressedReserva != null,
                      child: Padding(
                        padding: const MarginButtonWithoutScaffold(),
                        child: ElevatedButtonDefault(
                          child: const Text("Reservar"),
                          onPressed: (widget.produtoStore.quantidade ?? 0) > 0 ? widget.onPressedReserva : null,
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
        onTap: () {},
        contentPadding: const EdgeInsets.all(0),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
        ),
      ),
    );
  }
}
