import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:strapen_app/app/modules/user/components/foto_perfil_widget.dart';
import 'package:strapen_app/app/modules/user/controllers/user_editar_controller.dart';
import 'package:strapen_app/app/shared/components/app_bar_default/app_bar_default.dart';
import 'package:strapen_app/app/shared/components/bottom_sheet/bottom_sheet_image_picker.dart';
import 'package:strapen_app/app/shared/components/button/elevated_button_default.dart';
import 'package:strapen_app/app/shared/components/dialog/error_dialog.dart';
import 'package:strapen_app/app/shared/components/form/validator.dart';
import 'package:strapen_app/app/shared/components/padding/padding_scaffold.dart';
import 'package:strapen_app/app/shared/components/sized_box/horizontal_sized_box.dart';
import 'package:strapen_app/app/shared/components/sized_box/vertical_sized_box.dart';
import 'package:strapen_app/app/shared/components/text_input/text_input_default.dart';
import 'package:strapen_app/app/shared/components/widgets/text_field_bio.dart';
import 'package:strapen_app/app/shared/extensions/string_extension.dart';

class UserEditarPerfilPage extends StatefulWidget {
  @override
  _UserEditarPerfilPageState createState() => _UserEditarPerfilPageState();
}

class _UserEditarPerfilPageState extends ModularState<UserEditarPerfilPage, UserEditarController> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _telefoneController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final FocusNode _nomeFocus = FocusNode();
  final FocusNode _telefoneFocus = FocusNode();
  final FocusNode _usernameFocus = FocusNode();
  final FocusNode _bioFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    controller.setInitPage(_updateControllers);
    controller.load();
  }

  void _updateControllers() {
    _nomeController.text = controller.userStore.nome ?? "";
    _telefoneController.text = controller.userStore.telefone.notIsNullOrEmpty() ? UtilBrasilFields.obterTelefone(controller.userStore.telefone!) : "";
    _usernameController.text = controller.userStore.username ?? "";
    _bioController.text = controller.userStore.bio ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarDefault(
        title: const Text("Editar perfil"),
      ),
      body: Padding(
        padding: const PaddingScaffold(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const VerticalSizedBox(),
                    Observer(
                      builder: (_) => FotoPerfilWidget(foto: controller.userStore.foto),
                    ),
                    const VerticalSizedBox(),
                    TextButton(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.edit),
                          const HorizontalSizedBox(),
                          const Text("Alterar foto"),
                        ],
                      ),
                      onPressed: () async => await _showBottomSheet(),
                    ),
                    const VerticalSizedBox(2),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Observer(
                            builder: (_) => TextFormField(
                              decoration: InputDecorationDefault(labelText: "Nome completo"),
                              controller: _nomeController,
                              validator: InputValidatorDefault().validate,
                              textCapitalization: TextCapitalization.sentences,
                              keyboardType: TextInputType.name,
                              enabled: !controller.loading,
                              textInputAction: TextInputAction.next,
                              onSaved: controller.userStore.setNome,
                              focusNode: _nomeFocus,
                              onFieldSubmitted: (_) => controller.focusChange(context, _nomeFocus, _telefoneFocus),
                            ),
                          ),
                          const VerticalSizedBox(2),
                          Observer(
                            builder: (_) => TextFormField(
                              decoration: InputDecorationDefault(labelText: "Telefone"),
                              controller: _telefoneController,
                              keyboardType: TextInputType.phone,
                              validator: InputTelefoneValidator().validate,
                              enabled: !controller.loading,
                              textInputAction: TextInputAction.next,
                              focusNode: _telefoneFocus,
                              onFieldSubmitted: (_) => controller.focusChange(context, _nomeFocus, _usernameFocus),
                              onSaved: (String? value) {
                                controller.userStore.setTelefone(value.extrairNum());
                              },
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                TelefoneInputFormatter(),
                              ],
                            ),
                          ),
                          const VerticalSizedBox(2),
                          Observer(
                            builder: (_) => TextFormField(
                              decoration: InputDecorationDefault(
                                labelText: "Nome de usuário",
                                prefixText: "@",
                              ),
                              controller: _usernameController,
                              textInputAction: TextInputAction.next,
                              textCapitalization: TextCapitalization.sentences,
                              enabled: !controller.loading,
                              focusNode: _usernameFocus,
                              onFieldSubmitted: (_) => controller.focusChange(context, _usernameFocus, _bioFocus),
                              validator: InputUserNameValidator().validate,
                              onSaved: (String? value) => controller.userStore.setUserName(value),
                            ),
                          ),
                          const VerticalSizedBox(2),
                          Observer(
                            builder: (_) => TextFieldBio(
                              controller: _bioController,
                              bio: controller.userStore.bio,
                              enabled: !controller.loading,
                              focusNode: _bioFocus,
                              validate: false,
                              onFieldSubmitted: (_) => _bioFocus.unfocus(),
                              onSaved: controller.userStore.setBio,
                            ),
                          ),
                          const VerticalSizedBox(1.5),
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
                unfocusAll();
                try {
                  if (controller.userStore.foto == null) throw Exception("Escolha uma foto para seu perfil!");

                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();

                    await controller.update(context, "Salvando perfil...", () async {
                      try {
                        await controller.existsTelefone();
                        await controller.existsUsername();
                      } catch (e) {
                        rethrow;
                      }
                    });
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

  Future<void> _showBottomSheet() async {
    await showModalBottomSheet(
      context: context,
      builder: (_) => BottomSheetImagePicker(
        onTapCamera: () async => await controller.getImagePicker(true),
        onTapGaleria: () async => await controller.getImagePicker(false),
      ),
    );
  }

  void unfocusAll() {
    _nomeFocus.unfocus();
    _usernameFocus.unfocus();
    _usernameFocus.unfocus();
    _bioFocus.unfocus();
  }

  @override
  void dispose() {
    super.dispose();
    _nomeController.dispose();
    _telefoneController.dispose();
    _usernameController.dispose();
    _bioController.dispose();
    _nomeFocus.dispose();
    _telefoneFocus.dispose();
    _usernameFocus.dispose();
    _bioFocus.dispose();
  }
}
