import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class DialogDefault extends StatefulWidget {
  @override
  _DialogDefaultState createState() => _DialogDefaultState();

  final BuildContext context;
  final Widget? content;
  final Widget? title;
  final String? labelButtonDefault;
  final List<Widget>? actions;

  const DialogDefault({
    required this.context,
    this.content,
    this.title,
    this.labelButtonDefault,
    this.actions,
  });

  static show({
    required BuildContext context,
    required Widget content,
    Widget? title,
    String? labelButtonDefault,
    List<Widget>? actions,
  }) async {
    return await showDialog(
      context: context,
      builder: (context) {
        return DialogDefault(
          context: context,
          content: content,
          title: title,
          labelButtonDefault: labelButtonDefault,
          actions: actions,
        );
      },
    );
  }
}

class _DialogDefaultState extends State<DialogDefault> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: widget.title,
      content: widget.content,
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(onPressed: () => Modular.to.pop(), child: Text(widget.labelButtonDefault ?? "Cancelar")),
            ]..addAll(widget.actions ?? []),
          ),
        ),
      ],
    );
  }
}
