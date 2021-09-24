import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:strapen_app/app/app_widget.dart';
import 'package:strapen_app/app/modules/produto/controllers/produto_select_controller.dart';
import 'package:strapen_app/app/modules/produto/models/produto_model.dart';
import 'package:strapen_app/app/modules/produto/stores/produto_store.dart';
import 'package:strapen_app/app/shared/components/app_bar_default/app_bar_default.dart';
import 'package:strapen_app/app/shared/components/app_bar_default/widgets/circle_background_app_bar.dart';
import 'package:strapen_app/app/shared/components/button/elevated_button_default.dart';
import 'package:strapen_app/app/shared/components/dialog/error_dialog.dart';
import 'package:strapen_app/app/shared/components/loading/circular_loading.dart';
import 'package:strapen_app/app/shared/components/padding/magin_button_without_scaffold.dart';
import 'package:strapen_app/app/shared/components/padding/padding_list.dart';
import 'package:strapen_app/app/shared/components/padding/padding_scaffold.dart';
import 'package:strapen_app/app/shared/components/sized_box/vertical_sized_box.dart';
import 'package:strapen_app/app/shared/components/widgets/empty_list_widget.dart';
import 'package:strapen_app/app/shared/extensions/double_extension.dart';
import 'package:transparent_image/transparent_image.dart';

class ProdutoSelectPage extends StatefulWidget {
  final List<ProdutoModel>? produtos;

  const ProdutoSelectPage({this.produtos});

  @override
  _ProdutoSelectPageState createState() => _ProdutoSelectPageState();
}

class _ProdutoSelectPageState extends ModularState<ProdutoSelectPage, ProdutoSelectController> {
  @override
  void initState() {
    super.initState();
    controller.load(widget.produtos);
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBarDefault(
        title: Text("Produtos"),
        actionsWidgets: [
          CircleButtonAppBar(
            child: Icon(
              Icons.playlist_add,
              size: 28,
              color: Colors.white,
            ),
            onTap: () async => await controller.toProdutoCreate(),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const VerticalSizedBox(),
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
                          final ProdutoStore prod = controller.produtos[i];
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
                                    child: FadeInImage.memoryNetwork(
                                      placeholder: kTransparentImage,
                                      image: prod.fotos.first,
                                      height: 42,
                                      width: 42,
                                    ),
                                  ),
                                  value: prod.selected,
                                  onChanged: (value) => prod.setSelected(value ?? false),
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
            child: Observer(
              builder: (_) => ElevatedButtonDefault(
                child: Text("Confirmar"),
                onPressed: controller.produtos.isNotEmpty
                    ? () async {
                        try {
                          controller.save();
                        } catch (e) {
                          ErrorDialog.show(context: context, content: e.toString());
                        }
                      }
                    : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
