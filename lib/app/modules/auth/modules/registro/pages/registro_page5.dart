import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:strapen_app/app/modules/auth/modules/registro/components/registro_widget.dart';
import 'package:strapen_app/app/modules/auth/modules/registro/controllers/registro_controller.dart';
import 'package:strapen_app/app/modules/user/constants/columns.dart';
import 'package:strapen_app/app/shared/components/dialog/error_dialog.dart';
import 'package:strapen_app/app/shared/components/form/validator.dart';
import 'package:strapen_app/app/shared/components/text_input/text_input_default.dart';

class RegistroPage5 extends StatefulWidget {
  @override
  _RegistroPage5State createState() => _RegistroPage5State();
}

class _RegistroPage5State extends State<RegistroPage5> {
  final RegistroController controller = Modular.get<RegistroController>();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final FocusNode _usernameFocus = FocusNode();

  @override
  void initState() {
    super.initState();

    _usernameController.text = controller.userStore.username ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return RegistroWidget(
        title: "Falta pouco para concluírmos!",
        subtitle: "O nome de usuário será seu identificador no aplicativo. Você poderá criar da seguinte maneira: @nome_sobrenome",
        children: [
          Form(
            key: _formKey,
            child: Observer(
              builder: (_) => TextFormField(
                decoration: InputDecorationDefault(
                  label: "Nome de usuário",
                  prefixText: "@",
                ),
                controller: _usernameController,
                textInputAction: TextInputAction.done,
                textCapitalization: TextCapitalization.sentences,
                enabled: !controller.loading,
                focusNode: _usernameFocus,
                onFieldSubmitted: (_) => _usernameFocus.unfocus(),
                validator: InputUserNameValidator().validate,
                onSaved: (String? value) => controller.userStore.setUserName(value),
              ),
            ),
          ),
        ],
        onPressed: () async {
          _usernameFocus.unfocus();

          await controller.onSavedForm(context, _formKey, () async {
            try {
              await controller.existsData(
                USERNAME_COLUMN,
                _usernameController.text,
                "Nome de usuário já está em uso.",
              );
              await controller.nextPage(6);
            } catch (e) {
              ErrorDialog.show(context: context, content: e.toString());
            }
          });
        });
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _usernameFocus.dispose();
    super.dispose();
  }
}
