import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:strapen_app/app/modules/auth/modules/registro/components/registro_widget.dart';
import 'package:strapen_app/app/modules/auth/modules/registro/controllers/registro_controller.dart';
import 'package:strapen_app/app/shared/components/widgets/text_field_bio.dart';

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
          child: TextFieldBio(
            controller: _bioController,
            bio: controller.userStore.bio,
            enabled: !controller.loading,
            focusNode: _bioFocus,
            onFieldSubmitted: (_) => _bioFocus.unfocus(),
            onSaved: controller.userStore.setBio,
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
          _bioController.clear();
          _bioFocus.unfocus();
          controller.userStore.setBio(null);
          await controller.nextPage(4);
        },
      ),
    );
  }
}
