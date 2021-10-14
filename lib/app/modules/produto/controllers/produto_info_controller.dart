import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:strapen_app/app/app_controller.dart';
import 'package:strapen_app/app/modules/produto/constants/routes.dart';
import 'package:strapen_app/app/modules/produto/factories/produto_factory.dart';
import 'package:strapen_app/app/modules/produto/models/produto_model.dart';
import 'package:strapen_app/app/modules/produto/stores/produto_store.dart';
import 'package:strapen_app/app/modules/reserva/models/reserva_model.dart';

part 'produto_info_controller.g.dart';

class ProdutoInfoController = _ProdutoInfoController with _$ProdutoInfoController;

abstract class _ProdutoInfoController with Store {
  @observable
  ProdutoStore? produtoStore;

  @observable
  ReservaModel? reservaModel;

  @computed
  bool get editavel => Modular.get<AppController>().userModel!.id == (produtoStore?.anunciante?.id ?? false) && reservaModel == null;

  @action
  Future<void> editarCatalogo() async {
    ProdutoModel? produto = await Modular.to.pushNamed(PRODUTO_ROUTE + PRODUTO_CREATE_ROUTE, arguments: produtoStore!.toModel());
    if (produto != null) {
      if (produto.id == null)
        Modular.to.pop(produto);
      else
        setProdutoStore(ProdutoFactory.fromModel(produto));
    }
  }

  @action
  void setProdutoStore(ProdutoStore? value) => produtoStore = value;

  @action
  void setReservaModel(ReservaModel? value) => reservaModel = value;
}