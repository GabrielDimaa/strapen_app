import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:snapping_sheet/snapping_sheet.dart';
import 'package:strapen_app/app/app_widget.dart';
import 'package:strapen_app/app/modules/produto/stores/produto_store.dart';
import 'package:strapen_app/app/modules/reserva/components/status_reserva_widget.dart';
import 'package:strapen_app/app/modules/reserva/models/reserva_model.dart';
import 'package:strapen_app/app/modules/user/constants/routes.dart';
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
  final VoidCallback? onPressedAnunciante;
  final bool reservadoSuccess;
  final ReservaModel? reservaModel;
  final bool editavel;

  const ProdutoWidget({
    required this.produtoStore,
    this.onPressedReserva,
    this.onPressedAnunciante,
    this.reservadoSuccess = false,
    this.reservaModel,
    this.editavel = false,
  });

  @override
  _ProdutoWidgetState createState() => _ProdutoWidgetState();
}

class _ProdutoWidgetState extends State<ProdutoWidget> {
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
                Visibility(
                  visible: widget.editavel,
                  child: CircleButtonAppBar(
                    color: AppColors.opaci.withOpacity(0.4),
                    child: Icon(
                      Icons.edit,
                      color: Colors.white,
                    ),
                    messageTooltip: "Editar",
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
              children: widget.produtoStore.fotos.asMap().entries.map((e) => _itemIndicator(e.key == currentImage)).toList(),
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
                          Visibility(
                            visible: widget.reservaModel == null,
                            child: _infoProdutoParaReservar(textTheme: textTheme),
                            replacement: _infoProdutoReservado(textTheme: textTheme),
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
                            visible: widget.onPressedAnunciante != null || widget.reservaModel != null,
                            child: Column(
                              children: [
                                _tileNavigation(
                                  label: "Anunciante",
                                  onTap: () async {
                                    //Verificação para caso seja dentro da Live, abrir em um BottomSheet
                                    // que será passado no módulo da Live através do onPressedAnunciante()
                                    if (widget.onPressedAnunciante != null)
                                      widget.onPressedAnunciante!.call();
                                    else
                                      await Modular.to.pushNamed(USER_ROUTE, arguments: widget.reservaModel!.anunciante);
                                  },
                                ),
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
                style: textTheme.bodyText2!.copyWith(color: AppColors.primary, fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
        Visibility(
          visible: widget.reservadoSuccess,
          child: Align(
            alignment: Alignment.centerRight,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.primary),
                color: AppColors.primaryOpaci,
              ),
              child: Text("Reservado", style: TextStyle(color: AppColors.primary)),
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
            Observer(
              builder: (_) => Row(
                children: [
                  Text("Quantidade:  ", style: textTheme.bodyText1),
                  Text(
                    qtdFormated(widget.reservaModel!.quantidade!),
                    style: textTheme.bodyText1!.copyWith(fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
            const VerticalSizedBox(0.3),
            Observer(
              builder: (_) => Row(
                children: [
                  Text("Valor unitário:  ", style: textTheme.bodyText1),
                  Text(
                    widget.reservaModel!.preco.formatReal(),
                    style: textTheme.bodyText1!.copyWith(fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
            const VerticalSizedBox(1.5),
            Text("Valor total:  ", style: textTheme.bodyText1),
            const VerticalSizedBox(0.3),
            Observer(
              builder: (_) => Text(
                widget.produtoStore.preco!.formatReal(),
                style: textTheme.bodyText2!.copyWith(color: AppColors.primary, fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
        Align(
          alignment: Alignment.centerRight,
          child: StatusReservaWidget(status: widget.reservaModel!.status!),
        ),
      ],
    );
  }
}
