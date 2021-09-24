import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:strapen_app/app/app_controller.dart';
import 'package:strapen_app/app/modules/catalogo/constants/routes.dart';
import 'package:strapen_app/app/modules/catalogo/factories/catalogo_factory.dart';
import 'package:strapen_app/app/modules/catalogo/models/catalogo_model.dart';
import 'package:strapen_app/app/modules/catalogo/repositories/icatalogo_repository.dart';
import 'package:strapen_app/app/modules/catalogo/stores/catalogo_store.dart';

part 'catalogo_select_controller.g.dart';

class CatalogoSelectController = _CatalogoSelectController with _$CatalogoSelectController;

abstract class _CatalogoSelectController with Store {
  final ICatalogoRepository _catalogoRepository;
  final AppController _appController;

  _CatalogoSelectController(this._catalogoRepository, this._appController);

  @observable
  bool loading = false;

  @observable
  ObservableList<CatalogoStore> catalogos = ObservableList<CatalogoStore>();

  @action
  void setLoading(bool value) => loading = value;

  @action
  void setCatalogos(ObservableList<CatalogoStore> value) => catalogos = value;

  @action
  Future<void> load(List<CatalogoModel>? catalogosModel) async {
    try {
      setLoading(true);

      List<CatalogoModel>? list = await _catalogoRepository.getByUser(_appController.userModel?.id);

      if (list != null)
        setCatalogos(list.map((e) => CatalogoFactory.fromModel(e)).toList().asObservable());

      if (catalogosModel != null) {
        catalogosModel.forEach((cat) {
          final CatalogoStore? catalogo = catalogos.firstWhere((e) => cat.id == e.id, orElse: null);
          if (catalogo != null) catalogo.setSelected(true);
        });
      }
    } finally {
      setLoading(false);
    }
  }

  @action
  void save() {
    List<CatalogoStore> selecteds = catalogos.where((e) => e.selected).toList();
    if (selecteds.isEmpty) throw Exception("Selecione pelo menos um catálogo para exibir na Live.");

    Modular.to.pop(selecteds.map((e) => e.toModel()).toList());
  }

  @action
  Future<void> toCatalogoCreate() async {
    CatalogoModel? catalogoModel = await Modular.to.pushNamed(CATALOGO_ROUTE + CATALOGO_CREATE_ROUTE);

    if (catalogoModel?.id != null) {
      catalogos.add(CatalogoFactory.fromModel(catalogoModel!));
    }
  }
}
