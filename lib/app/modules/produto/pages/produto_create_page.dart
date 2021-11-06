import 'dart:io';

import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:strapen_app/app/app_widget.dart';
import 'package:strapen_app/app/modules/produto/components/photo.dart';
import 'package:strapen_app/app/modules/produto/components/photo_miniature.dart';
import 'package:strapen_app/app/modules/produto/controllers/produto_create_controller.dart';
import 'package:strapen_app/app/modules/produto/factories/produto_factory.dart';
import 'package:strapen_app/app/modules/produto/models/produto_model.dart';
import 'package:strapen_app/app/shared/components/app_bar_default/app_bar_default.dart';
import 'package:strapen_app/app/shared/components/app_bar_default/widgets/remover_app_bar_widget.dart';
import 'package:strapen_app/app/shared/components/bottom_sheet/bottom_sheet_image_picker.dart';
import 'package:strapen_app/app/shared/components/button/elevated_button_default.dart';
import 'package:strapen_app/app/shared/components/dialog/error_dialog.dart';
import 'package:strapen_app/app/shared/components/form/validator.dart';
import 'package:strapen_app/app/shared/components/padding/padding_scaffold.dart';
import 'package:strapen_app/app/shared/components/sized_box/horizontal_sized_box.dart';
import 'package:strapen_app/app/shared/components/sized_box/vertical_sized_box.dart';
import 'package:strapen_app/app/shared/components/text_input/text_input_default.dart';
import 'package:strapen_app/app/shared/components/widgets/text_field_qtd.dart';
import 'package:transparent_image/transparent_image.dart';

class ProdutoCreatePage extends StatefulWidget {
  final ProdutoModel? produto;

  const ProdutoCreatePage({this.produto});

  @override
  _ProdutoCreatePageState createState() => _ProdutoCreatePageState();
}

class _ProdutoCreatePageState extends ModularState<ProdutoCreatePage, ProdutoCreateController> {
  //Keys
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey key = GlobalKey();

  //TextControllers
  final TextEditingController _descricaoController = TextEditingController();
  final TextEditingController _descricaoDetalhadaController = TextEditingController();
  final TextEditingController _quantidadeController = TextEditingController();
  final TextEditingController _precoController = TextEditingController();

  //FocusNode
  final FocusNode _descricaoFocus = FocusNode();
  final FocusNode _descricaoDetalhadaFocus = FocusNode();
  final FocusNode _quantidadeFocus = FocusNode();
  final FocusNode _precoFocus = FocusNode();

  @override
  void initState() {
    super.initState();

    if (widget.produto != null) controller.setProdutoStore(ProdutoFactory.fromModel(widget.produto!));
    controller.setInitPage(_updateControllers);
    controller.load();
  }

