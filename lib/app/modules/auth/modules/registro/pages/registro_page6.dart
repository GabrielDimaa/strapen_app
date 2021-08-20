import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:intl/intl.dart';
import 'package:strapen_app/app/app_widget.dart';
import 'package:strapen_app/app/modules/auth/modules/registro/components/registro_widget.dart';
import 'package:strapen_app/app/modules/auth/modules/registro/controllers/registro_controller.dart';
import 'package:strapen_app/app/shared/components/form/validator.dart';
import 'package:strapen_app/app/shared/components/sized_box/vertical_sized_box.dart';
import 'package:strapen_app/app/shared/components/text_input/text_input_default.dart';
import 'package:strapen_app/app/shared/components/widgets/text_field_senha.dart';

class RegistroPage6 extends StatefulWidget {
  @override
  _RegistroPage6State createState() => _RegistroPage6State();
}

class _RegistroPage6State extends State<RegistroPage6> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final RegistroController controller = Modular.get<RegistroController>();

  final TextEditingController _senha = TextEditingController();
  final TextEditingController _confirmarSenha = TextEditingController();

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
              TextFieldSenha(
                controller: _senha,
                visible: controller.visibleSenha,
                validator: InputSenhaValidator().validate,
                onPressed: () => controller.setVisibleSenha(!controller.visibleSenha),
                onSaved: controller.userStore.setSenha,
              ),
              const VerticalSizedBox(2),
              TextFieldSenha(
                controller: _confirmarSenha,
                visible: controller.visibleConfirmarSenha,
                validator: InputSenhaValidator().validate,
                onPressed: () => controller.setVisibleConfirmarSenha(!controller.visibleConfirmarSenha),
                onSaved: controller.userStore.setConfirmarSenha,
                onChanged: (String value) => controller.setShowErrorEqualsSenha(false),
                label: "Confirmar senha",
              ),
              const VerticalSizedBox(1),
              Observer(
                builder: (_) => Visibility(
                  visible: controller.showErrorEqualsSenha,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "As senhas não conferem!",
                      style: Theme.of(context).textTheme.bodyText1!.copyWith(color: AppColors.error),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
      descriptionButton: "Finalizar cadastro",
      onPressed: () async => await controller.onSavedForm(
        context,
        _formKey,
        () async => {},
      ),
    );
  }
}
