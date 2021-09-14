import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:strapen_app/app/modules/user/components/user_header.dart';
import 'package:strapen_app/app/modules/user/controllers/user_editar_controller.dart';
import 'package:strapen_app/app/shared/components/app_bar_default/app_bar_default.dart';
import 'package:strapen_app/app/shared/components/dialog/error_dialog.dart';
import 'package:strapen_app/app/shared/components/form/validator.dart';
import 'package:strapen_app/app/shared/components/padding/padding_scaffold.dart';
import 'package:strapen_app/app/shared/components/sized_box/vertical_sized_box.dart';
import 'package:strapen_app/app/shared/components/text_input/text_input_default.dart';
import 'package:strapen_app/app/shared/components/widgets/text_field_cpf_cnpj/text_field_cpf_cnpj.dart';
import 'package:strapen_app/app/shared/components/widgets/text_field_data_nascimento.dart';
import 'package:strapen_app/app/shared/extensions/string_extension.dart';
import 'package:strapen_app/app/shared/extensions/datetime_extension.dart';

class UserDadosPessoaisPage extends StatefulWidget {
  @override
  _UserDadosPessoaisPageState createState() => _UserDadosPessoaisPageState();
}

class _UserDadosPessoaisPageState extends ModularState<UserDadosPessoaisPage, UserEditarController> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _dataNascimentoController = TextEditingController();
  final TextEditingController _cepController = TextEditingController();
  final TextEditingController _cidadeController = TextEditingController();
  final TextEditingController _cpfCnpjController = TextEditingController();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _dataNascimentoFocus = FocusNode();
  final FocusNode _cepFocus = FocusNode();
  final FocusNode _cidadeFocus = FocusNode();
  final FocusNode _cpfCnpjFocus = FocusNode();

  @override
  void initState() {
    super.initState();

    controller.setInitPage(_updateControllers);
    controller.load();
  }

  void _updateControllers() {
    _emailController.text = controller.userStore.email ?? "";
    _dataNascimentoController.text = controller.userStore.dataNascimento?.formated ?? "";
    _cepController.text = controller.userStore.cep ?? "";
    _cidadeController.text = controller.userStore.cidade ?? "";
    _cpfCnpjController.text = controller.userStore.cpfCnpj ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarDefault(),
      body: Padding(
        padding: const PaddingScaffold(),
        child: Observer(
          builder: (_) {
            if (controller.loading) {
              return const CircularProgressIndicator();
            } else {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          UserHeader(
                            title: "Seus dados pessoais são privados, ninguém poderá ter acesso à eles.",
                          ),
                          Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                Observer(
                                  builder: (_) => TextFormField(
                                    decoration: InputDecorationDefault(
                                      label: "E-mail",
                                      prefixIcon: Icon(Icons.email, color: Colors.grey[200]),
                                    ),
                                    controller: _emailController,
                                    keyboardType: TextInputType.emailAddress,
                                    validator: InputEmailValidator().validate,
                                    enabled: !controller.loading,
                                    textInputAction: TextInputAction.next,
                                    onSaved: controller.userStore.setEmail,
                                    focusNode: _emailFocus,
                                    onFieldSubmitted: (_) => controller.focusChange(context, _emailFocus, _cepFocus),
                                  ),
                                ),
                                const VerticalSizedBox(2),
                                Observer(
                                  builder: (_) => TextFormField(
                                    decoration: InputDecorationDefault(
                                      label: "CEP",
                                    ),
                                    controller: _cepController,
                                    keyboardType: TextInputType.number,
                                    validator: InputCepValidator().validate,
                                    enabled: !controller.loading,
                                    textInputAction: TextInputAction.next,
                                    focusNode: _cepFocus,
                                    onFieldSubmitted: (_) => controller.focusChange(context, _cepFocus, _cidadeFocus),
                                    onSaved: (String? value) {
                                      controller.userStore.setCep(value.extrairNum());
                                    },
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                      CepInputFormatter(),
                                    ],
                                  ),
                                ),
                                const VerticalSizedBox(2),
                                Observer(
                                  builder: (_) => TextFormField(
                                    decoration: InputDecorationDefault(label: "Cidade"),
                                    controller: _cidadeController,
                                    validator: InputValidatorDefault().validate,
                                    textCapitalization: TextCapitalization.sentences,
                                    enabled: !controller.loading,
                                    onSaved: controller.userStore.setCidade,
                                    textInputAction: TextInputAction.next,
                                    focusNode: _cidadeFocus,
                                    onFieldSubmitted: (_) => controller.focusChange(context, _cidadeFocus, _dataNascimentoFocus),
                                  ),
                                ),
                                const VerticalSizedBox(2),
                                Observer(
                                  builder: (_) => TextFieldDataNascimento(
                                    sufixIconVisible: controller.userStore.dataNascimento != null,
                                    controller: _dataNascimentoController,
                                    enabled: !controller.loading,
                                    focusNode: _dataNascimentoFocus,
                                    onClear: () => controller.userStore.setDataNascimento(null),
                                    setDataStore: controller.userStore.setDataNascimento,
                                  ),
                                ),
                                const VerticalSizedBox(2),
                                Observer(
                                  builder: (_) => TextFieldCpfCnpj(
                                    enabled: !controller.loading,
                                    textController: _cpfCnpjController,
                                    onFieldSubmitted: (_) => _cpfCnpjFocus.unfocus(),
                                    focusNode: _cpfCnpjFocus,
                                    onSaved: (String? value) {
                                      controller.userStore.setCpfCnpj(value.extrairNum());
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const VerticalSizedBox(),
                  ElevatedButton(
                    child: const Text("Salvar"),
                    onPressed: () async {
                      unfocusAll();
                      try {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();

                          await controller.update(context, "Salvando dados pessoais...");
                        }
                      } catch (e) {
                        ErrorDialog.show(context: context, content: e.toString());
                      }
                    },
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  void unfocusAll() {
    _emailFocus.unfocus();
    _dataNascimentoFocus.unfocus();
    _cepFocus.unfocus();
    _cpfCnpjFocus.unfocus();
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _dataNascimentoController.dispose();
    _cepController.dispose();
    _cidadeController.dispose();
    _cpfCnpjController.dispose();
    _emailFocus.dispose();
    _dataNascimentoFocus.dispose();
    _cepFocus.dispose();
    _cidadeFocus.dispose();
    _cpfCnpjFocus.dispose();
  }
}
