import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:strapen_app/app/app_controller.dart';
import 'package:strapen_app/app/modules/produto/constants/routes.dart';
import 'package:strapen_app/app/modules/produto/factories/produto_factory.dart';
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

      await buscarReservas();
    } finally {
      setLoading(false);
    }
  }

  @action
  Future<void> buscarReservas() async {
    List<ReservaModel> reservas = await _reservaRepository.getAllCompras(_appController.userModel!.id!);
    setReservas(reservas.asObservable());
  }

  @action
  Future<void> toProdutoInfoPage(ReservaModel model) async {
    await Modular.to.pushNamed(PRODUTO_ROUTE + PRODUTO_INFO_ROUTE, arguments: ProdutoFactory.fromReservaModel(model));
  }
}