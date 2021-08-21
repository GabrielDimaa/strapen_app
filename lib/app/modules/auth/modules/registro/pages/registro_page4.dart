import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:strapen_app/app/modules/auth/modules/registro/components/radio_button_widget.dart';
import 'package:strapen_app/app/modules/auth/modules/registro/components/registro_widget.dart';
import 'package:strapen_app/app/modules/auth/modules/registro/controllers/registro_controller.dart';
import 'package:strapen_app/app/modules/user/constants/columns.dart';
import 'package:strapen_app/app/shared/components/dialog/error_dialog.dart';
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
  void initState() {
    super.initState();

    _cpfCnpjController.text = controller.userStore.cpfCnpj ?? "";
  }

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
                      onTap: !controller.loading ? onTap : null,
                      onChaged: (bool? value) => !controller.loading ? onTap.call() : null,
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
                      onTap: !controller.loading ? onTap : null,
                      onChaged: (bool? value) => !controller.loading ? onTap.call() : null,
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
                  enabled: !controller.loading,
                  focusNode: _cpfCnpjFocus,
                  onFieldSubmitted: (_) => _cpfCnpjFocus.unfocus(),
                  onSaved: (String? value) {
                    controller.userStore.setCpfCnpj(value.extrairNum());
                  },
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    controller.isCpf ? CpfInputFormatter() : CnpjInputFormatter(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
      onPressed: () async {
        _cpfCnpjFocus.unfocus();

        await controller.onSavedForm(context, _formKey, () async {
          try {
            await controller.existsData(
              CPFCNPJ_COLUMN,
              _cpfCnpjController.text.extrairNum(),
              "Já existe esse ${controller.isCpf ? "CPF" : "CNPJ"} cadastrado no Strapen.",
            );
            await controller.nextPage(5);
          } catch (e) {
            ErrorDialog.show(context: context, content: e.toString());
          }
        });
      },
    );
  }

  @override
  void dispose() {
    _cpfCnpjController.dispose();
    _cpfCnpjFocus.dispose();
    super.dispose();
  }
}
