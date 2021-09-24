import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:strapen_app/app/app_widget.dart';
import 'package:strapen_app/app/modules/live/controllers/live_controller.dart';
import 'package:strapen_app/app/modules/produto/components/produto_widget.dart';
import 'package:strapen_app/app/modules/produto/models/produto_model.dart';

class ProdutoBottomSheet extends StatefulWidget {
  final ProdutoModel produto;

  const ProdutoBottomSheet({required this.produto});

  @override
  _ProdutoBottomSheetState createState() => _ProdutoBottomSheetState();

  static Future<void> show({required BuildContext context, required ProdutoModel produto}) async {
    return await showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.background,
      isScrollControlled: true,
      useRootNavigator: true,
      builder: (_) => ProdutoBottomSheet(produto: produto),
    );
  }
}

class _ProdutoBottomSheetState extends State<ProdutoBottomSheet> {
  LiveController controller = Modular.get<LiveController>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 38),
      child: Observer(
        builder: (_) => ProdutoWidget(produtoStore: controller.produtos.singleWhere((e) => e.id == widget.produto.id)),
      ),
    );
  }
}
