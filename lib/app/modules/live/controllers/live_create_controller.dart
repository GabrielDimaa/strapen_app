import 'package:flutter/cupertino.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:strapen_app/app/app_controller.dart';
import 'package:strapen_app/app/modules/catalogo/models/catalogo_model.dart';
import 'package:strapen_app/app/modules/live/constants/routes.dart';
import 'package:strapen_app/app/modules/live/models/live_model.dart';
import 'package:strapen_app/app/modules/live/services/ilive_service.dart';
import 'package:strapen_app/app/modules/live/stores/camera_store.dart';
import 'package:strapen_app/app/modules/user/repositories/iuser_repository.dart';
import 'package:strapen_app/app/shared/components/dialog/error_dialog.dart';
import 'package:strapen_app/app/shared/components/dialog/loading_dialog.dart';

part 'live_create_controller.g.dart';

class LiveCreateController = _LiveCreateController with _$LiveCreateController;

abstract class _LiveCreateController with Store {
  final AppController appController;
  final ILiveService _liveService;
  final IUserRepository _userRepository;

  _LiveCreateController(this.appController, this._liveService, this._userRepository);

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
      LiveModel model = await _liveService.solicitarLive(appController.userModel!);
      model.catalogos = catalogos;
      model = await _liveService.save(model);

      if (model.id == null) throw Exception("Houve um erro ao iniciar sua Live.\nSe o erro persistir reinicie o aplicativo.");

      setLiveModel(model);

      //Manter assíncrono para trancar demorar muito o início da Live
      _userRepository.updateFirstLive(model.user!.id!);
      appController.userModel!.firstLive = false;

      Modular.to.navigate(LIVE_ROUTE + LIVE_TRANSMITIR_ROUTE, arguments: cameraStore.currentCamera!.lensDirection);
    });
  }
}