  void _updateControllers() {
    _descricaoController.text = controller.produtoStore.descricao ?? "";
    _descricaoDetalhadaController.text = controller.produtoStore.descricaoDetalhada ?? "";
    _quantidadeController.text = controller.produtoStore.quantidade.toString();
    _precoController.text = controller.produtoStore.preco?.toString() ?? "";
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBarDefault(
        title: Text("Produto"),
        backgroundColor: AppColors.background,
        actionsWidgets: [
          RemoverAppBarWidget(
            onTap: () async => await controller.remover(context),
            visible: widget.produto != null,
          ),
        ],
      ),
      body: Padding(
        padding: const PaddingScaffold(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Observer(builder: (_) {
                      return Photo(
                        onTap: () async => await _showBottomSheet(),
                        image: controller.produtoStore.fotos.firstOrNull,
                      );
                    }),
                    const VerticalSizedBox(),
                    Text(
                      "A primeira foto adicionada, será a foto principal do seu produto.",
                      style: textTheme.bodyText1!.copyWith(fontSize: 12),
                    ),
                    const VerticalSizedBox(),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Observer(
                        builder: (_) => Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            PhotoMiniature(
                              onTap: () async => await _showBottomSheet(),
                            ),
                          ]..addAll(
                              controller.produtoStore.fotos
                                  .map(
                                    (e) => Row(
                                      children: [
                                        const HorizontalSizedBox(0.7),
                                        PhotoMiniature(
                                          image: e is File
                                              ? Image.file(e).image
                                              : FadeInImage.memoryNetwork(
                                                  placeholder: kTransparentImage,
                                                  image: e,
                                                ).image,
                                          onTapRemove: () => controller.produtoStore.fotos.remove(e),
                                        )
                                      ],
                                    ),
                                  )
                                  .toList(),
                            ),
                        ),
                      ),
                    ),
                    const VerticalSizedBox(2),
                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Observer(
                            builder: (_) => TextFormField(
                              decoration: InputDecorationDefault(labelText: "Descrição"),
                              controller: _descricaoController,
                              validator: InputValidatorDefault().validate,
                              textCapitalization: TextCapitalization.sentences,
                              textInputAction: TextInputAction.next,
                              focusNode: _descricaoFocus,
                              enabled: !controller.loading,
                              onSaved: controller.produtoStore.setDescricao,
                              onFieldSubmitted: (_) => _focusChange(
                                context: context,
                                currentFocus: _descricaoFocus,
                                nextFocus: _descricaoDetalhadaFocus,
                              ),
                            ),
                          ),
                          const VerticalSizedBox(1.5),
                          Observer(
                            builder: (_) => TextFormField(
                              decoration: InputDecorationDefault(labelText: "Descrição detalhada"),
                              controller: _descricaoDetalhadaController,
                              validator: InputValidatorDefault().validate,
                              textCapitalization: TextCapitalization.sentences,
                              textInputAction: TextInputAction.next,
                              focusNode: _descricaoDetalhadaFocus,
                              enabled: !controller.loading,
                              onSaved: controller.produtoStore.setDescricaoDetalhada,
                              onFieldSubmitted: (_) => _focusChange(
                                context: context,
                                currentFocus: _descricaoDetalhadaFocus,
                                nextFocus: _quantidadeFocus,
                              ),
                            ),
                          ),
                          const VerticalSizedBox(2.5),
                          Text("Quantidade", style: textTheme.bodyText2!.copyWith(color: AppColors.primary)),
                          const VerticalSizedBox(),
                          Observer(
                            builder: (_) => TextFieldQtd(
                              controller: _quantidadeController,
                              focusNode: _quantidadeFocus,
                              enabled: !controller.loading,
                              onChanged: (value) {
                                if (value.isNotEmpty) {
                                  controller.produtoStore.setQuantidade(int.parse(value));
                                }
                              },
                              onSubmitted: (_) => _focusChange(
                                context: context,
                                currentFocus: _quantidadeFocus,
                                nextFocus: _precoFocus,
                              ),
                            ),
                          ),
                          const VerticalSizedBox(2.5),
                          Observer(
                            builder: (_) => TextFormField(
                              decoration: InputDecorationDefault(labelText: "Preço unitário", prefixText: "R\$ "),
                              controller: _precoController,
                              validator: InputPrecoValidator().validate,
                              textInputAction: TextInputAction.done,
                              keyboardType: TextInputType.number,
                              focusNode: _precoFocus,
                              onFieldSubmitted: (_) => _focusChange(context: context, currentFocus: _precoFocus),
                              enabled: !controller.loading,
                              onSaved: (value) {
                                controller.produtoStore.setValor(double.parse(value!.replaceAll(".", "").replaceAll(",", ".")));
                              },
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                RealInputFormatter(centavos: true),
                              ],
                            ),
                          ),
                          const VerticalSizedBox(2),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ElevatedButtonDefault(
              child: Text("Salvar"),
              onPressed: () async {
                try {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();

                    await controller.save(context);
                  }
                } catch (e) {
                  ErrorDialog.show(context: context, content: e.toString());
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void _focusChange({required BuildContext context, required FocusNode currentFocus, FocusNode? nextFocus}) {
    currentFocus.unfocus();
    if (nextFocus != null) FocusScope.of(context).requestFocus(nextFocus);
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

  @override
  void dispose() {
    super.dispose();
    _descricaoController.dispose();
    _descricaoDetalhadaController.dispose();
    _quantidadeController.dispose();
    _precoController.dispose();
    _descricaoFocus.dispose();
    _descricaoDetalhadaFocus.dispose();
    _quantidadeFocus.dispose();
    _precoFocus.dispose();
  }
}
