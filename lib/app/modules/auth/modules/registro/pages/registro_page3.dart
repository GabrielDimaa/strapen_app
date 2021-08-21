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
  final TextEditingController _cepController = TextEditingController();
  final TextEditingController _cidadeController = TextEditingController();
  final FocusNode _cepFocus = FocusNode();
  final FocusNode _cidadeFocus = FocusNode();

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
              TextFormField(
                decoration: InputDecorationDefault(
                  label: "CEP",
                ),
                controller: _cepController,
                keyboardType: TextInputType.number,
                validator: InputCepValidator().validate,
                textInputAction: TextInputAction.next,
                focusNode: _cepFocus,
                onFieldSubmitted: (_) => controller.focusChange(context, _cepFocus, _cidadeFocus),
                onSaved: (String? value) {
                  controller.userStore.setCep(value.extrairNum());
                },
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  CepInputFormatter(),
                ],
              ),
              const VerticalSizedBox(2),
              TextFormField(
                decoration: InputDecorationDefault(label: "Cidade"),
                controller: _cidadeController,
                validator: InputValidatorDefault().validate,
                onSaved: controller.userStore.setCidade,
                textInputAction: TextInputAction.done,
                focusNode: _cidadeFocus,
                onFieldSubmitted: (_) => _cidadeFocus.unfocus(),
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
    _cepController.dispose();
    _cidadeController.dispose();
    _cepFocus.dispose();
    _cidadeFocus.dispose();
    super.dispose();
  }
}
