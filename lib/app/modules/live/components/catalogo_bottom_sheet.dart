import 'package:flutter/material.dart';
import 'package:strapen_app/app/app_widget.dart';
import 'package:strapen_app/app/modules/catalogo/components/catalogo_widget.dart';
import 'package:strapen_app/app/modules/catalogo/models/catalogo_model.dart';
import 'package:strapen_app/app/modules/live/components/produto_bottom_sheet.dart';
import 'package:strapen_app/app/modules/produto/models/produto_model.dart';
import 'package:strapen_app/app/shared/components/app_bar_default/app_bar_default.dart';

class CatalogoBottomSheet extends StatefulWidget {
  final CatalogoModel catalogo;

  const CatalogoBottomSheet({required this.catalogo});

  @override
  _CatalogoBottomSheetState createState() => _CatalogoBottomSheetState();

  static Future<void> show({required BuildContext context, required CatalogoModel catalogo}) async {
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
            child: CatalogoWidget(
              image: widget.catalogo.foto,
              titulo: widget.catalogo.titulo!,
              descricao: widget.catalogo.descricao!,
              produtos: widget.catalogo.produtos!,
              onPressed: (ProdutoModel produtoModel) async {
                await ProdutoBottomSheet.show(
                  context: context,
                  produto: produtoModel,
                );
              }
            ),
          ),
        ],
      ),
    );
  }
}
