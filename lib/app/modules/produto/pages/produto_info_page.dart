import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:strapen_app/app/app_widget.dart';
import 'package:strapen_app/app/modules/produto/components/produto_widget.dart';
import 'package:strapen_app/app/modules/produto/controllers/produto_info_controller.dart';
import 'package:strapen_app/app/modules/produto/factories/produto_factory.dart';
import 'package:strapen_app/app/modules/produto/models/produto_model.dart';

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
      backgroundColor: AppColors.background.withOpacity(0.6),
      body: Observer(
        builder: (_) => ProdutoWidget(produtoStore: controller.produtoStore!),
      ),
    );
  }
}
