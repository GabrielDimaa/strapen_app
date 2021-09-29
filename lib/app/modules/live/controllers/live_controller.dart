import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:strapen_app/app/app_controller.dart';
import 'package:strapen_app/app/modules/catalogo/constants/routes.dart';
import 'package:strapen_app/app/modules/catalogo/factories/catalogo_factory.dart';
import 'package:strapen_app/app/modules/catalogo/models/catalogo_model.dart';
import 'package:strapen_app/app/modules/catalogo/repositories/icatalogo_repository.dart';
import 'package:strapen_app/app/modules/catalogo/stores/catalogo_store.dart';
import 'package:strapen_app/app/modules/chat/models/chat_model.dart';
import 'package:strapen_app/app/modules/chat/repositories/ichat_repository.dart';
import 'package:strapen_app/app/modules/live/components/catalogo_bottom_sheet.dart';
import 'package:strapen_app/app/modules/live/components/catalogo_list_bottom_sheet.dart';
import 'package:strapen_app/app/modules/live/constants/routes.dart';
import 'package:strapen_app/app/modules/live/models/live_model.dart';
import 'package:strapen_app/app/modules/live/services/ilive_service.dart';
import 'package:strapen_app/app/modules/live/stores/camera_store.dart';
import 'package:strapen_app/app/modules/live/stores/chewie_store.dart';
import 'package:strapen_app/app/modules/produto/factories/produto_factory.dart';
import 'package:strapen_app/app/modules/produto/repositories/iproduto_repository.dart';
import 'package:strapen_app/app/modules/produto/stores/produto_store.dart';
import 'package:strapen_app/app/modules/start/constants/routes.dart';
import 'package:strapen_app/app/modules/user/repositories/iuser_repository.dart';
import 'package:strapen_app/app/shared/components/dialog/concluido_dialog.dart';
import 'package:strapen_app/app/shared/components/dialog/dialog_default.dart';
import 'package:strapen_app/app/shared/components/dialog/error_dialog.dart';
import 'package:strapen_app/app/shared/components/dialog/loading_dialog.dart';
import 'package:strapen_app/app/shared/extensions/string_extension.dart';

part 'live_controller.g.dart';

class LiveController = _LiveController with _$LiveController;

abstract class _LiveController extends Disposable with Store {
  final AppController appController;
  final ILiveService _liveService;
  final IUserRepository _userRepository;
  final IChatRepository _chatRepository;
  final IProdutoRepository _produtoRepository;
  final ICatalogoRepository _catalogoRepository;

  _LiveController(
    this.appController,
    this._liveService,
    this._userRepository,
    this._chatRepository,
    this._produtoRepository,
    this._catalogoRepository,
  );

  @observable
  CameraStore cameraStore = CameraStore();

  @observable
  ChewieStore chewieStore = ChewieStore();

  @observable
  ObservableList<CatalogoStore> catalogos = ObservableList<CatalogoStore>();

  @observable
  ObservableList<ProdutoStore> produtos = ObservableList<ProdutoStore>();

  @observable
  LiveModel? liveModel;

  @observable
  bool loading = false;

  @observable
  bool loadingSendComentario = false;

  @action
  void setCameraStore(CameraStore value) => cameraStore = value;

  @action
  void setChewieStore(ChewieStore value) => chewieStore = value;

  @action
  void setCatalogos(ObservableList<CatalogoStore> value) => catalogos = value;

  @action
  void setProdutos(ObservableList<ProdutoStore> value) => produtos = value;

  @action
  void setLiveModel(LiveModel value) => liveModel = value;

  @action
  void setLoading(bool value) => loading = value;

  @action
  void setLoadingSendComentario(bool value) => loadingSendComentario = value;

