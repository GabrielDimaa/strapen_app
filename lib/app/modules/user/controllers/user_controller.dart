import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:strapen_app/app/app_controller.dart';
import 'package:strapen_app/app/modules/live/constants/routes.dart';
import 'package:strapen_app/app/modules/live/models/live_model.dart';
import 'package:strapen_app/app/modules/live/repositories/ilive_repository.dart';
import 'package:strapen_app/app/modules/user/constants/routes.dart';
import 'package:strapen_app/app/modules/user/factories/user_factory.dart';
import 'package:strapen_app/app/modules/user/stores/user_store.dart';

part 'user_controller.g.dart';

class UserController = _UserController with _$UserController;

abstract class _UserController with Store {
  final ILiveRepository _liveRepository;
  final AppController _appController;

  _UserController(this._liveRepository, this._appController) {
    setUserStore(UserFactory.fromModel(_appController.userModel!));
  }

  @observable
  UserStore userStore = UserFactory.newStore();

  @observable
  bool loading = false;

  @observable
  LiveModel? liveModel;

  @action
  void setUserStore(UserStore value) => userStore = value;

  @action
  void setLoading(bool value) => loading = value;

  @action
  void setLiveModel(LiveModel? value) => liveModel = value;

  @action
  Future<void> load() async {
    try {
      setLoading(true);

      if (!isPerfilPessoal) {
        setLiveModel(await _liveRepository.isAovivo(userStore.toModel()));
      }
    } finally {
      setLoading(false);
    }
  }

  @action
  Future<void> toEditarPerfil() async {
    await Modular.to.pushNamed(USER_ROUTE + USER_EDITAR_PERFIL_ROUTE);
  }

  @action
  Future<void> toAssistirLive() async {
    await Modular.to.pushNamed(LIVE_ROUTE + LIVE_ASSISTIR_ROUTE, arguments: liveModel);
  }

  @computed
  bool get isPerfilPessoal => _appController.userModel!.id == userStore.id;
}
