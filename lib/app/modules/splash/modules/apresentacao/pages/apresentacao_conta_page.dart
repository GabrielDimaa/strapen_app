import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:strapen_app/app/modules/splash/modules/apresentacao/controllers/apresentacao_controller.dart';
import 'package:strapen_app/app/shared/components/button/elevated_button_default.dart';
import 'package:strapen_app/app/shared/components/button/outlined_button_default.dart';
import 'package:strapen_app/app/shared/components/image/vetor.dart';
import 'package:strapen_app/app/shared/components/padding/padding_scaffold.dart';
import 'package:strapen_app/app/shared/components/sized_box/vertical_sized_box.dart';

class ApresentacaoContaPage extends StatefulWidget {
  const ApresentacaoContaPage({Key? key}) : super(key: key);

  @override
  _ApresentacaoContaPageState createState() => _ApresentacaoContaPageState();
}

class _ApresentacaoContaPageState extends State<ApresentacaoContaPage> {
  final ApresentacaoController controller = Modular.get<ApresentacaoController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const PaddingScaffold(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const VerticalSizedBox(5),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Text("Já possui uma conta?", style: Theme.of(context).textTheme.headline4),
                    const VerticalSizedBox(4),
                    const Vetor(path: "assets/images/escrevendo_pc.png"),
                  ],
                ),
              ),
            ),
            ElevatedButtonDefault(
              child: Text("Já tenho uma conta"),
              onPressed: controller.toAuth,
            ),
            const VerticalSizedBox(),
            OutlinedButtonDefault(
              child: Text("Registrar-se"),
              onPressed: controller.toRegistro,
            ),
          ],
        ),
      ),
    );
  }
}
