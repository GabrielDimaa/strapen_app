import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:strapen_app/app/app_controller.dart';
import 'package:strapen_app/app/modules/produto/constants/routes.dart';
import 'package:strapen_app/app/modules/produto/models/produto_model.dart';
import 'package:strapen_app/app/modules/produto/repositories/iproduto_repository.dart';

part 'produto_list_controller.g.dart';

class ProdutoListController = _ProdutoListController with _$ProdutoListController;

abstract class _ProdutoListController with Store {
  final IProdutoRepository _produtoRepository;
  final AppController _appController;

  _ProdutoListController(this._produtoRepository, this._appController);

  @observable
  ObservableList<ProdutoModel>? produtos;

  @observable
  bool loading = false;

  @action
  void setLoading(bool value) => loading = value;

  @action
  Future<void> load() async {
    try {
      setLoading(true);

      if (produtos == null) await atualizarListaProdutos();
    } finally {
      setLoading(false);
    }
  }

  @action
  Future<void> atualizarListaProdutos() async {
    List<ProdutoModel>? list = await _produtoRepository.getByUser(_appController.userModel?.id);

    if (list != null) produtos = list.asObservable();
  }

  @action
  Future<void> toProdutoCreate() async {
    ProdutoModel? produtoModel = await Modular.to.pushNamed(PRODUTO_ROUTE + PRODUTO_CREATE_ROUTE) as ProdutoModel?;
    if (produtoModel?.id != null) {
      if (produtos == null)
        await atualizarListaProdutos();
      else
        produtos!.insert(0, produtoModel!);
    }
  }

  @action
  Future<void> toProdutoInfo(ProdutoModel model) async {
    ProdutoModel? produto = await Modular.to.pushNamed(PRODUTO_ROUTE + PRODUTO_INFO_ROUTE, arguments: {'produtoModel': model});
    if (produto != null) {
      if (produto.id == null)
        await atualizarListaProdutos();
      else {
        ProdutoModel catalogoParaAlterar = produtos!.firstWhere((e) => e.id == produto.id);

        int position = produtos!.indexOf(catalogoParaAlterar);
        produtos!.removeAt(position);
        produtos!.insert(position, produto);
      }
    }
  }
}
