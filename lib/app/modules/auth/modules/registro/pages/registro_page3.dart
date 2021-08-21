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

class RegistroPage3 extends StatefulWidget {
  @override
  _RegistroPage3State createState() => _RegistroPage3State();
}

class _RegistroPage3State extends State<RegistroPage3> {
  final RegistroController controller = Modular.get<RegistroController>();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _cep = TextEditingController();
  final TextEditingController _cidade = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return RegistroWidget(
      title: "Nos diga seu endereço!",
      subtitle: "Informe a cidade e CEP que você vive.",
      children: [
        Form(
          key: _formKey,
          child: Column(
            children: [
              TextInputDefault(
                controller: _cep,
                label: "CEP",
                keyboardType: TextInputType.number,
                validator: InputCepValidator().validate,
                onSaved: (String? value) {
                  controller.userStore.setCep(value.extrairNum());
                },
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  CepInputFormatter()
                ],
              ),
              const VerticalSizedBox(2),
              TextInputDefault(
                controller: _cidade,
                label: "Cidade",
                validator: InputValidatorDefault().validate,
                onSaved: controller.userStore.setCidade,
              ),
            ],
          ),
        ),
      ],
      onPressed: () async => await controller.onSavedForm(
        context,
        _formKey,
        () async => await controller.nextPage(4),
      ),
    );
  }

  @override
  void dispose() {
    _cep.dispose();
    _cidade.dispose();
    super.dispose();
  }
}
