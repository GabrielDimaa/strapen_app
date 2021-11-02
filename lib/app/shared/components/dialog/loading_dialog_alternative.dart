import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:strapen_app/app/app_widget.dart';
import 'package:strapen_app/app/shared/components/sized_box/vertical_sized_box.dart';

class LoadingDialogAlternative extends StatefulWidget {
  final String mensagem;

  const LoadingDialogAlternative({required this.mensagem});

  @override
  _LoadingDialogAlternativeState createState() => _LoadingDialogAlternativeState();

  static Future show(BuildContext context, String mensagem, Function action) async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => LoadingDialogAlternative(mensagem: mensagem),
      );

      await action.call();
    } finally {
      Modular.to.pop();
    }
  }
}

class _LoadingDialogAlternativeState extends State<LoadingDialogAlternative> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.primary,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(color: Colors.white),
          const VerticalSizedBox(2),
          Text(widget.mensagem, style: TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
