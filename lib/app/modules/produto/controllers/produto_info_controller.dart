import 'package:mobx/mobx.dart';
import 'package:strapen_app/app/modules/produto/stores/produto_store.dart';

part 'produto_info_controller.g.dart';

class ProdutoInfoController = _ProdutoInfoController with _$ProdutoInfoController;

abstract class _ProdutoInfoController with Store {
  @observable
  ProdutoStore? produtoStore;

  @observable
  int currentImage = 0;

  @action
  void setProdutoStore(ProdutoStore? value) => produtoStore = value;

  @action
  void setCurrentImage(int value) => currentImage = value;
}