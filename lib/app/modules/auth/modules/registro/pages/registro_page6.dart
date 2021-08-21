import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:strapen_app/app/app_widget.dart';
import 'package:strapen_app/app/modules/auth/modules/registro/components/registro_widget.dart';
import 'package:strapen_app/app/modules/auth/modules/registro/controllers/registro_controller.dart';
import 'package:strapen_app/app/shared/components/dialog/error_dialog.dart';
import 'package:strapen_app/app/shared/components/form/validator.dart';
import 'package:strapen_app/app/shared/components/sized_box/vertical_sized_box.dart';
import 'package:strapen_app/app/shared/components/widgets/text_field_senha.dart';

class RegistroPage6 extends StatefulWidget {
  @override
  _RegistroPage6State createState() => _RegistroPage6State();
}

class _RegistroPage6State extends State<RegistroPage6> {
  final RegistroController controller = Modular.get<RegistroController>();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _senhaController = TextEditingController();
  final TextEditingController _confirmarSenhaController = TextEditingController();
  final FocusNode _senhaFocus = FocusNode();
  final FocusNode _confirmarSenhaFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    return RegistroWidget(
      title: "Informe uma senha!",
      subtitle: "Escolha uma senha com pelo menos 8 caracteres.",
      children: [
        Form(
          key: _formKey,
          child: Column(
            children: [
              Observer(
                builder: (_) => TextFieldSenha(
                  controller: _senhaController,
                  visible: controller.visibleSenha,
                  validator: InputSenhaValidator().validate,
                  enabled: !controller.loading,
                  textInputAction: TextInputAction.next,
                  focusNode: _senhaFocus,
                  onFieldSubmitted: (_) => controller.focusChange(context, _senhaFocus, _confirmarSenhaFocus),
                  onPressed: () => controller.setVisibleSenha(!controller.visibleSenha),
                  onSaved: controller.userStore.setSenha,
                ),
              ),
              const VerticalSizedBox(2),
              Observer(
                builder: (_) => TextFieldSenha(
                  controller: _confirmarSenhaController,
                  visible: controller.visibleConfirmarSenha,
                  validator: InputSenhaValidator().validate,
                  enabled: !controller.loading,
                  textInputAction: TextInputAction.done,
                  focusNode: _confirmarSenhaFocus,
                  onFieldSubmitted: (_) => _confirmarSenhaFocus.unfocus(),
                  onPressed: () => controller.setVisibleConfirmarSenha(!controller.visibleConfirmarSenha),
                  onSaved: controller.userStore.setConfirmarSenha,
                  onChanged: (String value) => controller.setShowErrorEqualsSenha(false),
                  label: "Confirmar senha",
                ),
              ),
              const VerticalSizedBox(1),
              Observer(
                builder: (_) => Visibility(
                  visible: !controller.userStore.equalsSenha,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "As senhas não conferem!",
                        style: Theme.of(context).textTheme.bodyText1!.copyWith(color: AppColors.error),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
      descriptionButton: "Finalizar cadastro",
      onPressed: () async {
        _senhaFocus.unfocus();
        _confirmarSenhaFocus.unfocus();

        await controller.onSavedForm(
          context,
          _formKey,
              () async {
            try {
              await controller.finalizarCadastro();
            } catch (e) {
              ErrorDialog.show(context: context, content: e.toString());
            }
          },
        );
      }
    );
  }

  @override
  void dispose() {
    _senhaController.dispose();
    _confirmarSenhaController.dispose();
    _senhaFocus.dispose();
    _confirmarSenhaFocus.dispose();
    super.dispose();
  }
}
