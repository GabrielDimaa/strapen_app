import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:strapen_app/app/modules/auth/modules/registro/components/radio_button_widget.dart';
import 'package:strapen_app/app/modules/auth/modules/registro/components/registro_widget.dart';
import 'package:strapen_app/app/modules/auth/modules/registro/controllers/registro_controller.dart';
import 'package:strapen_app/app/shared/components/form/validator.dart';
import 'package:strapen_app/app/shared/components/sized_box/horizontal_sized_box.dart';
import 'package:strapen_app/app/shared/components/sized_box/vertical_sized_box.dart';
import 'package:strapen_app/app/shared/components/text_input/text_input_default.dart';
import 'package:strapen_app/app/shared/extensions/string_extension.dart';

class RegistroPage4 extends StatefulWidget {
  @override
  _RegistroPage4State createState() => _RegistroPage4State();
}

class _RegistroPage4State extends State<RegistroPage4> {
  final RegistroController controller = Modular.get<RegistroController>();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _cpfCnpjController = TextEditingController();
  final FocusNode _cpfCnpjFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    return RegistroWidget(
      title: "Mais alguns dados para completar sua conta!",
      subtitle: "Insira seu CPF ou CNPJ caso seja uma conta empresarial.",
      children: [
        Form(
          key: _formKey,
          child: Column(
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Observer(builder: (_) {
                    void Function() onTap = () {
                      controller.setIsCpf(true);
                      _cpfCnpjController.clear();
                    };

                    return RadioButtonWidget(
                      title: "CPF",
                      onTap: onTap,
                      onChaged: (bool? value) => onTap.call(),
                      value: controller.isCpf,
                      groupValue: true,
                    );
                  }),
                  const HorizontalSizedBox(2),
                  Observer(builder: (_) {
                    void Function() onTap = () {
                      controller.setIsCpf(false);
                      _cpfCnpjController.clear();
                    };

                    return RadioButtonWidget(
                      title: "CNPJ",
                      onTap: onTap,
                      onChaged: (bool? value) => onTap.call(),
                      value: controller.isCpf,
                      groupValue: false,
                    );
                  }),
                ],
              ),
              const VerticalSizedBox(),
              Observer(
                builder: (_) => TextFormField(
                  decoration: InputDecorationDefault(label: controller.isCpf ? "CPF" : "CNPJ"),
                  controller: _cpfCnpjController,
                  keyboardType: TextInputType.number,
                  validator: InputCpfCnpjValidator(isCnpj: !controller.isCpf).validate,
                  textInputAction: TextInputAction.done,
                  focusNode: _cpfCnpjFocus,
                  onFieldSubmitted: (_) => _cpfCnpjFocus.unfocus(),
                  onSaved: (String? value) {
                    controller.userStore.setCpfCnpj(value.extrairNum());
                  },
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    controller.isCpf ? CpfOuCnpjFormatter() : CnpjInputFormatter(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
      onPressed: () async => await controller.onSavedForm(
        context,
        _formKey,
        () async => await controller.nextPage(5),
      ),
    );
  }

  @override
  void dispose() {
    _cpfCnpjController.dispose();
    _cpfCnpjFocus.dispose();
    super.dispose();
  }
}
