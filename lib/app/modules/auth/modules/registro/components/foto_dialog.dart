import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:strapen_app/app/modules/auth/constants/routes.dart';
import 'package:strapen_app/app/modules/auth/modules/registro/constants/routes.dart';
import 'package:strapen_app/app/modules/auth/modules/registro/controllers/registro_controller.dart';
import 'package:strapen_app/app/shared/components/loading/linear_loading.dart';
import 'package:strapen_app/app/shared/components/sized_box/vertical_sized_box.dart';

class FotoDialog extends StatefulWidget {
  @override
  _FotoDialogState createState() => _FotoDialogState();

  static show(BuildContext context) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return FotoDialog();
      },
    );
  }
}

class _FotoDialogState extends State<FotoDialog> {
  final RegistroController controller = Modular.get<RegistroController>();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Ops!"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("Não foi possível salvar sua foto do perfil. Verifique sua conexão com a internet!"),
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
                onPressed: () => Modular.to.navigate(AUTH_ROUTE + REGISTRO_ROUTE + REGISTRO_CONCLUIDO_ROUTE),
                child: const Text("Pular"),
              ),
              TextButton(
                onPressed: () async => await controller.salvarFoto(context),
                child: const Text("Tentar novamente"),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
