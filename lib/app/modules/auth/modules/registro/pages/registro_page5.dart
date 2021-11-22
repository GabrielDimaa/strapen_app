import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:strapen_app/app/modules/auth/modules/registro/components/registro_widget.dart';
import 'package:strapen_app/app/modules/auth/modules/registro/controllers/registro_controller.dart';
import 'package:strapen_app/app/modules/user/constants/columns.dart';
import 'package:strapen_app/app/shared/components/dialog/error_dialog.dart';
import 'package:strapen_app/app/shared/components/widgets/text_field_cpf_cnpj/text_field_cpf_cnpj.dart';
import 'package:strapen_app/app/shared/extensions/string_extension.dart';

class RegistroPage5 extends StatefulWidget {
  @override
  _RegistroPage5State createState() => _RegistroPage5State();
}

class _RegistroPage5State extends State<RegistroPage5> {
  final RegistroController controller = Modular.get<RegistroController>();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _cpfCnpjController = TextEditingController();
  final FocusNode _cpfCnpjFocus = FocusNode();

  @override
  void initState() {
    super.initState();

    _cpfCnpjController.text = controller.userStore.cpfCnpj ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return RegistroWidget(
      title: "Mais alguns dados para completar sua conta!",
      subtitle: "Insira seu CPF ou CNPJ caso seja uma conta empresarial.",
      children: [
        Form(
          key: _formKey,
          child: TextFieldCpfCnpj(
            enabled: !controller.loading,
            textController: _cpfCnpjController,
            onFieldSubmitted: (_) => _cpfCnpjFocus.unfocus(),
            focusNode: _cpfCnpjFocus,
            onSaved: (String? value) {
              controller.userStore.setCpfCnpj(value.extrairNum());
            },
          ),
        ),
      ],
      onPressed: () async {
        _cpfCnpjFocus.unfocus();

        await controller.onSavedForm(context, _formKey, () async {
          try {
            await controller.existsData(
              USER_CPFCNPJ_COLUMN,
              _cpfCnpjController.text.extrairNum(),
              "Já existe esse CPF ou CNPJ cadastrado no Strapen.",
            );
            await controller.nextPage(6);
          } catch (e) {
            ErrorDialog.show(context: context, content: e.toString());
          }
        });
      },
    );
  }

  @override
  void dispose() {
    _cpfCnpjController.dispose();
    _cpfCnpjFocus.dispose();
    super.dispose();
  }
}
