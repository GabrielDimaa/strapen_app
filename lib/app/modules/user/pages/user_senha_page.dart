import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:strapen_app/app/modules/user/components/user_header.dart';
import 'package:strapen_app/app/modules/user/controllers/user_editar_controller.dart';
import 'package:strapen_app/app/shared/components/app_bar_default/app_bar_default.dart';
import 'package:strapen_app/app/shared/components/dialog/error_dialog.dart';
import 'package:strapen_app/app/shared/components/loading/circular_loading.dart';
import 'package:strapen_app/app/shared/components/padding/padding_scaffold.dart';
import 'package:strapen_app/app/shared/components/widgets/form_senha/form_senha_widget.dart';

class UserSenhaPage extends StatefulWidget {
  @override
  _UserSenhaPageState createState() => _UserSenhaPageState();
}

class _UserSenhaPageState extends ModularState<UserSenhaPage, UserEditarController> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    controller.load();
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
              return const CircularLoading();
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
                            title: "Escolha uma senha com pelo menos 8 caracteres.",
                          ),
                          Observer(
                            builder: (_) => FormSenhaWidget(
                              formKey: _formKey,
                              enabled: !controller.loading,
                              onSavedSenha: controller.userStore.setSenha,
                              onSavedConfirmarSenha: controller.userStore.setConfirmarSenha,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  ElevatedButton(
                    child: const Text("Salvar"),
                    onPressed: () async {
                      try {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();

                          if (controller.userStore.equalsSenha)
                            await controller.salvarNovaSenha(context);
                          else
                            throw Exception("As senhas não conferem!");
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
}
