import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:strapen_app/app/app_widget.dart';
import 'package:strapen_app/app/modules/catalogo/components/catalogo_widget.dart';
import 'package:strapen_app/app/modules/catalogo/stores/catalogo_store.dart';
import 'package:strapen_app/app/modules/live/components/produto_bottom_sheet.dart';
import 'package:strapen_app/app/modules/produto/stores/produto_store.dart';
import 'package:strapen_app/app/shared/components/app_bar_default/app_bar_default.dart';

class CatalogoBottomSheet extends StatefulWidget {
  final CatalogoStore catalogo;

  const CatalogoBottomSheet({required this.catalogo});

  @override
  _CatalogoBottomSheetState createState() => _CatalogoBottomSheetState();

  static Future<void> show({required BuildContext context, required CatalogoStore catalogo}) async {
    return await showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.background,
      isScrollControlled: true,
      useRootNavigator: true,
      builder: (_) => CatalogoBottomSheet(catalogo: catalogo),
    );
  }
}

class _CatalogoBottomSheetState extends State<CatalogoBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 38),
      child: Column(
        children: [
          AppBarDefault(
            title: const Text("Catálogo"),
          ),
          Expanded(
            child: Observer(
              builder: (_) {
                return CatalogoWidget(
                  catalogoStore: widget.catalogo,
                  onPressedProduto: (ProdutoStore produto) async {
                    await ProdutoBottomSheet.show(
                      context: context,
                      produto: produto,
                    );
                  },
                );
              }
            ),
          ),
        ],
      ),
    );
  }
}
