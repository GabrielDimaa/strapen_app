import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:strapen_app/app/app_widget.dart';
import 'package:strapen_app/app/modules/produto/controllers/produto_list_controller.dart';
import 'package:strapen_app/app/shared/components/app_bar_default/app_bar_default.dart';
import 'package:strapen_app/app/shared/components/fab_default/fab_default.dart';
import 'package:strapen_app/app/shared/components/loading/circular_loading.dart';
import 'package:strapen_app/app/shared/components/padding/padding_list.dart';
import 'package:strapen_app/app/shared/components/padding/padding_scaffold.dart';
import 'package:strapen_app/app/shared/components/sized_box/vertical_sized_box.dart';
import 'package:strapen_app/app/shared/components/widgets/empty_list_widget.dart';
import 'package:strapen_app/app/shared/components/widgets/list_tile_widget.dart';
import 'package:strapen_app/app/shared/extensions/double_extension.dart';

class ProdutoListPage extends StatefulWidget {
  @override
  _ProdutoListPageState createState() => _ProdutoListPageState();
}

class _ProdutoListPageState extends ModularState<ProdutoListPage, ProdutoListController> {
  @override
  void initState() {
    super.initState();
    controller.load();
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBarDefault(title: Text("Produtos")),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(right: 8),
        child: FABDefault(
          onPressed: () async => await controller.toCreateProduto(),
          icon: Icons.add_circle_outline,
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const PaddingScaffold(),
            child: const Text("Aqui você poderá visualizar todos os seus produtos disponíveis para adicionar nos catálogos."),
          ),
          const VerticalSizedBox(1),
          Expanded(
            child: Padding(
              padding: const PaddingList(),
              child: Observer(builder: (_) {
                if (controller.loading) {
                  return const CircularLoading();
                } else {
                  if (controller.produtos.isEmpty) {
                    return const EmptyListWidget(
                      message: "Sua lista está vazia. Crie produtos para adicioná-los em algum catálogo.",
                    );
                  } else {
                    return ListView.builder(
                      itemCount: controller.produtos.length,
                      itemBuilder: (_, i) {
                        final prod = controller.produtos[i];
                        return ListTileWidget(
                          leadingImage: Image.network(prod.fotos!.first, height: 64, width: 64,),
                          title: Text(prod.descricao!),
                          subtitle: Column(
                            children: [
                              Text(
                                "${prod.quantidade!} ${prod.quantidade! > 1 ? "unidades" : "unidade"}",
                                style: textTheme.bodyText1!.copyWith(color: Colors.grey, fontSize: 12),
                              ),
                              const VerticalSizedBox(0.3),
                              Text(
                                prod.preco!.formatReal(),
                                style: textTheme.bodyText2!.copyWith(color: AppColors.primary),
                              ),
                            ],
                          ),
                          onTap: () {},
                        );
                      },
                    );
                  }
                }
              }),
            ),
          ),
        ],
      ),
    );
  }
}
