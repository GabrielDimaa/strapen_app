import 'package:mobx/mobx.dart';
import 'package:strapen_app/app/modules/produto/stores/produto_store.dart';
import 'package:strapen_app/app/modules/reserva/models/reserva_model.dart';

part 'produto_info_controller.g.dart';

class ProdutoInfoController = _ProdutoInfoController with _$ProdutoInfoController;

abstract class _ProdutoInfoController with Store {
  @observable
  ProdutoStore? produtoStore;

  @observable
  ReservaModel? reservaModel;

  @action
  void setProdutoStore(ProdutoStore? value) => produtoStore = value;

  @action
  void setReservaModel(ReservaModel? value) => reservaModel = value;
}