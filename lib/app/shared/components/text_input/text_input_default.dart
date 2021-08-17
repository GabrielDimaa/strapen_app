import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextInputDefault extends StatelessWidget {
  final TextEditingController controller;
  final String? initialValue;
  final TextInputType? keyboardType;
  final bool autoFocus;
  final bool readOnly;
  final bool obscureText;
  final void Function(String)? onChanged;
  final VoidCallback? onTap;
  final void Function(String?)? onSaved;
  final Color? colorStyle;
  final bool? enabled;
  final List<TextInputFormatter>? inputFormatters;
  final String Function(String?)? validator;
  final String label;
  final Widget? prefixIcon;
  final Widget? sufixIcon;

  const TextInputDefault({
    required this.controller,
    this.initialValue,
    this.keyboardType,
    this.autoFocus = false,
    this.readOnly = false,
    this.obscureText = false,
    this.onChanged,
    this.onTap,
    this.onSaved,
    this.colorStyle,
    this.enabled,
    this.inputFormatters,
    this.validator,
    required this.label,
    this.prefixIcon,
    this.sufixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      initialValue: initialValue,
      keyboardType: keyboardType,
      autofocus: autoFocus,
      obscureText: obscureText,
      readOnly: readOnly,
      onChanged: onChanged,
      onTap: onTap,
      onSaved: onSaved,
      cursorColor: colorStyle,
      enabled: enabled,
      inputFormatters: inputFormatters,
      style: TextStyle(color: Colors.white, fontSize: 16),
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: prefixIcon != null ? Padding(
          padding: const EdgeInsets.only(left: 8),
          child: prefixIcon,
        ) : null,
        suffixIcon: sufixIcon != null ? Padding(
          padding: const EdgeInsets.only(right: 8),
          child: sufixIcon,
        ) : null,
      ),
    );
  }
}
