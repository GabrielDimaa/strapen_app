import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:strapen_app/app/app_widget.dart';
import 'package:strapen_app/app/modules/produto/components/photo.dart';
import 'package:strapen_app/app/modules/produto/components/photo_miniature.dart';
import 'package:strapen_app/app/modules/produto/controllers/produto_create_controller.dart';
import 'package:strapen_app/app/shared/components/app_bar_default/app_bar_default.dart';
import 'package:strapen_app/app/shared/components/app_bar_default/widgets/circle_background_app_bar.dart';
import 'package:strapen_app/app/shared/components/bottom_sheet/bottom_sheet_image_picker.dart';
import 'package:strapen_app/app/shared/components/button/elevated_button_default.dart';
import 'package:strapen_app/app/shared/components/dialog/error_dialog.dart';
import 'package:strapen_app/app/shared/components/form/validator.dart';
import 'package:strapen_app/app/shared/components/padding/padding_scaffold.dart';
import 'package:strapen_app/app/shared/components/sized_box/horizontal_sized_box.dart';
import 'package:strapen_app/app/shared/components/sized_box/vertical_sized_box.dart';
import 'package:strapen_app/app/shared/components/text_input/text_input_default.dart';
import 'package:strapen_app/app/shared/components/widgets/text_field_qtd.dart';
import 'package:strapen_app/app/shared/extensions/string_extension.dart';

class ProdutoCreatePage extends StatefulWidget {
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

    _updateControllers();
  }

  void _updateControllers() {
    _descricaoController.text = controller.produtoStore.descricao ?? "";
    _descricaoDetalhadaController.text = controller.produtoStore.descricao ?? "";
    _quantidadeController.text = controller.produtoStore.quantidade?.toString() ?? "1";
    _precoController.text = controller.produtoStore.quantidade?.toString() ?? "";
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    List<int> list = [1, 2, 3, 4];
    return Scaffold(
      appBar: AppBarDefault(
        title: Text("Produto"),
        actionsWidgets: [
          CircleButtonAppBar(
            child: Icon(
              Icons.delete,
              color: Colors.white,
            ),
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
                    Observer(
                      builder: (_) => Photo(
                        onTap: () async => await _showBottomSheet(),
                        image: controller.produtoStore.fotos.isNotEmpty ? controller.produtoStore.fotos.first : null,
                      ),
                    ),
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
                                          image: Image.memory(e).image,
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
                              decoration: InputDecorationDefault(label: "Descrição"),
                              controller: _descricaoController,
                              validator: InputValidatorDefault().validate,
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
                              decoration: InputDecorationDefault(label: "Descrição detalhada"),
                              controller: _descricaoDetalhadaController,
                              validator: InputValidatorDefault().validate,
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
                                if (value.isNotEmpty) controller.produtoStore.setQuantidade(int.parse(value));
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
                              decoration: InputDecorationDefault(label: "Preço", prefixText: "R\$ "),
                              controller: _precoController,
                              validator: InputPrecoValidator().validate,
                              textInputAction: TextInputAction.done,
                              keyboardType: TextInputType.number,
                              focusNode: _precoFocus,
                              onFieldSubmitted: (_) => _focusChange(context: context, currentFocus: _precoFocus),
                              enabled: !controller.loading,
                              onSaved: (value) => controller.produtoStore.setValor(double.parse(value.extrairNum())),
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
              child: Text("Salvar produto"),
              onPressed: () async {
                try {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();

                    await controller.save();
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
    _descricaoController.dispose();
    _descricaoDetalhadaController.dispose();
    _quantidadeController.dispose();
    _precoController.dispose();
    _descricaoFocus.dispose();
    _descricaoDetalhadaFocus.dispose();
    _quantidadeFocus.dispose();
    _precoFocus.dispose();
    super.dispose();
  }
}
