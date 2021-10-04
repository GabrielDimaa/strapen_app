import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:strapen_app/app/app_controller.dart';
import 'package:strapen_app/app/modules/live/constants/routes.dart';
import 'package:strapen_app/app/modules/user/constants/routes.dart';
import 'package:strapen_app/app/modules/user/factories/user_factory.dart';
import 'package:strapen_app/app/modules/user/stores/user_store.dart';

part 'home_controller.g.dart';

class HomeController = _HomeController with _$HomeController;

abstract class _HomeController with Store {
  final AppController _appController;

  _HomeController(this._appController);

  @observable
  UserStore userStore = UserFactory.newStore();

  @observable
  bool loading = false;

  @action
  void setUserStore(UserStore value) => userStore = value;

  @action
  void setLoading(bool value) => loading = value;

  @action
  Future<void> load() async {
    try {
      setLoading(true);

      setUserStore(UserFactory.fromModel(_appController.userModel!));
    } finally {
      setLoading(false);
    }
  }

  @action
  Future<void> toCreateLive() async {
    if (_appController.userModel!.firstLive ?? false) {
      await Modular.to.pushNamed(LIVE_ROUTE + LIVE_PRIMEIRA_ROUTE);
    } else {
      await Modular.to.pushNamed(LIVE_ROUTE + LIVE_CREATE_ROUTE);
    }
  }

  @action
  Future<void> toPerfil() async {
    await Modular.to.pushNamed(USER_ROUTE);
  }
}