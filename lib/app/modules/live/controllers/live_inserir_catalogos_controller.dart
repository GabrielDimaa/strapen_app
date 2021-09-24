import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:strapen_app/app/modules/catalogo/constants/routes.dart';
import 'package:strapen_app/app/modules/catalogo/models/catalogo_model.dart';
import 'package:strapen_app/app/modules/catalogo/repositories/icatalogo_repository.dart';
import 'package:strapen_app/app/modules/live/controllers/live_controller.dart';

part 'live_inserir_catalogos_controller.g.dart';

class LiveInserirCatalogosController = _LiveInserirCatalogosController with _$LiveInserirCatalogosController;

abstract class _LiveInserirCatalogosController with Store {
  final ICatalogoRepository _catalogoRepository;
  final LiveController _liveController;

  _LiveInserirCatalogosController(this._catalogoRepository, this._liveController);

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
  Future<void> load() async {
    try {
      setLoading(true);

      List<CatalogoModel>? list = await _catalogoRepository.getByUser(_liveController.appController.userModel?.id);

      if (list != null) setCatalogos(list.asObservable());

      catalogosSelected = _liveController.catalogos;
    } finally {
      setLoading(false);
    }
  }

  @action
  void save() {
    if (catalogosSelected.isEmpty) throw Exception("Selecione pelo menos um catálogo para exibir na Live.");

    _liveController.setCatalogos(catalogosSelected);

    Modular.to.pop();
  }

  @action
  Future<void> toCatalogoCreate() async {
    CatalogoModel? catalogoModel = await Modular.to.pushNamed(CATALOGO_ROUTE + CATALOGO_CREATE_ROUTE);

    if (catalogoModel?.id != null)
      catalogos.add(catalogoModel!);
  }
}
