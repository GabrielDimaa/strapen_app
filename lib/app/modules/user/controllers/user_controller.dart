import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:strapen_app/app/modules/user/constants/routes.dart';

part 'user_controller.g.dart';

class UserController = _UserController with _$UserController;

abstract class _UserController with Store {
  @action
  Future<void> toEditarPerfil() async {
    await Modular.to.pushNamed(USER_ROUTE + USER_EDITAR_PERFIL_ROUTE);
  }
}