  @action
  Future<void> loadCreateLive(BuildContext context) async {
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
  Future<void> loadTransmitirLive(BuildContext context) async {
    try {
      setLoading(true);

      await _liveService.startLive(liveModel!, cameraStore.cameraController!);

      catalogos.forEach((cat) {
        produtos.addAll(cat.produtos!.map((e) => e).toList().asObservable());
      });

      await _produtoRepository.startListener();
    } catch (e) {
      ErrorDialog.show(context: context, content: e.toString());
    } finally {
      setLoading(false);
    }
  }

  @action
  Future<void> loadAssistirLive(BuildContext context, LiveModel liveModel) async {
    try {
      setLoading(true);
      setLiveModel(liveModel);

      await chewieStore.getInstance(this.liveModel!.playBackId!, this.liveModel!.aspectRatio!);

      await _produtoRepository.startListener();
    } finally {
      setLoading(false);
    }
  }

  @action
  Future<void> initLive(BuildContext context) async {
    if (catalogos.isEmpty) throw Exception("Selecione pelo menos um catálogo para exibir na Live.");

    await LoadingDialog.show(context, "Entrando ao vivo...", () async {
      //Solicita criação da Live na API e adiciona os valores no model para salvar no banco.
      LiveModel model = await _liveService.solicitarLive(appController.userModel!);
      model.catalogos = catalogos.map((e) => e.toModel()).toList();
      model.aspectRatio = cameraStore.cameraController!.value.aspectRatio;
      model = await _liveService.save(model);

      if (model.id == null) throw Exception("Houve um erro ao iniciar sua Live.\nSe o erro persistir reinicie o aplicativo.");

      //Preenche o catálogo com seus respectivos produtos
      for (var it in catalogos) {
        it.produtos = (await _catalogoRepository.getByIdCatalogo(it.id)).produtos?.map((e) {
          return ProdutoFactory.fromModel(e);
        }).toList().asObservable();
      }

      setLiveModel(model);

      //Manter assíncrono para não demorar o início da Live
      _userRepository.updateFirstLive(model.user!.id!);
      appController.userModel!.firstLive = false;

      Modular.to.navigate(LIVE_ROUTE + LIVE_TRANSMITIR_ROUTE, arguments: cameraStore.currentCamera!.lensDirection);
    });
  }

  @action
  Future<void> stopLive(BuildContext context) async {
    await LoadingDialog.show(context, "Finalizando...", () async {
      try {
        await _liveService.stopLive(liveModel!, cameraStore.cameraController!);
      } finally {
        await cameraStore.cameraController!.stopVideoStreaming().whenComplete(() {
          Future.delayed(Duration(seconds: 3), () {
            Modular.to.navigate(START_ROUTE);
          });

          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => ConcluidoDialog(
              message: "Sua Live foi finalizada com sucesso! Você será redirecionado para a tela inicial.",
            ),
          );
        });
      }
    });
  }

  @action
  Future<void> stopWatch(BuildContext context) async {
    await DialogDefault.show(
      context: context,
      title: const Text("Parar de assistir"),
      content: const Text("Deseja parar de assistir?\nSe você reservou produtos eles serão mostrados no seu perfil. Entre em contato com a empresa para receber/retirar seu produto."),
      actions: [
        TextButton(
          child: Text("Confirmar"),
          onPressed: () async {
            Modular.to.navigate(START_ROUTE);
          },
        ),
      ]
    );
  }

  @action
  Future<void> inserirCatalogos() async {
    List<CatalogoModel>? catalogosModel = await Modular.to.pushNamed(CATALOGO_ROUTE + CATALOGO_SELECT_ROUTE, arguments: catalogos.map((e) => e.toModel()).toList());
    if (catalogosModel != null) {
      setCatalogos(catalogosModel.map((e) => CatalogoFactory.fromModel(e)).toList().asObservable());
    }
  }

  @action
  Future<void> sendComentario(String? comentario) async {
    try {
      setLoadingSendComentario(true);
      if (comentario.isNullOrEmpty()) return;

      await _chatRepository.sendComentario(ChatModel(null, comentario, appController.userModel!, liveModel));
    } finally {
      setLoadingSendComentario(false);
    }
  }

  @action
  Future<void> showCatalogoBottomSheet(BuildContext context) async {
    if (catalogos.length > 1)
      await CatalogoListBottomSheet.show(context: context);
    else
      await CatalogoBottomSheet.show(context: context, catalogo: catalogos.first);
  }

  @override
  void dispose() async {
    _produtoRepository.stopListener();
    await cameraStore.cameraController?.dispose();
    await chewieStore.videoPlayerController?.dispose();
    chewieStore.chewieController?.dispose();
  }
}
