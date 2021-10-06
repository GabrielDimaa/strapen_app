import 'package:flutter/cupertino.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:strapen_app/app/app_controller.dart';
import 'package:strapen_app/app/modules/live/constants/routes.dart';
import 'package:strapen_app/app/modules/live/models/live_model.dart';
import 'package:strapen_app/app/modules/live/services/ilive_service.dart';
import 'package:strapen_app/app/modules/reserva/constants/routes.dart';
import 'package:strapen_app/app/modules/user/constants/routes.dart';
import 'package:strapen_app/app/modules/user/factories/user_factory.dart';
import 'package:strapen_app/app/modules/user/models/user_model.dart';
import 'package:strapen_app/app/modules/user/repositories/iseguidor_repository.dart';
import 'package:strapen_app/app/modules/user/stores/user_store.dart';
import 'package:strapen_app/app/shared/components/dialog/loading_dialog.dart';

part 'user_controller.g.dart';

class UserController = _UserController with _$UserController;

abstract class _UserController with Store {
  final ISeguidorRepository _seguidorRepository;
  final ILiveService _liveService;
  final AppController _appController;

  _UserController(this._seguidorRepository, this._liveService, this._appController) {
    setUserStore(UserFactory.fromModel(_appController.userModel!));
  }

  @observable
  UserStore userStore = UserFactory.newStore();

  @observable
  bool loading = false;

  @observable
  LiveModel? liveModel;

  @observable
  bool seguindo = false;

  @observable
  int countSeguidores = 0;

  @observable
  int countSeguindo = 0;

  @observable
  int countLive = 0;

  @computed
  bool get isPerfilPessoal => _appController.userModel!.id == userStore.id;

  @action
  void setUserStore(UserStore value) => userStore = value;

  @action
  void setLoading(bool value) => loading = value;

  @action
  void setLiveModel(LiveModel? value) => liveModel = value;

  @action
  void setSeguindo(bool value) => seguindo = value;

  @action
  void setCountSeguidores(int value) => countSeguidores = value;

  @action
  void setCountSeguindo(int value) => countSeguindo = value;

  @action
  void setCountLive(int value) => countLive = value;

  @action
  Future<void> load(UserModel? model) async {
    try {
      setLoading(true);

      if (model != null)
        setUserStore(UserFactory.fromModel(model));

      if (!isPerfilPessoal)
        setLiveModel(await _liveService.isAovivo(userStore.toModel()));

      await _carregarSeguidoresEQtdLives();
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

  @action
  Future<void> toReservas() async {
    await Modular.to.pushNamed(RESERVA_ROUTE);
  }

  @action
  Future<void> seguirDeixarDeSeguir(BuildContext context) async {
    try {
      await LoadingDialog.show(context, "Aguarde...", () async {
        bool seguindo = await _seguidorRepository.seguir(_appController.userModel!, userStore.toModel());
        if (seguindo) setSeguindo(seguindo);
      });
    } catch (_) {
      rethrow;
    }
  }

  @action
  Future<void> deixarDeSeguir(BuildContext context) async {
    try {
      await LoadingDialog.show(context, "Aguarde...", () async {
        bool seguindo = await _seguidorRepository.deixarSeguir(_appController.userModel!, userStore.toModel());
        if (seguindo) setSeguindo(!seguindo);
      });
    } catch (_) {
      rethrow;
    }
  }

  Future<void> _carregarSeguidoresEQtdLives() async {
    setCountSeguidores(await _seguidorRepository.getCountSeguidores(userStore.id!));
    setCountSeguindo(await _seguidorRepository.getCountSeguindo(userStore.id!));
    setCountLive(await _liveService.getCountLives(userStore.id!));
    setSeguindo(await _seguidorRepository.estaSeguindo(_appController.userModel!, userStore.toModel()));
  }
}
