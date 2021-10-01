import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:strapen_app/app/modules/live/components/scaffold_foreground_live.dart';
import 'package:strapen_app/app/modules/live/controllers/live_controller.dart';
import 'package:strapen_app/app/modules/live/models/live_model.dart';
import 'package:strapen_app/app/shared/components/loading/circular_loading.dart';

class LiveAssistirPage extends StatefulWidget {
  final LiveModel model;

  const LiveAssistirPage({required this.model});

  @override
  _LiveAssistirPageState createState() => _LiveAssistirPageState();
}

class _LiveAssistirPageState extends State<LiveAssistirPage> {
  final LiveController controller = Modular.get<LiveController>();

  @override
  void initState() {
    super.initState();
    controller.loadAssistirLive(context, widget.model);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Observer(
        builder: (_) {
          if (controller.loading)
            return const CircularLoading();
          else {
            return Stack(
              fit: StackFit.expand,
              children: [
                Positioned(
                  child: Observer(
                    builder: (_) => Column(
                      children: [
                        AspectRatio(
                          aspectRatio: controller.liveModel!.aspectRatio!,
                          child: Chewie(controller: controller.chewieStore.chewieController!),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned.fill(
                  child: ScaffoldForegroundLive(isCriadorLive: false, context: context),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
