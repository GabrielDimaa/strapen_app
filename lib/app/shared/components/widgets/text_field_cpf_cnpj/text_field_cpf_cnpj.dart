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
import 'package:strapen_app/app/shared/extensions/string_extension.dart';

class TextFieldCpfCnpj extends StatefulWidget {
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
  State<TextFieldCpfCnpj> createState() => _TextFieldCpfCnpjState();
}

class _TextFieldCpfCnpjState extends State<TextFieldCpfCnpj> {
  final CpfCnpjController controller = CpfCnpjController();

  @override
  void initState() {
    super.initState();

    controller.setIsCpf(!(widget.textController.text.length > 11));

    if (widget.textController.text.notIsNullOrEmpty()) {
      if (UtilBrasilFields.isCPFValido(widget.textController.text))
        widget.textController.text = UtilBrasilFields.obterCpf(widget.textController.text);
      else if (UtilBrasilFields.isCNPJValido(widget.textController.text))
        widget.textController.text = UtilBrasilFields.obterCnpj(widget.textController.text);
    }
  }

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
                widget.textController.clear();
              };

              return RadioButtonWidget(
                title: "CPF",
                onTap: widget.enabled ? onTap : null,
                onChaged: (bool? value) => widget.enabled ? onTap.call() : null,
                value: controller.isCpf,
                groupValue: true,
              );
            }),
            const HorizontalSizedBox(2),
            Observer(builder: (_) {
              void Function() onTap = () {
                controller.setIsCpf(false);
                widget.textController.clear();
              };

              return RadioButtonWidget(
                title: "CNPJ",
                onTap: widget.enabled ? onTap : null,
                onChaged: (bool? value) => widget.enabled ? onTap.call() : null,
                value: controller.isCpf,
                groupValue: false,
              );
            }),
          ],
        ),
        const VerticalSizedBox(),
        Observer(
          builder: (_) => TextFormField(
            decoration: InputDecorationDefault(labelText: controller.isCpf ? "CPF" : "CNPJ"),
            controller: widget.textController,
            keyboardType: TextInputType.number,
            validator: InputCpfCnpjValidator(isCnpj: !controller.isCpf).validate,
            textInputAction: TextInputAction.done,
            enabled: widget.enabled,
            focusNode: widget.focusNode,
            onFieldSubmitted: widget.onFieldSubmitted,
            onSaved: widget.onSaved,
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
