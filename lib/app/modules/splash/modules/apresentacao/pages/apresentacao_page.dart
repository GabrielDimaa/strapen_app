import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:strapen_app/app/app_widget.dart';
import 'package:strapen_app/app/modules/splash/modules/apresentacao/controllers/apresentacao_controller.dart';
import 'package:strapen_app/app/shared/components/button/elevated_button_default.dart';
import 'package:strapen_app/app/shared/components/image/vetor.dart';
import 'package:strapen_app/app/shared/components/padding/padding_scaffold.dart';
import 'package:strapen_app/app/shared/components/scaffold/scaffold_gradiente.dart';
import 'package:strapen_app/app/shared/components/sized_box/vertical_sized_box.dart';

class ApresentacaoPage extends StatefulWidget {
  const ApresentacaoPage({Key? key}) : super(key: key);

  @override
  _ApresentacaoPageState createState() => _ApresentacaoPageState();
}

class _ApresentacaoPageState extends State<ApresentacaoPage> {
  final ApresentacaoController controller = Modular.get<ApresentacaoController>();

  @override
  Widget build(BuildContext context) {
    return ScaffoldGradiente(
      padding: const PaddingScaffold(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const VerticalSizedBox(5),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const VerticalSizedBox(2),
                  Text("Olá, seja bem-vindo ao Strapen", style: Theme.of(context).textTheme.headline4),
                  const VerticalSizedBox(4),
                  const Vetor(path: "assets/images/garota_tirando_selfie.png"),
                ],
              ),
            ),
          ),
          ElevatedButtonDefault(
            child: Text("Vamos começar"),
            primary: AppColors.secondary,
            onPrimary: AppColors.primary,
            onPressed: controller.toNextApresentacao,
          ),
        ],
      ),
    );
  }
}
