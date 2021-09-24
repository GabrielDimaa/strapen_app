import 'package:mobx/mobx.dart';
import 'package:strapen_app/app/modules/produto/stores/produto_store.dart';

part 'produto_info_controller.g.dart';

class ProdutoInfoController = _ProdutoInfoController with _$ProdutoInfoController;

abstract class _ProdutoInfoController with Store {
  @observable
  ProdutoStore? produtoStore;

  @action
  void setProdutoStore(ProdutoStore? value) => produtoStore = value;
}