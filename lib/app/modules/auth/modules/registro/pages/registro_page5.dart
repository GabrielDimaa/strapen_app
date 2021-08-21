import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:strapen_app/app/modules/auth/modules/registro/components/registro_widget.dart';
import 'package:strapen_app/app/modules/auth/modules/registro/controllers/registro_controller.dart';
import 'package:strapen_app/app/shared/components/form/validator.dart';
import 'package:strapen_app/app/shared/components/text_input/text_input_default.dart';

class RegistroPage5 extends StatefulWidget {
  @override
  _RegistroPage5State createState() => _RegistroPage5State();
}

class _RegistroPage5State extends State<RegistroPage5> {
  final RegistroController controller = Modular.get<RegistroController>();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nomeUsuario = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return RegistroWidget(
      title: "Falta pouco para concluírmos!",
      subtitle: "O nome de usuário será seu identificador no aplicativo. Você poderá criar da seguinte maneira: @nome_sobrenome",
      children: [
        Form(
          key: _formKey,
          child: TextInputDefault(
            controller: _nomeUsuario,
            label: "Nome de usuário",
            prefixText: "@",
            validator: InputUserNameValidator().validate,
            onSaved: (String? value) => controller.userStore.setUserName(value),
          ),
        ),
      ],
      onPressed: () async => await controller.onSavedForm(
        context,
        _formKey,
        () async => await controller.nextPage(6),
      ),
    );
  }

  @override
  void dispose() {
    _nomeUsuario.dispose();
    super.dispose();
  }
}
