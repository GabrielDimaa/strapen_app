import 'package:mobx/mobx.dart';
import 'package:camera_with_rtmp/camera.dart';

part 'camera_store.g.dart';

class CameraStore = _CameraStore with _$CameraStore;

abstract class _CameraStore with Store {
  @observable
  CameraController? cameraController;

  @observable
  ObservableList<CameraDescription> cameras = ObservableList<CameraDescription>();

  @observable
  CameraDescription? currentCamera;

  @action
  void setCameraController(CameraController? value) => cameraController = value;

  @action
  void setCameras(ObservableList<CameraDescription> value) => cameras = value;

  @action
  void setCurrentCamera(CameraDescription? value) => currentCamera = value;

  @computed
  bool get hasBack => cameras.any((e) => e.lensDirection == CameraLensDirection.back);

  @computed
  bool get hasFront => cameras.any((e) => e.lensDirection == CameraLensDirection.front);

  @computed
  bool get hasBackAndFront => hasBack && hasFront;

  @action
  Future<void> initCamera() async {
    if (cameraController != null) await cameraController!.dispose();

    List<CameraDescription> listCameras = await availableCameras();

    if (listCameras.isEmpty) throw Exception("Você precisa ter uma câmera habilitada!");

    setCameras(listCameras.asObservable());

    if (cameras.any((e) => e.lensDirection == CameraLensDirection.back))
      setCurrentCamera(cameras.firstWhere((e) => e.lensDirection == CameraLensDirection.back));
    else
      setCurrentCamera(cameras.first);

    setCameraController(_cameraControllerDefault(currentCamera!));

    await cameraController!.initialize();
  }

  @action
  Future<void> alterarDirecaoCamera() async {
    if (!hasBackAndFront) throw Exception("Você não tem outra câmera habilitada!");

    if (cameraController != null) await cameraController!.dispose();

    if (currentCamera?.lensDirection == CameraLensDirection.back)
      setCurrentCamera(cameras.firstWhere((e) => e.lensDirection == CameraLensDirection.front));
    else
      setCurrentCamera(cameras.firstWhere((e) => e.lensDirection == CameraLensDirection.back));

    setCameraController(_cameraControllerDefault(currentCamera!));

    await cameraController!.initialize();
  }

  CameraController _cameraControllerDefault(CameraDescription value) {
    return CameraController(
      value,
      ResolutionPreset.ultraHigh,
      enableAudio: true,
      androidUseOpenGL: true,
    );
  }

  _CameraStore();
}