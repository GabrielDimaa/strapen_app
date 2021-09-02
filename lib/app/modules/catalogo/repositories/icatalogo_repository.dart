import 'package:strapen_app/app/modules/catalogo/models/catalogo_model.dart';
import 'package:strapen_app/app/shared/interfaces/repository_interface.dart';

abstract class ICatalogoRepository implements IRepository<CatalogoModel> {
  String classNameRelation();

  Future<CatalogoModel> save(CatalogoModel model);
  Future<void> saveProdutosCatalogo(CatalogoModel model);
}