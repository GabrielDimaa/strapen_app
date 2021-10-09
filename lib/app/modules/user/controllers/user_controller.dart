import 'package:flutter/cupertino.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:strapen_app/app/app_controller.dart';
import 'package:strapen_app/app/modules/live/constants/routes.dart';
import 'package:strapen_app/app/modules/live/models/live_model.dart';
import 'package:strapen_app/app/modules/live/services/ilive_service.dart';
import 'package:strapen_app/app/modules/reserva/models/reserva_model.dart';
import 'package:strapen_app/app/modules/reserva/repositories/ireserva_repository.dart';
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
  final IReservaRepository _reservaRepository;
  final ILiveService _liveService;
  final AppController _appController;

  _UserController(this._seguidorRepository, this._reservaRepository, this._liveService, this._appController) {
    setUserStore(UserFactory.fromModel(_appController.userModel!));
  }

  @observable
  UserStore userStore = UserFactory.newStore();

  @observable
  bool loading = false;

  @observable
  bool loadingReservas = false;

  @observable
  LiveModel? liveModel;

  @observable
  ObservableList<ReservaModel> reservas = ObservableList<ReservaModel>();

  @observable
  ObservableList<ReservaModel> compras = ObservableList<ReservaModel>();

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
  void setLoadingReservas(bool value) => loadingReservas = value;

  @action
  void setLiveModel(LiveModel? value) => liveModel = value;

  @action
  void setReservas(ObservableList<ReservaModel> value) => reservas = value;

  @action
  void setCompras(ObservableList<ReservaModel> value) => compras = value;

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

      if (model != null) setUserStore(UserFactory.fromModel(model));

      if (!isPerfilPessoal) setLiveModel(await _liveService.isAovivo(userStore.toModel()));

      await _carregarSeguidoresEQtdLives();
    } finally {
      setLoading(false);
      //Manter no finally e assícrono para não ficar muito tempo no load
      if (isPerfilPessoal) _carregarReservas();
    }
  }

  @action
  Future<void> toEditarPerfil() async {
    UserModel? model =  await Modular.to.pushNamed(USER_ROUTE + USER_EDITAR_PERFIL_ROUTE) as UserModel?;

    if (model != null) {
      setUserStore(UserFactory.fromModel(model));
    }
  }

  @action
  Future<void> toAssistirLive() async {
    await Modular.to.pushNamed(LIVE_ROUTE + LIVE_ASSISTIR_ROUTE, arguments: liveModel);
  }

  @action
  Future<void> seguir(BuildContext context) async {
    try {
      await LoadingDialog.show(context, "Aguarde...", () async {
        bool seguindo = await _seguidorRepository.seguir(_appController.userModel!, userStore.toModel());
        if (seguindo) {
          setSeguindo(seguindo);
          setCountSeguindo(countSeguindo + 1);
        }
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
        if (seguindo) {
          setSeguindo(!seguindo);
          setCountSeguindo(countSeguindo - 1);
        }
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

  Future<void> _carregarReservas() async {
    try {
      setLoadingReservas(true);

      setReservas((await _reservaRepository.getAllReservas(userStore.id!, limit: 10)).asObservable());
      setCompras((await _reservaRepository.getAllCompras(userStore.id!, limit: 10)).asObservable());
    } finally {
      setLoadingReservas(false);
    }
  }
}
