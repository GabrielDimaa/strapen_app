import 'package:strapen_app/app/modules/catalogo/models/catalogo_model.dart';
import 'package:strapen_app/app/shared/interfaces/repository_interface.dart';

abstract class ICatalogoRepository implements IRepository<CatalogoModel> {
  Future<CatalogoModel?> save(CatalogoModel model);
}