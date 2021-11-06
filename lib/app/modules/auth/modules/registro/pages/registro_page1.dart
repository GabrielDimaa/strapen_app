import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:strapen_app/app/modules/auth/modules/registro/components/registro_widget.dart';
import 'package:strapen_app/app/modules/auth/modules/registro/controllers/registro_controller.dart';
import 'package:strapen_app/app/shared/components/widgets/text_field_data_nascimento.dart';
import 'package:strapen_app/app/shared/components/form/validator.dart';
import 'package:strapen_app/app/shared/components/sized_box/vertical_sized_box.dart';
import 'package:strapen_app/app/shared/components/text_input/text_input_default.dart';

class RegistroPage1 extends StatefulWidget {
  @override
  _RegistroPage1State createState() => _RegistroPage1State();
}

class _RegistroPage1State extends State<RegistroPage1> {
  final RegistroController controller = Modular.get<RegistroController>();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _dataNascimentoController = TextEditingController();
  final FocusNode _nomeFocus = FocusNode();
  final FocusNode _dataNascimentoFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    return RegistroWidget(
      title: "Vamos criar sua conta rapidinho!",
      subtitle: "É necessário que você preencha seu nome completo e sua data de nascimento.",
      children: [
        Form(
          key: _formKey,
          child: Column(
            children: [
              Observer(
                builder: (_) => TextFormField(
                  decoration: InputDecorationDefault(
                    labelText: "Nome completo",
                  ),
                  controller: _nomeController,
                  validator: InputValidatorDefault().validate,
                  textCapitalization: TextCapitalization.sentences,
                  keyboardType: TextInputType.name,
                  enabled: !controller.loading,
                  textInputAction: TextInputAction.done,
                  onSaved: controller.userStore.setNome,
                  focusNode: _nomeFocus,
                  onFieldSubmitted: (_) => _nomeFocus.unfocus(),
                ),
              ),
              const VerticalSizedBox(2),
              Observer(
                builder: (_) => TextFieldDataNascimento(
                  sufixIconVisible: controller.userStore.dataNascimento != null,
                  controller: _dataNascimentoController,
                  enabled: !controller.loading,
                  focusNode: _dataNascimentoFocus,
                  onClear: () => controller.userStore.setDataNascimento(null),
                  setDataStore: controller.userStore.setDataNascimento,
                ),
              ),
            ],
          ),
        ),
      ],
      onPressed: () async {
        _nomeFocus.unfocus();
        _dataNascimentoFocus.unfocus();

        await controller.onSavedForm(
          context,
          _formKey,
          () async => await controller.nextPage(2),
        );
      },
      extraButton: TextButton(
        child: Text("Já tenho uma conta"),
        onPressed: controller.toAuth,
      ),
    );
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _dataNascimentoController.dispose();
    _nomeFocus.dispose();
    _dataNascimentoFocus.dispose();
    super.dispose();
  }
}
