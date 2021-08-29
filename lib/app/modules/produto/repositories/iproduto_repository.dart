import 'package:strapen_app/app/modules/produto/models/produto_model.dart';
import 'package:strapen_app/app/shared/interfaces/repository_interface.dart';

abstract class IProdutoRepository implements IRepository<ProdutoModel> {
  Future<ProdutoModel> save(ProdutoModel model);
}