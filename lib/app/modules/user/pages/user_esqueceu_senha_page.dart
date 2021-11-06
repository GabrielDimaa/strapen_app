import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:strapen_app/app/modules/user/components/user_header.dart';
import 'package:strapen_app/app/modules/user/controllers/user_editar_controller.dart';
import 'package:strapen_app/app/shared/components/app_bar_default/app_bar_default.dart';
import 'package:strapen_app/app/shared/components/dialog/error_dialog.dart';
import 'package:strapen_app/app/shared/components/form/validator.dart';
import 'package:strapen_app/app/shared/components/loading/circular_loading.dart';
import 'package:strapen_app/app/shared/components/padding/padding_scaffold.dart';
import 'package:strapen_app/app/shared/components/sized_box/vertical_sized_box.dart';
import 'package:strapen_app/app/shared/components/text_input/text_input_default.dart';

class UserEsqueceuSenhaPage extends StatefulWidget {
  @override
  _UserEsqueceuSenhaPageState createState() => _UserEsqueceuSenhaPageState();
}

class _UserEsqueceuSenhaPageState extends ModularState<UserEsqueceuSenhaPage, UserEditarController> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final FocusNode _emailFocus = FocusNode();

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
                            title: "Informe seu endereço de e-mail.",
                          ),
                          Text(
                            "Será enviado um e-mail para redefinição da senha.\nApós redefinir, será necessário fazer login novamente.",
                            style: Theme.of(context).textTheme.bodyText2,
                          ),
                          const VerticalSizedBox(2),
                          Form(
                            key: _formKey,
                            child: Observer(
                              builder: (_) => TextFormField(
                                decoration: InputDecorationDefault(
                                  labelText: "E-mail",
                                  prefixIcon: Icon(Icons.email, color: Colors.grey[200]),
                                ),
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                validator: InputEmailValidator().validate,
                                enabled: !controller.loading,
                                textInputAction: TextInputAction.done,
                                onSaved: controller.userStore.setEmail,
                                focusNode: _emailFocus,
                                onFieldSubmitted: (_) => _emailFocus.unfocus(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  ElevatedButton(
                    child: const Text("Enviar"),
                    onPressed: () async {
                      try {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();

                          await controller.esqueceuSenha(context);
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
