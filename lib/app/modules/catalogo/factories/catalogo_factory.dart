import 'package:strapen_app/app/modules/catalogo/stores/catalogo_store.dart';

abstract class CatalogoFactory {
  static CatalogoStore novo() {
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
}