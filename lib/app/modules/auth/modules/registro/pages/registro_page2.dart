import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:strapen_app/app/modules/auth/modules/registro/components/registro_widget.dart';
import 'package:strapen_app/app/modules/auth/modules/registro/controllers/registro_controller.dart';
import 'package:strapen_app/app/shared/components/form/validator.dart';
import 'package:strapen_app/app/shared/components/sized_box/vertical_sized_box.dart';
import 'package:strapen_app/app/shared/components/text_input/text_input_default.dart';
import 'package:strapen_app/app/shared/extensions/string_extension.dart';

class RegistroPage2 extends StatefulWidget {
  @override
  _RegistroPage2State createState() => _RegistroPage2State();
}

class _RegistroPage2State extends State<RegistroPage2> {
  final RegistroController controller = Modular.get<RegistroController>();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _telefoneController = TextEditingController();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _telefoneFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    return RegistroWidget(
      title: "Conte-nos suas informações para contato!",
      subtitle: "Preencha os campos com um número de telefone e endereço de e-mail válido.",
      children: [
        Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecorationDefault(
                  label: "E-mail",
                  prefixIcon: Icon(Icons.email, color: Colors.grey[200]),
                ),
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                validator: InputEmailValidator().validate,
                textInputAction: TextInputAction.next,
                onSaved: controller.userStore.setEmail,
                focusNode: _emailFocus,
                onFieldSubmitted: (_) => controller.focusChange(context, _emailFocus, _telefoneFocus),
              ),
              const VerticalSizedBox(2),
              TextFormField(
                decoration: InputDecorationDefault(
                  label: "Telefone",
                  prefixIcon: Icon(Icons.contact_phone, color: Colors.grey[200]),
                ),
                controller: _telefoneController,
                keyboardType: TextInputType.phone,
                validator: InputTelefoneValidator().validate,
                textInputAction: TextInputAction.done,
                focusNode: _telefoneFocus,
                onFieldSubmitted: (_) => _telefoneFocus.unfocus(),
                onSaved: (String? value) {
                  controller.userStore.setTelefone(value.extrairNum());
                },
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  TelefoneInputFormatter(),
                ],
              ),
            ],
          ),
        ),
      ],
      onPressed: () async => await controller.onSavedForm(
        context,
        _formKey,
        () async => await controller.nextPage(3),
      ),
    );
  }

  @override
  void dispose() {
    _telefoneController.dispose();
    _emailController.dispose();
    _telefoneFocus.dispose();
    _emailFocus.dispose();
    super.dispose();
  }
}
