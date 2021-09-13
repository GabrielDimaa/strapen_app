import 'package:flutter/material.dart';
import 'package:strapen_app/app/shared/components/date_picker/cupertino_date.dart';
import 'package:strapen_app/app/shared/components/form/validator.dart';
import 'package:strapen_app/app/shared/components/text_input/text_input_default.dart';
import 'package:strapen_app/app/shared/extensions/datetime_extension.dart';

class TextFieldDataNascimento extends StatelessWidget {
  final bool sufixIconVisible;
  final TextEditingController controller;
  final bool enabled;
  final FocusNode focusNode;
  final VoidCallback onClear;
  final Function(DateTime) setDataStore;

  const TextFieldDataNascimento({
    required this.sufixIconVisible,
    required this.controller,
    required this.enabled,
    required this.focusNode,
    required this.onClear,
    required this.setDataStore,
  });

  @override
  Widget build(BuildContext context) {
    bool clear = false;
    return TextFormField(
      decoration: InputDecorationDefault(
        label: "Data de nascimento",
        sufixIcon: Visibility(
          visible: sufixIconVisible,
          child: IconButton(
            icon: Icon(Icons.cancel_outlined, color: Colors.grey[200]),
            onPressed: () {
              controller.clear();
              onClear.call();
              clear = true;
            },
          ),
        ),
      ),
      controller: controller,
      readOnly: true,
      enabled: enabled,
      validator: InputDateValidator().validate,
      focusNode: focusNode,
      onTap: () async {
        if (!clear) {
          DateTime? date = await CupertinoDate.show(context);
          if (date != null) {
            controller.text = date.formated;
            setDataStore.call(date);
          }
        } else {
          clear = false;
        }
      },
    );
  }
}
