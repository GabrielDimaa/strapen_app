import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:strapen_app/app/modules/produto/controllers/produto_list_controller.dart';
import 'package:strapen_app/app/shared/components/app_bar_default/app_bar_default.dart';
import 'package:strapen_app/app/shared/components/fab_default/fab_default.dart';
import 'package:strapen_app/app/shared/components/padding/padding_scaffold.dart';
import 'package:strapen_app/app/shared/components/widgets/empty_list_widget.dart';

class ProdutoListPage extends StatefulWidget {
  @override
  _ProdutoListPageState createState() => _ProdutoListPageState();
}

class _ProdutoListPageState extends ModularState<ProdutoListPage, ProdutoListController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarDefault(title: Text("Produtos")),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(right: 8),
        child: FABDefault(
          onPressed: () async => await controller.toCreateProduto(),
          icon: Icons.add_circle_outline,
        ),
      ),
      body: Padding(
        padding: const PaddingScaffold(),
        child: EmptyListWidget(
          message: "Sua lista está vazia. Crie produtos para ser adicionado em um catálogo.",
        ),
      ),
    );
  }
}
