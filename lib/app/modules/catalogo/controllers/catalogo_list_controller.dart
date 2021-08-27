import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:strapen_app/app/shared/routes/routes.dart';

part 'catalogo_list_controller.g.dart';

class CatalogoListController = _CatalogoListController with _$CatalogoListController;

abstract class _CatalogoListController with Store {
  @action
  Future<void> toCreateCatalogo() async {
    await Modular.to.pushNamed(CATALOGO_ROUTE + CATALOGO_CREATE_ROUTE);
  }
}