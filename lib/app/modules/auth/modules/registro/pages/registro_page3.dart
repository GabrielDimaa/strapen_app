import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:strapen_app/app/modules/auth/modules/registro/components/registro_widget.dart';
import 'package:strapen_app/app/modules/auth/modules/registro/controllers/registro_controller.dart';
import 'package:strapen_app/app/shared/components/dialog/error_dialog.dart';
import 'package:strapen_app/app/shared/components/widgets/text_field_endereco.dart';
import 'package:strapen_app/app/shared/extensions/string_extension.dart';

class RegistroPage3 extends StatefulWidget {
  @override
  _RegistroPage3State createState() => _RegistroPage3State();
}

class _RegistroPage3State extends State<RegistroPage3> {
  final RegistroController controller = Modular.get<RegistroController>();

  TextFieldEndereco? textFieldEndereco;

  @override
  void initState() {
    super.initState();

    textFieldEndereco = TextFieldEndereco(
      cep: controller.userStore.cep ?? "",
      cidade: controller.userStore.cidade ?? "",
      onSavedCep: (String? value) {
        controller.userStore.setCep(value.extrairNum());
      },
      onSavedCidade: (String? value) {
        controller.userStore.setCidade(value);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return RegistroWidget(
      title: "Nos diga seu endereço!",
      subtitle: "Informe a cidade e CEP que você vive.",
      children: [
        textFieldEndereco!,
      ],
      onPressed: () async {
        try {
          if (!textFieldEndereco!.cepValid) throw Exception("Cep inválido!");
          textFieldEndereco!.unFocus();

          await controller.onSavedForm(
            context,
            textFieldEndereco!.formKey,
            () async {
              await controller.nextPage(4);
            },
          );
        } catch (e) {
          ErrorDialog.show(context: context, content: e.toString());
        }
      },
    );
  }
}
