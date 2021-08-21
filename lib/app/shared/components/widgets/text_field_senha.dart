import 'package:flutter/material.dart';
import 'package:strapen_app/app/shared/components/text_input/text_input_default.dart';

class TextFieldSenha extends StatelessWidget {
  final TextEditingController controller;
  final bool visible;
  final bool? enabled;
  final void Function() onPressed;
  final Function(String?)? onSaved;
  final String label;
  final String? Function(String?)? validator;
  final Function(String)? onChanged;
  final FocusNode? focusNode;
  final Function(String)? onFieldSubmitted;
  final TextInputAction? textInputAction;

  const TextFieldSenha({
    required this.controller,
    required this.visible,
    this.enabled,
    required this.onPressed,
    required this.onSaved,
    this.label = "Senha",
    this.validator,
    this.onChanged,
    this.focusNode,
    this.onFieldSubmitted,
    this.textInputAction,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecorationDefault(
        label: label,
        prefixIcon: Icon(Icons.lock, color: Colors.grey[200]),
        sufixIcon: IconButton(
          onPressed: onPressed,
          icon: Icon(
            !visible ? Icons.visibility : Icons.visibility_off,
            color: Colors.grey[200],
          ),
        ),
      ),
      controller: controller,
      obscureText: !visible,
      enabled: enabled,
      validator: validator,
      onSaved: onSaved,
      onChanged: onChanged,
      focusNode: focusNode,
      onFieldSubmitted: onFieldSubmitted,
      textInputAction: textInputAction,
    );
  }
}
