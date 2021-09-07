import 'package:flutter/cupertino.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:strapen_app/app/app_controller.dart';
import 'package:strapen_app/app/modules/catalogo/models/catalogo_model.dart';
import 'package:strapen_app/app/modules/live/constants/routes.dart';
import 'package:strapen_app/app/modules/live/stores/camera_store.dart';
import 'package:strapen_app/app/shared/components/dialog/error_dialog.dart';

part 'live_create_controller.g.dart';

class LiveCreateController = _LiveCreateController with _$LiveCreateController;

abstract class _LiveCreateController with Store {
  final AppController appController;

  _LiveCreateController(this.appController);

  @observable
  CameraStore cameraStore = CameraStore();

  @observable
  ObservableList<CatalogoModel> catalogos = ObservableList<CatalogoModel>();

  @observable
  bool loading = false;

  @action
  void setCatalogos(ObservableList<CatalogoModel> value) => catalogos = value;

  @action
  void setLoading(bool value) => loading = value;

  @action
  Future<void> load({BuildContext? context}) async {
    try {
      setLoading(true);

      await cameraStore.initCamera();
    } catch (e) {
      ErrorDialog.show(context: context!, content: e.toString());
    } finally {
      setLoading(false);
    }
  }

  @action
  Future<void> inserirCatalogos() async {
    await Modular.to.pushNamed(LIVE_ROUTE + LIVE_INSERIR_CATALOGO_ROUTE);
  }

  @action
  Future<void> initLive() async {
    if (catalogos.isEmpty)
      throw Exception("Selecione pelo menos um catálogo para exibir na Live.");
  }
}
