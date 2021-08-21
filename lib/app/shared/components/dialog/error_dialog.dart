import 'package:flutter/material.dart';
import 'package:strapen_app/app/shared/components/dialog/dialog_default.dart';

class ErrorDialog extends StatefulWidget {
  final String content;
  final List<Widget>? actions;

  const ErrorDialog({required BuildContext context, required this.content, this.actions});

  static DialogDefault show({
    required BuildContext context,
    required String content,
    String? title,
    List<Widget>? actions,
  }) {
    return DialogDefault.show(
      title: Text(title ?? "Algo deu errado..."),
      context: context,
      actions: actions,
      content: ErrorDialog(
        context: context,
        content: content,
      ),
    );
  }

  @override
  _ErrorDialogState createState() => _ErrorDialogState();
}

class _ErrorDialogState extends State<ErrorDialog> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(widget.content.replaceAll("Exception: ", "")),
      ],
    );
  }
}
