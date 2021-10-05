import 'package:mobx/mobx.dart';
import 'package:strapen_app/app/app_controller.dart';
import 'package:strapen_app/app/modules/reserva/models/reserva_model.dart';
import 'package:strapen_app/app/modules/reserva/repositories/ireserva_repository.dart';

part 'reserva_list_controller.g.dart';

class ReservaListController = _ReservaListController with _$ReservaListController;

abstract class _ReservaListController with Store {
  final IReservaRepository _reservaRepository;
  final AppController _appController;

  _ReservaListController(this._reservaRepository, this._appController);

  @observable
  bool loading = false;

  @observable
  ObservableList<ReservaModel>? reservas;

  @action
  void setReservas(ObservableList<ReservaModel>? value) => reservas = value;

  @action
  void setLoading(bool value) => loading = value;

  @action
  Future<void> load() async {
    try {
      setLoading(true);

      if (reservas == null)
        await buscarReservas();
    } finally {
      setLoading(false);
    }
  }

  @action
  Future<void> buscarReservas() async {
    List<ReservaModel> reservas = await _reservaRepository.getAll(_appController.userModel!.id!);
    setReservas(reservas.asObservable());
  }
}