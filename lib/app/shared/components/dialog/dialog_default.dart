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
  final Color? backgroundColor;
  final Color? colorAction;

  const DialogDefault({
    required this.context,
    this.content,
    this.title,
    this.labelButtonDefault,
    this.actions,
    this.backgroundColor,
    this.colorAction,
  });

  static show({
    required BuildContext context,
    required Widget content,
    Widget? title,
    String? labelButtonDefault,
    List<Widget>? actions,
    Color? backgroundColor,
    Color? colorAction,
    bool barrierDismissible = true,
  }) async {
    return await showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) {
        return DialogDefault(
          context: context,
          content: content,
          title: title,
          labelButtonDefault: labelButtonDefault,
          actions: actions,
          backgroundColor: backgroundColor,
          colorAction: colorAction,
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
      backgroundColor: widget.backgroundColor,
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => Modular.to.pop(false),
                child: Text(
                  widget.labelButtonDefault ?? "Cancelar",
                  style: TextStyle(color: widget.colorAction),
                ),
              ),
            ]..addAll(widget.actions ?? []),
          ),
        ),
      ],
    );
  }
}
