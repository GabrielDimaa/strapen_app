import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:strapen_app/app/app_widget.dart';
import 'package:strapen_app/app/modules/live/controllers/live_controller.dart';
import 'package:strapen_app/app/modules/produto/components/produto_widget.dart';
import 'package:strapen_app/app/modules/produto/stores/produto_store.dart';

class ProdutoBottomSheet extends StatefulWidget {
  final ProdutoStore produto;
  final BuildContext context;

  const ProdutoBottomSheet({required this.produto, required this.context});

  @override
  _ProdutoBottomSheetState createState() => _ProdutoBottomSheetState();

  static Future<void> show({required BuildContext context, required ProdutoStore produto}) async {
    return await showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.background,
      isScrollControlled: true,
      useRootNavigator: true,
      builder: (_) => ProdutoBottomSheet(produto: produto, context: context,),
    );
  }
}

class _ProdutoBottomSheetState extends State<ProdutoBottomSheet> {
  LiveController controller = Modular.get<LiveController>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.of(widget.context).padding.top),
      child: Observer(
        builder: (_) => ProdutoWidget(produtoStore: widget.produto),
      ),
    );
  }
}
