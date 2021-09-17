import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:strapen_app/app/shared/components/form/validator.dart';
import 'package:strapen_app/app/shared/components/sized_box/horizontal_sized_box.dart';
import 'package:strapen_app/app/shared/components/sized_box/vertical_sized_box.dart';
import 'package:strapen_app/app/shared/components/text_input/text_input_default.dart';
import 'package:strapen_app/app/shared/components/widgets/text_field_cpf_cnpj/cpf_cnpj_controller.dart';
import 'package:strapen_app/app/shared/components/widgets/text_field_cpf_cnpj/radio_button_widget.dart';

class TextFieldCpfCnpj extends StatelessWidget {
  final CpfCnpjController controller = CpfCnpjController();

  final bool enabled;
  final TextEditingController textController;
  final Function(String?) onSaved;
  final Function(String)? onFieldSubmitted;
  final FocusNode focusNode;

  TextFieldCpfCnpj({
    required this.enabled,
    required this.textController,
    required this.onSaved,
    required this.onFieldSubmitted,
    required this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Observer(builder: (_) {
              void Function() onTap = () {
                controller.setIsCpf(true);
                textController.clear();
              };

              return RadioButtonWidget(
                title: "CPF",
                onTap: enabled ? onTap : null,
                onChaged: (bool? value) => enabled ? onTap.call() : null,
                value: controller.isCpf,
                groupValue: true,
              );
            }),
            const HorizontalSizedBox(2),
            Observer(builder: (_) {
              void Function() onTap = () {
                controller.setIsCpf(false);
                textController.clear();
              };

              return RadioButtonWidget(
                title: "CNPJ",
                onTap: enabled ? onTap : null,
                onChaged: (bool? value) => enabled ? onTap.call() : null,
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
            controller: textController,
            keyboardType: TextInputType.number,
            validator: InputCpfCnpjValidator(isCnpj: !controller.isCpf).validate,
            textInputAction: TextInputAction.done,
            enabled: enabled,
            focusNode: focusNode,
            onFieldSubmitted: onFieldSubmitted,
            onSaved: onSaved,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              controller.isCpf ? CpfInputFormatter() : CnpjInputFormatter(),
            ],
          ),
        ),
      ],
    );
  }
}
