import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:strapen_app/app/modules/auth/modules/registro/components/registro_widget.dart';
import 'package:strapen_app/app/modules/auth/modules/registro/controllers/registro_controller.dart';
import 'package:strapen_app/app/shared/components/form/validator.dart';
import 'package:strapen_app/app/shared/components/text_input/text_input_default.dart';

class RegistroPage3 extends StatefulWidget {
  @override
  _RegistroPage3State createState() => _RegistroPage3State();
}

class _RegistroPage3State extends State<RegistroPage3> {
  final RegistroController controller = Modular.get<RegistroController>();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _bioController = TextEditingController();
  final FocusNode _bioFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _bioController.text = controller.userStore.bio ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return RegistroWidget(
      title: "Sua Biografia!",
      subtitle: "A Bio será exibida no seu perfil para os outros usuários.",
      children: [
        Form(
          key: _formKey,
          child: TextFormField(
            decoration: InputDecorationDefault(
              labelText: "Bio",
              alignLabelWithHint: true,
            ),
            controller: _bioController,
            keyboardType: TextInputType.emailAddress,
            validator: InputValidatorDefault(message: "Campo Bio não pode estar vazio.").validate,
            enabled: !controller.loading,
            textInputAction: TextInputAction.next,
            onSaved: controller.userStore.setEmail,
            focusNode: _bioFocus,
            minLines: 2,
            maxLines: 6,
            maxLength: 200,
            onFieldSubmitted: (_) => _bioFocus.unfocus(),
          ),
        ),
      ],
      onPressed: () async {
        _bioFocus.unfocus();

        await controller.onSavedForm(
          context,
          _formKey,
          () async => await controller.nextPage(4),
        );
      },
      extraButton: TextButton(
        child: Text("Pular"),
        onPressed: () async {
          _bioFocus.unfocus();
          await controller.nextPage(4);
        },
      ),
    );
  }
}
