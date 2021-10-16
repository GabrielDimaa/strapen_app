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
  bool reserva = false;

  @observable
  ObservableList<ReservaModel>? reservas;

  @action
  void setLoading(bool value) => loading = value;

  @action
  void setReserva(bool value) => reserva = value;

  @action
  void setReservas(ObservableList<ReservaModel>? value) => reservas = value;

  @action
  Future<void> load(bool reserva) async {
    try {
      setLoading(true);

      setReserva(reserva);
      await buscarReservas();
    } finally {
      setLoading(false);
    }
  }

  @action
  Future<void> buscarReservas() async {
    if (reserva)
      setReservas((await _reservaRepository.getAllReservas(_appController.userModel!.id!)).asObservable());
    else
      setReservas((await _reservaRepository.getAllCompras(_appController.userModel!.id!)).asObservable());
  }

  @action
  Future<ReservaModel?> toProdutoInfoPage(ReservaModel model) async {
    return await Modular.to.pushNamed(PRODUTO_ROUTE + PRODUTO_INFO_ROUTE, arguments: {
      'produtoModel': ProdutoFactory.fromReservaModel(model),
      'reservaModel': model,
    }) as ReservaModel?;
  }
}
