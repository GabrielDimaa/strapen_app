import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:strapen_app/app/modules/user/factories/user_factory.dart';
import 'package:strapen_app/app/modules/user/stores/user_store.dart';
import 'package:strapen_app/app/shared/components/dialog/error_dialog.dart';
import 'package:strapen_app/app/shared/routes/routes.dart';

part 'registro_controller.g.dart';

class RegistroController = _RegistroController with _$RegistroController;

abstract class _RegistroController with Store {
  @observable
  UserStore userStore = UserFactory.novo();

  @observable
  bool isCpf = true;

  @observable
  bool visibleSenha = false;

  @observable
  bool visibleConfirmarSenha = false;

  @observable
  bool showErrorEqualsSenha = false;

  @action
  void setIsCpf(bool value) => isCpf = value;

  @action
  void setVisibleSenha(bool value) => visibleSenha = value;

  @action
  void setVisibleConfirmarSenha(bool value) => visibleConfirmarSenha = value;

  @action
  void setShowErrorEqualsSenha(bool value) => showErrorEqualsSenha = value;

  @action
  Future<void> onSavedForm(BuildContext context, GlobalKey<FormState> formKey, VoidCallback onPressed) async {
    try {
      if (formKey.currentState!.validate()) {
        formKey.currentState!.save();

        if (!userStore.equalsSenha)
          setShowErrorEqualsSenha(true);
        else
          onPressed.call();
      }
    } catch (e) {
      ErrorDialog.show(context: context, content: e.toString());
    }
  }

  @action
  Future<void> nextPage(int page) async {
    await Modular.to.pushNamed(AUTH_ROUTE + REGISTRO_ROUTE + REGISTRO_ROUTE + page.toString());
  }

  @action
  void finalizarCadastro() {}

  @action
  void toAuth() => Modular.to.navigate(AUTH_ROUTE);
}
