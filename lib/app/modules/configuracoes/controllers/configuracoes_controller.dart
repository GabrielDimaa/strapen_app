import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:strapen_app/app/modules/auth/constants/routes.dart';
import 'package:strapen_app/app/modules/user/constants/routes.dart';
import 'package:strapen_app/app/shared/config/preferences/session_preferences.dart';

part 'configuracoes_controller.g.dart';

class ConfiguracoesController = _ConfiguracoesController with _$ConfiguracoesController;

abstract class _ConfiguracoesController with Store {
  final SessionPreferences _sessionPreferences;

  _ConfiguracoesController(this._sessionPreferences);

  @action
  Future<void> toEditarPerfil() async {
    await Modular.to.pushNamed(USER_ROUTE);
  }

  @action
  Future<void> toEditarDadosPessoais() async {
    await Modular.to.pushNamed(USER_EDITAR_ROUTE);
  }

  @action
  Future<void> toAlterarSenha() async {
    await Modular.to.pushNamed(USER_SENHA_ROUTE);
  }

  @action
  Future<void> logout() async {
    await _sessionPreferences.delete();
    Modular.to.navigate(AUTH_ROUTE);
  }
}