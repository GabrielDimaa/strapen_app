import 'package:flutter/cupertino.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:strapen_app/app/modules/catalogo/constants/routes.dart';
import 'package:strapen_app/app/modules/catalogo/factories/catalogo_factory.dart';
import 'package:strapen_app/app/modules/catalogo/models/catalogo_model.dart';
import 'package:strapen_app/app/modules/catalogo/repositories/icatalogo_repository.dart';
import 'package:strapen_app/app/modules/catalogo/stores/catalogo_store.dart';
import 'package:strapen_app/app/shared/components/dialog/error_dialog.dart';

part 'catalogo_info_controller.g.dart';

class CatalogoInfoController = _CatalogoInfoController with _$CatalogoInfoController;

abstract class _CatalogoInfoController with Store {
  final ICatalogoRepository _catalogoRepository;

  _CatalogoInfoController(this._catalogoRepository);

  @observable
  CatalogoStore? catalogoStore;

  @observable
  bool loading = false;

  @observable
  Function? produtoFunction;

  @action
  void setCatalogoStore(CatalogoStore? value) => catalogoStore = value;

  @action
  void setLoading(bool value) => loading = value;

  @action
  void setProdutoFunction(Function? value) => produtoFunction = value;

  @action
  Future<void> load(BuildContext context) async {
    try {
      setLoading(true);

      CatalogoModel model = await _catalogoRepository.getById(catalogoStore?.id);
      setCatalogoStore(CatalogoFactory.fromModel(model));
    } catch(e) {
      setLoading(false);
      ErrorDialog.show(context: context, content: e.toString());
    } finally {
      setLoading(false);
    }
  }

  @action
  Future<void> editarCatalogo() async {
    CatalogoModel? catalogo = await Modular.to.pushNamed(CATALOGO_ROUTE + CATALOGO_CREATE_ROUTE, arguments: catalogoStore!.toModel());
    if (catalogo != null) {
      if (catalogo.id == null)
        Modular.to.pop(catalogo);
      else
        setCatalogoStore(CatalogoFactory.fromModel(catalogo));
    }
  }
}
