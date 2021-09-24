import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:strapen_app/app/app_controller.dart';
import 'package:strapen_app/app/modules/produto/constants/routes.dart';
import 'package:strapen_app/app/modules/produto/models/produto_model.dart';
import 'package:strapen_app/app/modules/produto/repositories/iproduto_repository.dart';

part 'produto_select_controller.g.dart';

class ProdutoSelectController = _ProdutoSelectController with _$ProdutoSelectController;

abstract class _ProdutoSelectController with Store {
  final IProdutoRepository _produtoRepository;
  final AppController _appController;

  _ProdutoSelectController(this._produtoRepository, this._appController);

  @observable
  bool loading = false;

  @observable
  ObservableList<ProdutoModel> produtos = ObservableList<ProdutoModel>();

  @observable
  ObservableList<ProdutoModel> produtosSelected = ObservableList<ProdutoModel>();

  @action
  void setLoading(bool value) => loading = value;

  @action
  void setProdutos(ObservableList<ProdutoModel> value) => produtos = value;

  @action
  void addProdutosSelected(ProdutoModel value) => produtosSelected.add(value);

  @action
  void removeProdutosSelected(ProdutoModel value) => produtosSelected.removeWhere((e) => e.id == value.id);

  @action
  Future<void> load(List<ProdutoModel>? produtos) async {
    try {
      setLoading(true);

      List<ProdutoModel>? lista = await _produtoRepository.getByUser(_appController.userModel?.id);

      if (lista != null)
        setProdutos(lista.asObservable());

      produtosSelected = produtos?.asObservable() ?? ObservableList<ProdutoModel>();
    } finally {
      setLoading(false);
    }
  }

  @action
  void save() {
    if (produtosSelected.isEmpty ) throw Exception("Selecione pelo menos um produto para exibir no catálogo.");

    Modular.to.pop(produtosSelected);
  }

  @action
  Future<void> toProdutoCreate() async {
    ProdutoModel? produtoModel = await Modular.to.pushNamed(PRODUTO_ROUTE + PRODUTO_CREATE_ROUTE);

    if (produtoModel?.id != null)
      produtos.add(produtoModel!);
  }
}