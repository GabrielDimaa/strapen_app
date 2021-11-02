import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:strapen_app/app/modules/auth/controllers/auth_controller.dart';
import 'package:strapen_app/app/shared/components/loading/linear_loading.dart';
import 'package:strapen_app/app/shared/components/sized_box/vertical_sized_box.dart';

class EmailVerifiedDialog extends StatefulWidget {
  @override
  _EmailVerifiedDialogState createState() => _EmailVerifiedDialogState();

  static show(BuildContext context) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return EmailVerifiedDialog();
      },
    );
  }
}

class _EmailVerifiedDialogState extends State<EmailVerifiedDialog> {
  final AuthController controller = Modular.get<AuthController>();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Ops!"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("E-mail ainda não foi verificado!\nConfira sua caixa de entrada e verifique o E-mail."),
          const VerticalSizedBox(1.5),
          Observer(
            builder: (_) => LinearLoading(visible: controller.loading),
          ),
        ],
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => Modular.to.pop(),
                child: const Text("Cancelar"),
              ),
              TextButton(
                onPressed: () async {
                  await controller.reenviarEmail();
                  Modular.to.pop();
                },
                child: const Text("Reenviar e-mail"),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
