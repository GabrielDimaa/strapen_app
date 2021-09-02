import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:strapen_app/app/app_controller.dart';
import 'package:strapen_app/app/modules/catalogo/constants/routes.dart';
import 'package:strapen_app/app/modules/catalogo/models/catalogo_model.dart';
import 'package:strapen_app/app/modules/catalogo/repositories/icatalogo_repository.dart';

part 'catalogo_list_controller.g.dart';

class CatalogoListController = _CatalogoListController with _$CatalogoListController;

abstract class _CatalogoListController with Store {
  final ICatalogoRepository _catalogoRepository;
  final AppController _appController;

  _CatalogoListController(this._catalogoRepository, this._appController);

  @observable
  ObservableList<CatalogoModel> catalogos = ObservableList<CatalogoModel>();

  @observable
  bool loading = false;

  @action
  void setLoading(bool value) => loading = value;

  @action
  Future<void> load() async {
    try {
      setLoading(true);

      List<CatalogoModel>? list = await _catalogoRepository.getByUser(_appController.userModel?.id);

      if (list != null) catalogos = list.asObservable();
    } finally {
      setLoading(false);
    }
  }

  @action
  Future<void> toCreateCatalogo() async {
    await Modular.to.pushNamed(CATALOGO_ROUTE + CATALOGO_CREATE_ROUTE);
  }
}