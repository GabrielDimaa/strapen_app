import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:strapen_app/app/app_widget.dart';
import 'package:strapen_app/app/modules/catalogo/components/catalogo_widget.dart';
import 'package:strapen_app/app/modules/catalogo/controllers/catalogo_info_controller.dart';
import 'package:strapen_app/app/modules/catalogo/stores/catalogo_store.dart';
import 'package:strapen_app/app/modules/live/components/produto_bottom_sheet.dart';
import 'package:strapen_app/app/modules/produto/stores/produto_store.dart';
import 'package:strapen_app/app/shared/components/app_bar_default/app_bar_default.dart';

class CatalogoBottomSheet extends StatefulWidget {
  final CatalogoStore catalogo;
  final BuildContext context;

  const CatalogoBottomSheet({required this.catalogo, required this.context});

  @override
  _CatalogoBottomSheetState createState() => _CatalogoBottomSheetState();

  static Future<void> show({required BuildContext context, required CatalogoStore catalogo}) async {
    return await showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.background,
      isScrollControlled: true,
      useRootNavigator: true,
      builder: (_) => CatalogoBottomSheet(catalogo: catalogo, context: context),
    );
  }
}

class _CatalogoBottomSheetState extends State<CatalogoBottomSheet> {
  final CatalogoInfoController catalogoInfoController = Modular.get<CatalogoInfoController>();

  @override
  void initState() {
    super.initState();
    _init();
  }

  void _init() {
    catalogoInfoController.setCatalogoStore(widget.catalogo);
    catalogoInfoController.setProdutoFunction((ProdutoStore prod) async => await produto(prod));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.of(widget.context).padding.top),
      child: Column(
        children: [
          AppBarDefault(
            title: const Text("Catálogo"),
          ),
          Expanded(
            child: CatalogoWidget(),
          ),
        ],
      ),
    );
  }

  Future<void> produto(ProdutoStore produto) async {
    await ProdutoBottomSheet.show(
      context: widget.context,
      produto: produto,
    );
  }
}
