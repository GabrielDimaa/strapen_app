import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:strapen_app/app/app_widget.dart';
import 'package:strapen_app/app/modules/catalogo/components/card_inserir_widget.dart';
import 'package:strapen_app/app/modules/catalogo/controllers/catalogo_create_controller.dart';
import 'package:strapen_app/app/shared/components/button/elevated_button_default.dart';
import 'package:strapen_app/app/shared/components/dialog/dialog_default.dart';
import 'package:strapen_app/app/shared/components/padding/magin_button_without_scaffold.dart';
import 'package:strapen_app/app/shared/components/padding/padding_scaffold.dart';
import 'package:strapen_app/app/shared/components/sized_box/vertical_sized_box.dart';
import 'package:strapen_app/app/shared/components/text_input/text_input_default.dart';
import 'package:strapen_app/app/shared/extensions/string_extension.dart';

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
                    onPressed: () async => await showTitle(context),
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
                    onPressed: () {},
                  ),
                ),
                const VerticalSizedBox(),
                Observer(
                  builder: (_) => CardAddWidget(
                    title: "Descrição",
                    onPressed: () async => await showDescricao(context),
                    child: controller.catalogoStore.descricao.notIsNullOrEmpty()
                        ? Text(
                            controller.catalogoStore.descricao!,
                            style: style,
                          )
                        : null,
                  ),
                ),
                const VerticalSizedBox(),
                CardAddWidget(
                  title: "Produtos",
                  onPressed: () {},
                  notEdit: true,
                  child: Column(
                    children: [
                      ListTile(
                        contentPadding: EdgeInsets.all(0),
                        leading: Padding(
                          padding: const EdgeInsets.only(left: 6),
                          child: CircleAvatar(
                            backgroundImage: Image.asset("assets/images/test/avatar_test.png").image,
                          ),
                        ),
                        title: Text(
                          "Jaqueta de couro",
                          style: Theme.of(context).textTheme.bodyText1!.copyWith(color: Colors.grey.shade300),
                        ),
                        onTap: () {},
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              padding: EdgeInsets.all(0),
                              onPressed: () {},
                              icon: Icon(
                                Icons.delete_outline,
                                color: AppColors.error,
                              ),
                            ),
                          ],
                        ),
                      ),
                      ListTile(
                        contentPadding: EdgeInsets.all(0),
                        title: Text(
                          "Jaqueta de couro",
                          style: Theme.of(context).textTheme.bodyText1!.copyWith(color: Colors.grey.shade300),
                        ),
                        onTap: () {},
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              padding: EdgeInsets.all(0),
                              onPressed: () {},
                              icon: Icon(
                                Icons.delete_outline,
                                color: AppColors.error,
                              ),
                            ),
                          ],
                        ),
                      ),
                      ListTile(
                        contentPadding: EdgeInsets.all(0),
                        title: Text(
                          "Jaqueta de couro",
                          style: Theme.of(context).textTheme.bodyText1!.copyWith(color: Colors.grey.shade300),
                        ),
                        onTap: () {},
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              padding: EdgeInsets.all(0),
                              onPressed: () {},
                              icon: Icon(
                                Icons.delete_outline,
                                color: AppColors.error,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const MarginButtonWithoutScaffold(),
          child: ElevatedButtonDefault(
            child: Text("Criar catálogo"),
            onPressed: () {},
          ),
        )
      ],
    );
  }

  Future<void> showTitle(BuildContext context) async {
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

  Future<void> showDescricao(BuildContext context) async {
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
              autofocus: true,
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
}
