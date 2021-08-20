import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:strapen_app/app/modules/auth/modules/registro/components/registro_widget.dart';
import 'package:strapen_app/app/modules/auth/modules/registro/controllers/registro_controller.dart';
import 'package:strapen_app/app/shared/components/date_picker/cupertino_date.dart';
import 'package:strapen_app/app/shared/components/dialog/error_dialog.dart';
import 'package:strapen_app/app/shared/components/form/validator.dart';
import 'package:strapen_app/app/shared/components/sized_box/vertical_sized_box.dart';
import 'package:strapen_app/app/shared/components/text_input/text_input_default.dart';
import 'package:strapen_app/app/shared/extensions/datetime_extension.dart';

class RegistroPage1 extends StatefulWidget {
  @override
  _RegistroPage1State createState() => _RegistroPage1State();
}

class _RegistroPage1State extends State<RegistroPage1> {
  final RegistroController controller = Modular.get<RegistroController>();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nome = TextEditingController();
  final TextEditingController _dataNascimento = TextEditingController();

  Future<void> _save() async {
    try {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();

        await controller.nextPage(2);
      }
    } catch (e) {
      ErrorDialog.show(context: context, content: e.toString());
    }
  }

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
              TextInputDefault(
                controller: _nome,
                label: "Nome completo",
                validator: InputValidatorDefault().validate,
                keyboardType: TextInputType.name,
                onSaved: controller.userStore.setNome,
              ),
              const VerticalSizedBox(2),
              Observer(
                builder: (_) {
                  bool clear = false;
                  return TextInputDefault(
                    controller: _dataNascimento,
                    label: "Data de nascimento",
                    readOnly: true,
                    validator: InputDateValidator().validate,
                    onTap: () async {
                      if (!clear) {
                        DateTime? date = await CupertinoDate.show(context);
                        if (date != null) {
                          _dataNascimento.text = date.formated;
                          controller.userStore.setDataNascimento(date);
                        }
                      } else {
                        clear = false;
                      }
                    },
                    sufixIcon: Visibility(
                      visible: controller.userStore.dataNascimento != null,
                      child: IconButton(
                        icon: Icon(Icons.cancel_outlined, color: Colors.grey[200]),
                        onPressed: () {
                          _dataNascimento.clear();
                          controller.userStore.setDataNascimento(null);
                          clear = true;
                        },
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
      onPressed: () async => await controller.onSavedForm(
        context,
        _formKey,
        () async => await controller.nextPage(2),
      ),
      extraButton: TextButton(
        child: Text("Já tenho uma conta"),
        onPressed: controller.toAuth,
      ),
    );
  }
}
