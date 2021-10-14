import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:strapen_app/app/app_widget.dart';
import 'package:strapen_app/app/modules/catalogo/components/card_inserir_widget.dart';
import 'package:strapen_app/app/modules/catalogo/controllers/catalogo_create_controller.dart';
import 'package:strapen_app/app/modules/produto/stores/produto_store.dart';
import 'package:strapen_app/app/shared/components/bottom_sheet/bottom_sheet_image_picker.dart';
import 'package:strapen_app/app/shared/components/button/elevated_button_default.dart';
import 'package:strapen_app/app/shared/components/dialog/dialog_default.dart';
import 'package:strapen_app/app/shared/components/dialog/error_dialog.dart';
import 'package:strapen_app/app/shared/components/padding/magin_button_without_scaffold.dart';
import 'package:strapen_app/app/shared/components/padding/padding_scaffold.dart';
import 'package:strapen_app/app/shared/components/sized_box/vertical_sized_box.dart';
import 'package:strapen_app/app/shared/components/text_input/text_input_default.dart';
import 'package:strapen_app/app/shared/extensions/string_extension.dart';
import 'package:transparent_image/transparent_image.dart';

class CriarCatalogoWidget extends StatefulWidget {
  @override
  _CriarCatalogoWidgetState createState() => _CriarCatalogoWidgetState();
}

class _CriarCatalogoWidgetState extends State<CriarCatalogoWidget> {
  final CatalogoCreateController controller = Modular.get<CatalogoCreateController>();

  @override
  Widget build(BuildContext context) {
    TextStyle style = Theme.of(context).textTheme.bodyText1!.copyWith(color: Colors.grey.shade300);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: PaddingScaffold.value / 2),
            child: Column(
              children: [
                const VerticalSizedBox(2),
                Observer(
                  builder: (_) => CardAddWidget(
                    title: "Título",
                    onPressed: () async => await _showTitle(context),
                    child: controller.catalogoStore.titulo.notIsNullOrEmpty()
                        ? Text(
                            controller.catalogoStore.titulo!,
                            style: style,
                          )
                        : null,
                  ),
                ),
                const VerticalSizedBox(),
                Observer(
                  builder: (_) => CardAddWidget(
                    title: "Foto",
                    onPressed: () async => await _showBottomSheet(),
                    child: controller.catalogoStore.foto != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: controller.catalogoStore.foto is File ? Image.file(
                              controller.catalogoStore.foto,
                              height: 126,
                              width: 126,
                            ) : FadeInImage.memoryNetwork(
                              placeholder: kTransparentImage,
                              image: controller.catalogoStore.foto,
                              height: 126,
                              width: 126,
                            ),
                          )
                        : null,
                  ),
                ),
                const VerticalSizedBox(),
                Observer(
                  builder: (_) => CardAddWidget(
                    title: "Descrição",
                    onPressed: () async => await _showDescricao(context),
                    child: controller.catalogoStore.descricao.notIsNullOrEmpty()
                        ? Text(
                            controller.catalogoStore.descricao!,
                            style: style,
                          )
                        : null,
                  ),
                ),
                const VerticalSizedBox(),
                Observer(
                  builder: (_) => CardAddWidget(
                    title: "Produtos",
                    onPressed: () async => await controller.inserirProdutos(),
                    child: controller.catalogoStore.produtos?.isNotEmpty ?? false
                        ? Column(
                            children: controller.catalogoStore.produtos!.map((e) => _produtoTile(e)).toList(),
                          )
                        : null,
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const MarginButtonWithoutScaffold(),
          child: ElevatedButtonDefault(
            child: Text("Salvar"),
            onPressed: () async {
              try {
                await controller.save(context);
              } catch(e) {
                ErrorDialog.show(context: context, content: e.toString());
              }
            },
          ),
        )
      ],
    );
  }

  Future<void> _showTitle(BuildContext context) async {
    final TextEditingController textController = TextEditingController();
    textController.text = controller.catalogoStore.titulo ?? "";

    await showDialog(
      context: context,
      builder: (_) => DialogDefault(
        context: context,
        title: Text("Título do catálogo"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const VerticalSizedBox(),
            TextField(
              decoration: InputDecorationDefault(label: 'Título'),
              controller: textController,
              textCapitalization: TextCapitalization.sentences,
              autofocus: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            child: Text("Confirmar"),
            onPressed: () {
              controller.catalogoStore.setTitulo(textController.text);
              Modular.to.pop();
            },
          ),
        ],
      ),
    );
  }

  Future<void> _showDescricao(BuildContext context) async {
    final TextEditingController textController = TextEditingController();
    textController.text = controller.catalogoStore.descricao ?? "";

    await showDialog(
      context: context,
      builder: (_) => DialogDefault(
        context: context,
        title: Text("Descrição do catálogo"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const VerticalSizedBox(),
            TextField(
              decoration: InputDecorationDefault(label: 'Descrição'),
              controller: textController,
              textCapitalization: TextCapitalization.sentences,
              autofocus: true,
              maxLines: 4,
            ),
          ],
        ),
        actions: [
          TextButton(
            child: Text("Confirmar"),
            onPressed: () {
              controller.catalogoStore.setDescricao(textController.text);
              Modular.to.pop();
            },
          ),
        ],
      ),
    );
  }

  Future<void> _showBottomSheet() async {
    await showModalBottomSheet(
      context: context,
      builder: (_) => BottomSheetImagePicker(
        onTapCamera: () async => await controller.getImagePicker(true),
        onTapGaleria: () async => await controller.getImagePicker(false),
      ),
    );
  }

  Widget _produtoTile(ProdutoStore prod) {
    return ListTile(
      contentPadding: EdgeInsets.all(0),
      leading: Padding(
        padding: const EdgeInsets.only(left: 6),
        child: CircleAvatar(
          backgroundImage: FadeInImage.memoryNetwork(placeholder: kTransparentImage, image: prod.fotos.first).image,
        ),
      ),
      title: Text(
        prod.descricao!,
        style: Theme.of(context).textTheme.bodyText1!.copyWith(color: Colors.grey.shade300),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          IconButton(
            padding: EdgeInsets.all(0),
            onPressed: () {
              controller.catalogoStore.produtos!.remove(prod);
            },
            icon: Icon(
              Icons.delete_outline,
              color: AppColors.error,
            ),
          ),
        ],
      ),
    );
  }
}
