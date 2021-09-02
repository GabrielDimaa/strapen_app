import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:strapen_app/app/app_widget.dart';
import 'package:strapen_app/app/modules/catalogo/controllers/catalogo_inserir_produtos_controller.dart';
import 'package:strapen_app/app/modules/produto/models/produto_model.dart';
import 'package:strapen_app/app/shared/components/app_bar_default/app_bar_default.dart';
import 'package:strapen_app/app/shared/components/button/elevated_button_default.dart';
import 'package:strapen_app/app/shared/components/dialog/error_dialog.dart';
import 'package:strapen_app/app/shared/components/loading/circular_loading.dart';
import 'package:strapen_app/app/shared/components/padding/magin_button_without_scaffold.dart';
import 'package:strapen_app/app/shared/components/padding/padding_list.dart';
import 'package:strapen_app/app/shared/components/padding/padding_scaffold.dart';
import 'package:strapen_app/app/shared/components/sized_box/vertical_sized_box.dart';
import 'package:strapen_app/app/shared/components/widgets/empty_list_widget.dart';
import 'package:strapen_app/app/shared/extensions/double_extension.dart';

class CatalogoInserirProdutosPage extends StatefulWidget {
  @override
  _CatalogoInserirProdutosPageState createState() => _CatalogoInserirProdutosPageState();
}

class _CatalogoInserirProdutosPageState extends ModularState<CatalogoInserirProdutosPage, CatalogoInserirProdutosController> {
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const VerticalSizedBox(1),
          Padding(
            padding: const PaddingScaffold(),
            child: Text("Selecione os produtos que serão exibidos no catálogo."),
          ),
          Expanded(
            child: Padding(
              padding: const PaddingList(),
              child: Observer(
                builder: (_) {
                  if (!controller.loading) {
                    if (controller.produtos.isNotEmpty) {
                      return ListView.builder(
                        itemCount: controller.produtos.length,
                        itemBuilder: (_, i) {
                          final ProdutoModel prod = controller.produtos[i];
                          return Card(
                            color: AppColors.opaci,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              child: Observer(
                                builder: (_) => CheckboxListTile(
                                  contentPadding: const EdgeInsets.all(0),
                                  title: Text(
                                    prod.descricao!,
                                    overflow: TextOverflow.ellipsis,
                                    style: textTheme.bodyText2,
                                  ),
                                  subtitle: Text(
                                    prod.preco!.formatReal(),
                                    style: textTheme.bodyText2!.copyWith(color: AppColors.primary),
                                  ),
                                  dense: true,
                                  secondary: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.network(
                                      prod.fotos!.first,
                                      height: 42,
                                      width: 42,
                                    ),
                                  ),
                                  value: controller.produtosSelected.any((e) => e.id == prod.id),
                                  onChanged: (value) {
                                    if (value!)
                                      controller.addProdutosSelected(prod);
                                    else
                                      controller.removeProdutosSelected(prod);
                                  },
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    } else {
                      return Center(
                        child: EmptyListWidget(
                          message: "Crie produtos para adicionar no seu novo catálogo.",
                        ),
                      );
                    }
                  } else {
                    return const CircularLoading();
                  }
                },
              ),
            ),
          ),
          Padding(
            padding: const MarginButtonWithoutScaffold(),
            child: ElevatedButtonDefault(
              child: Text("Confirmar"),
              onPressed: () async {
                try {
                  controller.save();
                } catch (e) {
                  ErrorDialog.show(context: context, content: e.toString());
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
