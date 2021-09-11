import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:strapen_app/app/app_widget.dart';
import 'package:strapen_app/app/modules/auth/controllers/auth_controller.dart';
import 'package:strapen_app/app/shared/components/button/elevated_button_default.dart';
import 'package:strapen_app/app/shared/components/dialog/error_dialog.dart';
import 'package:strapen_app/app/shared/components/form/validator.dart';
import 'package:strapen_app/app/shared/components/loading/linear_loading.dart';
import 'package:strapen_app/app/shared/components/padding/padding_scaffold.dart';
import 'package:strapen_app/app/shared/components/sized_box/vertical_sized_box.dart';
import 'package:strapen_app/app/shared/components/text_input/text_input_default.dart';
import 'package:strapen_app/app/shared/components/widgets/text_field_senha.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends ModularState<AuthPage, AuthController> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _senhaFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _header(),
                  Text(
                    "Strapen",
                    style: textTheme.headline2!.copyWith(color: AppColors.primary),
                    textAlign: TextAlign.center,
                  ),
                  Padding(
                    padding: PaddingScaffold(),
                    child: Column(
                      children: [
                        Text(
                          "Faça login agora para assistir ou criar Lives com seu catálogo de produtos.",
                          style: textTheme.bodyText2,
                        ),
                        const VerticalSizedBox(1.5),
                        Observer(
                          builder: (_) => LinearLoading(visible: controller.loading),
                        ),
                        const VerticalSizedBox(1.5),
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
                                  onSaved: controller.authStore.setEmail,
                                  textInputAction: TextInputAction.next,
                                  focusNode: _emailFocus,
                                  onFieldSubmitted: (_) {
                                    _emailFocus.unfocus();
                                    FocusScope.of(context).requestFocus(_senhaFocus);
                                  },
                                ),
                              ),
                              const VerticalSizedBox(1.5),
                              Observer(
                                builder: (_) => TextFieldSenha(
                                  controller: _senhaController,
                                  visible: controller.visible,
                                  enabled: !controller.loading,
                                  focusNode: _senhaFocus,
                                  textInputAction: TextInputAction.done,
                                  onFieldSubmitted: (_) => _senhaFocus.unfocus(),
                                  onSaved: controller.authStore.setSenha,
                                  onPressed: () => controller.setVisible(!controller.visible),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            child: Text(
                              "Esqueceu a senha?",
                              style: textTheme.bodyText2!.copyWith(fontSize: 14),
                            ),
                            onPressed: controller.esqueceuSenha,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Não possui uma conta?", style: textTheme.bodyText2!.copyWith(fontSize: 14)),
                            TextButton(
                              child: Text(
                                "Registrar-se",
                                style: textTheme.bodyText1!.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              onPressed: controller.registrar,
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              bottom: PaddingScaffold.value,
              left: PaddingScaffold.value,
              right: PaddingScaffold.value,
            ),
            child: ElevatedButtonDefault(
              child: Text("Entrar"),
              onPressed: !controller.loading ? () async {
                try {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();

                    await controller.login();
                  }
                } catch(e) {
                  ErrorDialog.show(context: context, content: e.toString());
                }
              } : () {}
            ),
          ),
        ],
      ),
    );
  }

  Widget _header() {
    final double height = 260;
    final double padding = 20;
    final double image = 120;

    return SizedBox(
      height: height,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Container(
            height: height - image,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(26),
                bottomRight: Radius.circular(26),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            child: Align(
              alignment: Alignment.center,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: AppColors.background,
                ),
                alignment: Alignment.center,
                padding: EdgeInsets.only(top: padding),
                child: Image.asset(
                  "assets/images/logo.png",
                  width: image,
                  height: image,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _senhaController.dispose();
    _emailFocus.dispose();
    _senhaFocus.dispose();
    super.dispose();
  }
}
