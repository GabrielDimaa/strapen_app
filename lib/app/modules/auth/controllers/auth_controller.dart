import 'dart:ui';

import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:strapen_app/app/shared/interfaces/default_controller_interface.dart';
import 'package:strapen_app/app/shared/routes/routes.dart';

part 'auth_controller.g.dart';

class AuthController = _AuthController with _$AuthController;

abstract class _AuthController with Store implements IDefaultController {
  @override
  VoidCallback? initPage;

  @observable
  bool loading = false;

  @observable
  bool visible = false;

  @override
  void setInitPage(VoidCallback function) => initPage = function;

  @action
  void setLoading(bool value) => loading = value;

  @action
  void setVisible(bool value) => visible = value;

  @override
  Future<void> load() async {}

  @action
  void login() {}

  @action
  void esqueceuSenha() {}

  @action
  void registrar() => Modular.to.pushNamed(AUTH_ROUTE + REGISTRO_ROUTE);
}
