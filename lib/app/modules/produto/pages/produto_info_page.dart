import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:snapping_sheet/snapping_sheet.dart';
import 'package:strapen_app/app/app_widget.dart';
import 'package:strapen_app/app/modules/produto/controllers/produto_info_controller.dart';
import 'package:strapen_app/app/modules/produto/factories/produto_factory.dart';
import 'package:strapen_app/app/modules/produto/models/produto_model.dart';
import 'package:strapen_app/app/shared/components/app_bar_default/app_bar_default.dart';
import 'package:strapen_app/app/shared/components/app_bar_default/widgets/circle_background_app_bar.dart';
import 'package:strapen_app/app/shared/components/padding/padding_scaffold.dart';
import 'package:strapen_app/app/shared/components/sized_box/vertical_sized_box.dart';
import 'package:strapen_app/app/shared/extensions/double_extension.dart';

class ProdutoInfoPage extends StatefulWidget {
  final ProdutoModel model;

  const ProdutoInfoPage({required this.model});

  @override
  _ProdutoInfoPageState createState() => _ProdutoInfoPageState();
}

class _ProdutoInfoPageState extends ModularState<ProdutoInfoPage, ProdutoInfoController> {
  @override
  void initState() {
    super.initState();
    controller.setProdutoStore(ProdutoFactory.fromModel(widget.model));
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    double height = MediaQuery.of(context).size.width + 66;

    return Scaffold(
      backgroundColor: AppColors.background.withOpacity(0.6),
      body: SnappingSheet(
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
                      onPageChanged: (index, _) => controller.setCurrentImage(index),
                    ),
                    items: controller.produtoStore!.fotos.map((e) {
                      return Image.network(e);
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
                  children: controller.produtoStore!.fotos.asMap().entries.map((e) {
                    return Observer(
                      builder: (_) => _itemIndicator(e.key == controller.currentImage),
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
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          height: 5,
                          width: 50,
                          decoration: BoxDecoration(
                            color: AppColors.secondary,
                            borderRadius: BorderRadius.circular(100),
                          ),
                        ),
                      ),
                      const VerticalSizedBox(4),
                      Expanded(
                        child: ListView(
                          padding: const PaddingScaffold(),
                          children: [
                            Text(
                              controller.produtoStore!.descricao!,
                              style: textTheme.headline1!.copyWith(fontWeight: FontWeight.w600),
                            ),
                            const VerticalSizedBox(),
                            Text(
                              "${controller.produtoStore!.quantidade!} ${controller.produtoStore!.quantidade! > 1 ? "unidades" : "unidade"}",
                              style: textTheme.bodyText1!.copyWith(color: Colors.grey, fontSize: 12),
                            ),
                            const VerticalSizedBox(0.3),
                            Text(
                              controller.produtoStore!.preco!.formatReal(),
                              style: textTheme.bodyText2!.copyWith(color: AppColors.primary, fontSize: 18),
                            ),
                            const VerticalSizedBox(2.5),
                            const Divider(),
                            const VerticalSizedBox(2.5),
                            Text(
                              "Descrição do produto",
                              style: textTheme.bodyText2!.copyWith(color: AppColors.primary, fontWeight: FontWeight.w600),
                            ),
                            const VerticalSizedBox(),
                            Text(
                              controller.produtoStore!.descricaoDetalhada!,
                              style: textTheme.bodyText1,
                            ),
                            const VerticalSizedBox(2.5),
                            const Divider(),
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
              ),
            ],
          ),
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
