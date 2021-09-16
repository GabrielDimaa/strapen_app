import 'package:mobx/mobx.dart';
import 'package:strapen_app/app/modules/catalogo/models/catalogo_model.dart';
import 'package:strapen_app/app/modules/catalogo/stores/catalogo_store.dart';

abstract class CatalogoFactory {
  static CatalogoStore fromModel(CatalogoModel model) {
    return CatalogoStore(
      model.id,
      model.titulo,
      model.descricao,
      model.foto,
      model.dataCriado,
      model.user,
      model.produtos?.asObservable(),
    );
  }

  static CatalogoStore newStore() {
    return CatalogoStore(
      null,
      null,
      null,
      null,
      null,
      null,
      null,
    );
  }

  static CatalogoModel newModel() {
    return CatalogoModel(
      null,
      null,
      null,
      null,
      null,
      null,
      null,
    );
  }
}