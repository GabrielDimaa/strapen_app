import 'package:strapen_app/app/modules/catalogo/models/catalogo_model.dart';
import 'package:strapen_app/app/modules/produto/models/produto_model.dart';
import 'package:strapen_app/app/shared/interfaces/repository_interface.dart';

abstract class ICatalogoRepository implements IRepository<CatalogoModel> {
  Future<CatalogoModel> save(CatalogoModel model);
  Future<List<CatalogoModel>?> getByUser(String? idUser);
  Future<CatalogoModel> getByIdCatalogo(String? id);
  Future<List<ProdutoModel>> getProdutosCatalogo(String? idCatalogo);
}