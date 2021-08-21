import 'package:flutter/material.dart';
import 'package:strapen_app/app/shared/components/text_input/text_input_default.dart';

class TextFieldSenha extends StatelessWidget {
  final TextEditingController controller;
  final bool visible;
  final void Function() onPressed;
  final Function(String?)? onSaved;
  final String label;
  final String? Function(String?)? validator;
  final Function(String)? onChanged;

  const TextFieldSenha({
    required this.controller,
    required this.visible,
    required this.onPressed,
    required this.onSaved,
    this.label = "Senha",
    this.validator,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextInputDefault(
      controller: controller,
      obscureText: !visible,
      label: label,
      prefixIcon: Icon(Icons.lock, color: Colors.grey[200]),
      validator: validator,
      onSaved: onSaved,
      onChanged: onChanged,
      sufixIcon: IconButton(
        onPressed: onPressed,
        icon: Icon(
          !visible ? Icons.visibility : Icons.visibility_off,
          color: Colors.grey[200],
        ),
      ),
    );
  }
}
