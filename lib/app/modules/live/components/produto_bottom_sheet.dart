import 'package:flutter/material.dart';
import 'package:strapen_app/app/app_widget.dart';
import 'package:strapen_app/app/modules/produto/models/produto_model.dart';
import 'package:strapen_app/app/modules/produto/pages/produto_info_page.dart';

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
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 38),
      child: ProdutoInfoPage(model: widget.produto, isLive: true),
    );
  }
}
