import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class SairDialog extends StatefulWidget {
  final Color? backgroundColor;

  const SairDialog({this.backgroundColor});

  @override
  _SairDialogState createState() => _SairDialogState();

  static Future<bool> show(BuildContext context, {Color? backgroundColor}) async {
    return await showDialog(
      context: context,
      builder: (_) => SairDialog(
        backgroundColor: backgroundColor,
      ),
    ) as bool;
  }
}

class _SairDialogState extends State<SairDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: widget.backgroundColor,
      title: const Text("Sair"),
      content: const Text("Deseja mesmo sair do Strapen?"),
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
                  "Cancelar",
                  style: widget.backgroundColor != null ? TextStyle(color: Colors.white) : null,
                ),
              ),
              TextButton(
                onPressed: () => Modular.to.pop(true),
                child: Text(
                  "Sair",
                  style: widget.backgroundColor != null ? TextStyle(color: Colors.white) : null,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
