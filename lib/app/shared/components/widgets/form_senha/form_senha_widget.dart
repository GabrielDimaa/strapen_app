import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:strapen_app/app/app_widget.dart';
import 'package:strapen_app/app/shared/components/sized_box/vertical_sized_box.dart';
import 'package:strapen_app/app/shared/components/widgets/text_field_senha.dart';

import 'form_senha_controller.dart';

class FormSenhaWidget extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final bool enabled;
  final Function(String?)? onSavedSenha;
  final Function(String?)? onSavedConfirmarSenha;

  const FormSenhaWidget({
    required this.formKey,
    required this.enabled,
    required this.onSavedSenha,
    required this.onSavedConfirmarSenha,
  });

  @override
  _FormSenhaWidgetState createState() => _FormSenhaWidgetState();
}

class _FormSenhaWidgetState extends State<FormSenhaWidget> {
  final FormSenhaController controller = FormSenhaController();
  final TextEditingController _senhaController = TextEditingController();
  final TextEditingController _confirmarSenhaController = TextEditingController();
  final FocusNode _senhaFocus = FocusNode();
  final FocusNode _confirmarSenhaFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        children: [
          Observer(
            builder: (_) => TextFieldSenha(
              controller: _senhaController,
              visible: controller.visibleSenha,
              enabled: widget.enabled,
              textInputAction: TextInputAction.next,
              focusNode: _senhaFocus,
              onFieldSubmitted: (_) => controller.focusChange(context, _senhaFocus, _confirmarSenhaFocus),
              onPressed: () => controller.setVisibleSenha(!controller.visibleSenha),
              onChanged: controller.setSenhaChanged,
              onSaved: widget.onSavedSenha,
            ),
          ),
          const VerticalSizedBox(2),
          Observer(
            builder: (_) => TextFieldSenha(
              controller: _confirmarSenhaController,
              visible: controller.visibleConfirmarSenha,
              enabled: widget.enabled,
              textInputAction: TextInputAction.done,
              focusNode: _confirmarSenhaFocus,
              onFieldSubmitted: (_) => _confirmarSenhaFocus.unfocus(),
              onPressed: () => controller.setVisibleConfirmarSenha(!controller.visibleConfirmarSenha),
              onSaved: widget.onSavedConfirmarSenha,
              onChanged: controller.setConfirmarSenhaChanged,
              label: "Confirmar senha",
            ),
          ),
          const VerticalSizedBox(1),
          Observer(
            builder: (_) => Visibility(
              visible: !controller.equalsSenha,
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
    );
  }

  @override
  void dispose() {
    super.dispose();
    _senhaController.dispose();
    _confirmarSenhaController.dispose();
    _senhaFocus.dispose();
    _confirmarSenhaFocus.dispose();
  }
}
