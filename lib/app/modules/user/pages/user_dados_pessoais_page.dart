import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:strapen_app/app/modules/user/components/user_header.dart';
import 'package:strapen_app/app/modules/user/controllers/user_editar_controller.dart';
import 'package:strapen_app/app/shared/components/app_bar_default/app_bar_default.dart';
import 'package:strapen_app/app/shared/components/dialog/error_dialog.dart';
import 'package:strapen_app/app/shared/components/padding/padding_scaffold.dart';
import 'package:strapen_app/app/shared/components/sized_box/vertical_sized_box.dart';
import 'package:strapen_app/app/shared/components/widgets/text_field_cpf_cnpj/text_field_cpf_cnpj.dart';
import 'package:strapen_app/app/shared/components/widgets/text_field_data_nascimento.dart';
import 'package:strapen_app/app/shared/components/widgets/text_field_endereco.dart';
import 'package:strapen_app/app/shared/extensions/datetime_extension.dart';
import 'package:strapen_app/app/shared/extensions/string_extension.dart';

class UserDadosPessoaisPage extends StatefulWidget {
  @override
  _UserDadosPessoaisPageState createState() => _UserDadosPessoaisPageState();
}

class _UserDadosPessoaisPageState extends ModularState<UserDadosPessoaisPage, UserEditarController> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _dataNascimentoController = TextEditingController();
  final TextEditingController _cpfCnpjController = TextEditingController();
  final FocusNode _dataNascimentoFocus = FocusNode();
  final FocusNode _cpfCnpjFocus = FocusNode();

  TextFieldEndereco? textFieldEndereco;

  @override
  void initState() {
    super.initState();

    controller.setInitPage(() {
      _updateControllers();
      textFieldEndereco = TextFieldEndereco(
        cep: controller.userStore.cep ?? "",
        cidade: controller.userStore.cidade ?? "",
        onSavedCep: (String? value) {
          controller.userStore.setCep(value.extrairNum());
        },
        onSavedCidade: (String? value) {
          controller.userStore.setCidade(value);
        },
      );
    });
    controller.load();
  }

  void _updateControllers() {
    _dataNascimentoController.text = controller.userStore.dataNascimento?.formated ?? "";
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
                          Observer(
                            builder: (_) => textFieldEndereco!,
                          ),
                          Form(
                            key: _formKey,
                            child: Column(
                              children: [
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
                        if (!textFieldEndereco!.cepValid) throw Exception("Cep inválido!");
                        textFieldEndereco!.unFocus();

                        if (_formKey.currentState!.validate() && textFieldEndereco!.formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          textFieldEndereco!.formKey.currentState!.save();

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
    _dataNascimentoFocus.unfocus();
    textFieldEndereco!.unFocus();
    _cpfCnpjFocus.unfocus();
  }

  @override
  void dispose() {
    _dataNascimentoController.dispose();
    _cpfCnpjController.dispose();
    _dataNascimentoFocus.dispose();
    _cpfCnpjFocus.dispose();
    super.dispose();
  }
}
