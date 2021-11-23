import 'package:flutter/material.dart';
import 'package:strapen_app/app/shared/components/form/validator.dart';
import 'package:strapen_app/app/shared/components/text_input/text_input_default.dart';

class TextFieldBio extends StatelessWidget {
  final TextEditingController controller;
  final String? bio;
  final bool enabled;
  final FocusNode? focusNode;
  final Function(String?)? onSaved;
  final Function(String)? onFieldSubmitted;
  final bool validate;

  TextFieldBio({
    required this.controller,
    this.bio,
    this.enabled = true,
    this.focusNode,
    this.onSaved,
    this.onFieldSubmitted,
    this.validate = true,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecorationDefault(
        labelText: "Bio",
        alignLabelWithHint: true,
      ),
      controller: controller,
      keyboardType: TextInputType.emailAddress,
      validator: validate ? InputValidatorDefault(message: "Campo Bio não pode estar vazio.").validate : null,
      enabled: enabled,
      textInputAction: TextInputAction.newline,
      textCapitalization: TextCapitalization.sentences,
      onSaved: onSaved,
      focusNode: focusNode,
      minLines: 2,
      maxLines: 6,
      maxLength: 200,
      onFieldSubmitted: onFieldSubmitted,
    );
  }
}
