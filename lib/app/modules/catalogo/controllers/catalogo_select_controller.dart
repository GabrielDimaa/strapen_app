import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:strapen_app/app/app_controller.dart';
import 'package:strapen_app/app/modules/catalogo/constants/routes.dart';
import 'package:strapen_app/app/modules/catalogo/models/catalogo_model.dart';
import 'package:strapen_app/app/modules/catalogo/repositories/icatalogo_repository.dart';

part 'catalogo_select_controller.g.dart';

class CatalogoSelectController = _CatalogoSelectController with _$CatalogoSelectController;

abstract class _CatalogoSelectController with Store {
  final ICatalogoRepository _catalogoRepository;
  final AppController _appController;

  _CatalogoSelectController(this._catalogoRepository, this._appController);

  @observable
  bool loading = false;

  @observable
  ObservableList<CatalogoModel> catalogos = ObservableList<CatalogoModel>();

  @observable
  ObservableList<CatalogoModel> catalogosSelected = ObservableList<CatalogoModel>();

  @action
  void setLoading(bool value) => loading = value;

  @action
  void setCatalogos(ObservableList<CatalogoModel> value) => catalogos = value;

  @action
  void addCatalogosSelected(CatalogoModel value) => catalogosSelected.add(value);

  @action
  void removeCatalogosSelected(CatalogoModel value) => catalogosSelected.removeWhere((e) => e.id == value.id);

  @action
  Future<void> load(List<CatalogoModel>? catalogos) async {
    try {
      setLoading(true);

      List<CatalogoModel>? list = await _catalogoRepository.getByUser(_appController.userModel?.id);

      if (list != null) setCatalogos(list.asObservable());

      catalogosSelected = catalogos?.asObservable() ?? ObservableList<CatalogoModel>();
    } finally {
      setLoading(false);
    }
  }

  @action
  void save() {
    if (catalogosSelected.isEmpty) throw Exception("Selecione pelo menos um catálogo para exibir na Live.");

    Modular.to.pop(catalogosSelected);
  }

  @action
  Future<void> toCatalogoCreate() async {
    CatalogoModel? catalogoModel = await Modular.to.pushNamed(CATALOGO_ROUTE + CATALOGO_CREATE_ROUTE);

    if (catalogoModel?.id != null)
      catalogos.add(catalogoModel!);
  }
}
