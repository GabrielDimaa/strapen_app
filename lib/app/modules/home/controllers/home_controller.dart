import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:strapen_app/app/app_controller.dart';
import 'package:strapen_app/app/modules/live/constants/routes.dart';
import 'package:strapen_app/app/modules/live/models/live_demonstracao_model.dart';
import 'package:strapen_app/app/modules/live/services/ilive_service.dart';
import 'package:strapen_app/app/modules/user/constants/routes.dart';
import 'package:strapen_app/app/modules/user/factories/user_factory.dart';
import 'package:strapen_app/app/modules/user/stores/user_store.dart';

part 'home_controller.g.dart';

class HomeController = _HomeController with _$HomeController;

abstract class _HomeController with Store {
  final ILiveService _liveService;
  final AppController _appController;

  _HomeController(this._liveService, this._appController);

  @observable
  UserStore userStore = UserFactory.newStore();

  @observable
  bool loading = false;

  @observable
  LiveDemonstracaoModel? lives = LiveDemonstracaoModel([], []);

  @action
  void setUserStore(UserStore value) => userStore = value;

  @action
  void setLoading(bool value) => loading = value;

  @action
  void setLives(LiveDemonstracaoModel value) => lives = value;

  @action
  Future<void> load() async {
    try {
      setLoading(true);

      setUserStore(UserFactory.fromModel(_appController.userModel!));

      setLives((await _liveService.getLivesDemonstracao(userStore.id!)));
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