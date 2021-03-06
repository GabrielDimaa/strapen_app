import 'package:strapen_app/app/modules/produto/models/produto_model.dart';
import 'package:strapen_app/app/shared/interfaces/repository_interface.dart';

abstract class IProdutoRepository implements IRepository<ProdutoModel> {
  Future<ProdutoModel?> save(ProdutoModel model);
  Future<bool> delete(ProdutoModel model);
  Future<List<ProdutoModel>?> getByUser(String? id);
  Future<void> startListener();
  void stopListener();
}