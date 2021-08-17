import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:strapen_app/app/modules/auth/modules/registro/controllers/registro_controller.dart';
import 'package:strapen_app/app/shared/components/app_bar_default/app_bar_default.dart';
import 'package:strapen_app/app/shared/components/button/elevated_button_default.dart';
import 'package:strapen_app/app/shared/components/padding/padding_scaffold.dart';
import 'package:strapen_app/app/shared/components/sized_box/vertical_sized_box.dart';
import 'package:strapen_app/app/shared/components/text_input/text_input_default.dart';

class RegistroPage1 extends StatefulWidget {
  @override
  _RegistroPage1State createState() => _RegistroPage1State();
}

class _RegistroPage1State extends State<RegistroPage1> {
  final RegistroController controller = Modular.get<RegistroController>();

  final TextEditingController _nome = TextEditingController();
  final TextEditingController _dataNascimento = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBarDefault(),
      body: Padding(
        padding: const PaddingScaffold(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Text(
                      "Vamos criar sua conta rapidinho!",
                      style: textTheme.headline2,
                    ),
                    const VerticalSizedBox(2),
                    Text(
                      "É necessário que você preencha seu nome completo e sua data de nascimento.",
                      style: textTheme.headline1,
                    ),
                    const VerticalSizedBox(3),
                    TextInputDefault(
                      controller: _nome,
                      label: "Nome completo",
                    ),
                    const VerticalSizedBox(2),
                    TextInputDefault(
                      controller: _dataNascimento,
                      label: "Data de nascimento",
                      sufixIcon: IconButton(
                        icon: Icon(Icons.cancel, color: Colors.grey[200]),
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ElevatedButtonDefault(
              child: Text("Avançar"),
              onPressed: controller.toPage2,
            )
          ],
        ),
      ),
    );
  }
}
