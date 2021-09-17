import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:strapen_app/app/app_controller.dart';
import 'package:strapen_app/app/modules/user/constants/routes.dart';
import 'package:strapen_app/app/modules/user/factories/user_factory.dart';
import 'package:strapen_app/app/modules/user/stores/user_store.dart';

part 'user_controller.g.dart';

class UserController = _UserController with _$UserController;

abstract class _UserController with Store {
  final AppController _appController;

  _UserController(this._appController) {
    setUserStore(UserFactory.fromModel(_appController.userModel!));
  }

  @observable
  UserStore userStore = UserFactory.newStore();

  @observable
  bool loading = false;

  @action
  void setUserStore(UserStore value) => userStore = value;

  @action
  void setLoading(bool value) => loading = value;

  @action
  Future<void> toEditarPerfil() async {
    await Modular.to.pushNamed(USER_ROUTE + USER_EDITAR_PERFIL_ROUTE);
  }

  @computed
  bool get isEditavel => _appController.userModel!.id == userStore.id;
}
