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
    return Scaffold(
      body: SnappingSheet(
        child: Stack(
          children: [
            Stack(
              children: [
                Observer(
                  builder: (_) => CarouselSlider(
                    options: CarouselOptions(
                      autoPlay: controller.produtoStore!.fotos.length > 1,
                      viewportFraction: 1,
                      aspectRatio: 1,
                      autoPlayInterval: const Duration(seconds: 8),
                      onPageChanged: (index, _) => controller.setCurrentImage(index),
                    ),
                    items: controller.produtoStore!.fotos.map((e) {
                      return Image.network(e);
                    }).toList(),
                  ),
                ),
                Observer(
                  builder: (_) => Positioned(
                    bottom: 24,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: controller.produtoStore!.fotos.asMap().entries.map((e) {
                        return Observer(
                          builder: (_) => _itemIndicator(e.key == controller.currentImage),
                        );
                      }).toList(),
                    ),
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
        snappingPositions: [
          SnappingPosition.factor(
            grabbingContentOffset: GrabbingContentOffset.bottom,
            snappingCurve: Curves.fastOutSlowIn,
            snappingDuration: Duration(seconds: 1),
            positionFactor: 0.5,
          ),
        ],
        sheetBelow: SnappingSheetContent(
          draggable: true,
          child: Container(
            color: Colors.white,
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
}
