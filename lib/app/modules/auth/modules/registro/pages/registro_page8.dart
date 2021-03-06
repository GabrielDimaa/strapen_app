import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:strapen_app/app/modules/auth/modules/registro/components/registro_widget.dart';
import 'package:strapen_app/app/modules/auth/modules/registro/controllers/registro_controller.dart';
import 'package:strapen_app/app/shared/components/dialog/error_dialog.dart';
import 'package:strapen_app/app/shared/components/widgets/form_senha/form_senha_widget.dart';

class RegistroPage8 extends StatefulWidget {
  @override
  _RegistroPage8State createState() => _RegistroPage8State();
}

class _RegistroPage8State extends State<RegistroPage8> {
  final RegistroController controller = Modular.get<RegistroController>();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return RegistroWidget(
      title: "Informe uma senha!",
      subtitle: "Escolha uma senha com pelo menos 8 caracteres.",
      children: [
        FormSenhaWidget(
          formKey: _formKey,
          enabled: !controller.loading,
          onSavedSenha: controller.userStore.setSenha,
          onSavedConfirmarSenha: controller.userStore.setConfirmarSenha,
        ),
      ],
      descriptionButton: "Finalizar cadastro",
      onPressed: () async {
        await controller.onSavedForm(
          context,
          _formKey,
          () async {
            try {
              await controller.finalizarCadastro(context);
            } catch (e) {
              ErrorDialog.show(context: context, content: e.toString());
            }
          },
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
