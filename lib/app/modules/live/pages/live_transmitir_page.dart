import 'package:camera_with_rtmp/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:strapen_app/app/modules/live/components/scaffold_foreground_live.dart';
import 'package:strapen_app/app/modules/live/controllers/live_controller.dart';
import 'package:strapen_app/app/shared/components/loading/circular_loading.dart';

class LiveTransmitirPage extends StatefulWidget {
  @override
  _LiveTransmitirPageState createState() => _LiveTransmitirPageState();
}

class _LiveTransmitirPageState extends State<LiveTransmitirPage> {
  final LiveController controller = Modular.get<LiveController>();

  @override
  void initState() {
    super.initState();
    controller.loadTransmitirLive(context);
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return SafeArea(
      child: Observer(
        builder: (_) {
          if (controller.loading) {
            return const CircularLoading();
          } else {
            return Stack(
              fit: StackFit.expand,
              children: [
                Positioned.fill(
                  child: Observer(
                    builder: (_) {
                      if (!(controller.cameraStore.cameraController?.value.isInitialized ?? false)) {
                        return Center(
                          child: Text(
                            "Permita o Strapen acessar sua câmera para iniciar a Live.",
                            style: textTheme.bodyText2,
                            textAlign: TextAlign.center,
                          ),
                        );
                      } else {
                        return Stack(
                          children: [
                            AspectRatio(
                              aspectRatio: controller.cameraStore.cameraController!.value.aspectRatio,
                              child: CameraPreview(controller.cameraStore.cameraController!),
                            ),
                          ],
                        );
                      }
                    },
                  ),
                ),
                Positioned.fill(
                  child: ScaffoldForegroundLive(isCriadorLive: true),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
