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
  ObservableList<CatalogoModel>? catalogos;

  @observable
  bool loading = false;

  @action
  void setCatalogos(ObservableList<CatalogoModel>? value) => catalogos = value;

  @action
  void setLoading(bool value) => loading = value;

  @action
  Future<void> load() async {
    try {
      setLoading(true);

      if (catalogos == null) await atualizarListaCatalogos();
    } finally {
      setLoading(false);
    }
  }

  @action
  Future<void> atualizarListaCatalogos() async {
    List<CatalogoModel>? list = await _catalogoRepository.getByUser(_appController.userModel?.id);

    if (list != null) catalogos = list.asObservable();
  }

  @action
  Future<void> toCatalogoCreate() async {
    CatalogoModel? catalogoModel = await Modular.to.pushNamed(CATALOGO_ROUTE + CATALOGO_CREATE_ROUTE);
    if (catalogoModel?.id != null) {
      if (catalogos == null)
        await atualizarListaCatalogos();
      else
        catalogos!.insert(0, catalogoModel!);
    }
  }

  @action
  Future<void> toCatalogoInfo(CatalogoModel model) async {
    CatalogoModel? catalogo = await Modular.to.pushNamed(CATALOGO_ROUTE + CATALOGO_INFO_ROUTE, arguments: model);
    if (catalogo != null) {
      if (catalogo.id == null)
        await atualizarListaCatalogos();
      else {
        CatalogoModel catalogoParaAlterar = catalogos!.firstWhere((e) => e.id == catalogo.id);
        int position = catalogos!.indexOf(catalogoParaAlterar);
        catalogo.dataCriado = catalogoParaAlterar.dataCriado;

        catalogos!.removeAt(position);
        catalogos!.insert(position, catalogo);
      }
    }
  }
}
