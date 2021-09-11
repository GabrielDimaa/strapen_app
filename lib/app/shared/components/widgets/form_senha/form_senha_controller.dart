import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';

part 'form_senha_controller.g.dart';

class FormSenhaController = _FormSenhaController with _$FormSenhaController;

abstract class _FormSenhaController with Store {
  @observable
  String senhaChanged = "";

  @observable
  String confirmarSenhaChanged = "";

  @observable
  bool visibleSenha = false;

  @observable
  bool visibleConfirmarSenha = false;

  @action
  void setSenhaChanged(String value) => senhaChanged = value;

  @action
  void setConfirmarSenhaChanged(String value) => confirmarSenhaChanged = value;

  @action
  void setVisibleSenha(bool value) => visibleSenha = value;

  @action
  void setVisibleConfirmarSenha(bool value) => visibleConfirmarSenha = value;

  @action
  void focusChange(BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  @computed
  bool get equalsSenha {
    if (senhaChanged.isEmpty || confirmarSenhaChanged.isEmpty || senhaChanged == confirmarSenhaChanged)
      return true;

    return false;
  }
}
