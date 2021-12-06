import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:strapen_app/app/app_controller.dart';
import 'package:strapen_app/app/modules/live/constants/routes.dart';
import 'package:strapen_app/app/modules/live/models/live_demonstracao_model.dart';
import 'package:strapen_app/app/modules/live/models/live_model.dart';
import 'package:strapen_app/app/modules/live/services/ilive_service.dart';
import 'package:strapen_app/app/modules/reserva/models/reserva_model.dart';
import 'package:strapen_app/app/modules/reserva/repositories/ireserva_repository.dart';
import 'package:strapen_app/app/modules/user/constants/routes.dart';
import 'package:strapen_app/app/modules/user/factories/user_factory.dart';
import 'package:strapen_app/app/modules/user/stores/user_store.dart';

part 'home_controller.g.dart';

class HomeController = _HomeController with _$HomeController;

abstract class _HomeController with Store {
  final IReservaRepository _reservaRepository;
  final ILiveService _liveService;
  final AppController _appController;

  _HomeController(this._reservaRepository, this._liveService, this._appController);

  DateTime? _ultimaAtualizacao;

  @observable
  UserStore userStore = UserFactory.newStore();

  @observable
  bool loading = false;

  @observable
  LiveDemonstracaoModel lives = LiveDemonstracaoModel([], []);

  @observable
  ObservableList<ReservaModel>? reservas;

  @observable
  ObservableList<ReservaModel>? compras;

  @computed
  bool get reservasExibidoPrimeiro => (compras?.isEmpty ?? true) && (reservas?.isNotEmpty ?? false);

  @action
  void setUserStore(UserStore value) => userStore = value;

  @action
  void setLoading(bool value) => loading = value;

  @action
  void setLives(LiveDemonstracaoModel value) => lives = value;

  @action
  void setReservas(ObservableList<ReservaModel> value) => reservas = value;

  @action
  void setCompras(ObservableList<ReservaModel> value) => compras = value;

  @action
  Future<void> load() async {
    try {
      setLoading(true);

      setUserStore(UserFactory.fromModel(_appController.userModel!));

      if (_ultimaAtualizacao == null || DateTime.now().difference(_ultimaAtualizacao!).inMinutes > 1.5) {
        setLives((await _liveService.getLivesDemonstracao(userStore.id!)));
        _ultimaAtualizacao = DateTime.now();
      }

      if (reservas == null || compras == null) {
        setReservas((await _reservaRepository.getAllReservas(userStore.id!, limit: 10)).asObservable());
        setCompras((await _reservaRepository.getAllCompras(userStore.id!, limit: 10)).asObservable());
      }
    } finally {
      setLoading(false);
    }
  }

  @action
  Future<void> atualizarHome() async {
    try {
      setLoading(true);

      setLives((await _liveService.getLivesDemonstracao(userStore.id!)));
      setReservas((await _reservaRepository.getAllReservas(userStore.id!, limit: 10)).asObservable());
      setCompras((await _reservaRepository.getAllCompras(userStore.id!, limit: 10)).asObservable());
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

  @action
  Future<void> toAssistirLive(LiveModel liveModel) async {
    Modular.to.pushNamed(LIVE_ROUTE + LIVE_ASSISTIR_ROUTE, arguments: liveModel);
  }
}
