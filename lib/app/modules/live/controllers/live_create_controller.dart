import 'package:flutter/cupertino.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:strapen_app/app/app_controller.dart';
import 'package:strapen_app/app/modules/catalogo/models/catalogo_model.dart';
import 'package:strapen_app/app/modules/live/constants/routes.dart';
import 'package:strapen_app/app/modules/live/models/live_model.dart';
import 'package:strapen_app/app/modules/live/services/ilive_service.dart';
import 'package:strapen_app/app/modules/live/stores/camera_store.dart';
import 'package:strapen_app/app/shared/components/dialog/error_dialog.dart';
import 'package:strapen_app/app/shared/components/dialog/loading_dialog.dart';
import 'package:strapen_app/app/shared/config/preferences/session_preferences.dart';
import 'package:strapen_app/app/shared/config/preferences/session_preferences_model.dart';

part 'live_create_controller.g.dart';

class LiveCreateController = _LiveCreateController with _$LiveCreateController;

abstract class _LiveCreateController with Store {
  final AppController appController;
  final ILiveService _liveService;
  final SessionPreferences _sessionPreferences;

  _LiveCreateController(this.appController, this._liveService, this._sessionPreferences);

  @observable
  CameraStore cameraStore = CameraStore();

  @observable
  ObservableList<CatalogoModel> catalogos = ObservableList<CatalogoModel>();

  @observable
  LiveModel? liveModel;

  @observable
  bool loading = false;

  @action
  void setCatalogos(ObservableList<CatalogoModel> value) => catalogos = value;

  @action
  void setLoading(bool value) => loading = value;

  @action
  void setLiveModel(LiveModel value) => liveModel = value;

  @action
  Future<void> load({required BuildContext context}) async {
    try {
      setLoading(true);

      await cameraStore.initCamera();
    } catch (e) {
      ErrorDialog.show(context: context, content: e.toString());
    } finally {
      setLoading(false);
    }
  }

  @action
  Future<void> inserirCatalogos() async {
    await Modular.to.pushNamed(LIVE_ROUTE + LIVE_INSERIR_CATALOGO_ROUTE);
  }

  @action
  Future<void> initLive(BuildContext context) async {
    if (catalogos.isEmpty) throw Exception("Selecione pelo menos um catálogo para exibir na Live.");

    await LoadingDialog.show(context, "Entrando ao vivo...", () async {
      LiveModel? model = await _liveService.solicitarLive(appController.userModel!);
      model.catalogos = catalogos;
      model = await _liveService.save(model);

      if (model.id == null) throw Exception("Houve um erro ao iniciar sua Live.\nSe o erro persistir reinicie o aplicativo.");

      setLiveModel(model);

      SessionPreferencesModel sessionModel = (await _sessionPreferences.get())..isFirstLive = false;
      _sessionPreferences.save(sessionModel);

      Modular.to.navigate(LIVE_ROUTE, arguments: cameraStore.currentCamera!.lensDirection);
    });
  }
}
