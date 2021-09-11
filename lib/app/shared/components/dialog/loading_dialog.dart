import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:strapen_app/app/shared/components/sized_box/vertical_sized_box.dart';

class LoadingDialog extends StatefulWidget {
  final String mensagem;

  const LoadingDialog({required this.mensagem});

  @override
  _LoadingDialogState createState() => _LoadingDialogState();

  static Future show(BuildContext context, String mensagem, Function action) async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => LoadingDialog(mensagem: mensagem),
      );

      await action.call();
    } finally {
      Modular.to.pop();
    }
  }
}

class _LoadingDialogState extends State<LoadingDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const VerticalSizedBox(2),
          Text(widget.mensagem),
        ],
      ),
    );
  }
}
