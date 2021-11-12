import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:strapen_app/app/app_widget.dart';
import 'package:strapen_app/app/modules/auth/modules/registro/controllers/registro_controller.dart';
import 'package:strapen_app/app/shared/components/button/elevated_button_default.dart';
import 'package:strapen_app/app/shared/components/dialog/error_dialog.dart';
import 'package:strapen_app/app/shared/components/dialog/sair_dialog.dart';
import 'package:strapen_app/app/shared/components/image/vetor.dart';
import 'package:strapen_app/app/shared/components/padding/padding_scaffold.dart';
import 'package:strapen_app/app/shared/components/scaffold/scaffold_gradiente.dart';
import 'package:strapen_app/app/shared/components/sized_box/vertical_sized_box.dart';

class RegistroConcluidoPage extends StatefulWidget {
  @override
  _RegistroConcluidoPageState createState() => _RegistroConcluidoPageState();
}

class _RegistroConcluidoPageState extends State<RegistroConcluidoPage> {
  final RegistroController controller = Modular.get<RegistroController>();

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return ScaffoldGradiente(
      onWillPop: () async {
        return await SairDialog.show(context, backgroundColor: AppColors.primary);
      },
      padding: const PaddingScaffold(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const VerticalSizedBox(5),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text(
                    "Sua conta foi criada!",
                    textAlign: TextAlign.start,
                    style: textTheme.headline2,
                  ),
                  const VerticalSizedBox(2),
                  Text(
                    "Antes de iniciar, confirme seu e-mail para utilizar o Strapen.",
                    textAlign: TextAlign.start,
                    style: textTheme.headline1,
                  ),
                  const VerticalSizedBox(3.5),
                  Vetor(path: "assets/images/mulher_mexendo_mural.png"),
                ],
              ),
            ),
          ),
          TextButton(
            child: Text("Reenviar e-mail"),
            onPressed: () async => await controller.reenviarEmail(context),
            style: TextButton.styleFrom(
              primary: Colors.white,
            ),
          ),
          const VerticalSizedBox(),
          ElevatedButtonDefault(
            child: Text("Iniciar"),
            primary: Colors.white,
            onPrimary: AppColors.primary,
            onPressed: () async {
              try {
                await controller.toHome(context);
              } catch (e) {
                ErrorDialog.show(
                  context: context,
                  content: e.toString(),
                  backgroundColor: AppColors.primary,
                  colorAction: Colors.white,
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
