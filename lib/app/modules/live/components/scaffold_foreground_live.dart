import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:strapen_app/app/app_widget.dart';
import 'package:strapen_app/app/modules/chat/components/chat_widget.dart';
import 'package:strapen_app/app/modules/chat/components/text_field_chat_widget.dart';
import 'package:strapen_app/app/modules/chat/models/chat_model.dart';
import 'package:strapen_app/app/modules/live/components/app_bar_live_widget.dart';
import 'package:strapen_app/app/modules/live/controllers/live_controller.dart';
import 'package:strapen_app/app/shared/components/app_bar_default/widgets/circle_background_app_bar.dart';
import 'package:strapen_app/app/shared/components/dialog/error_dialog.dart';
import 'package:strapen_app/app/shared/components/sized_box/vertical_sized_box.dart';

class ScaffoldForegroundLive extends StatelessWidget {
  final LiveController controller = Modular.get<LiveController>();

  final bool isCriadorLive;
  final double aspectRatio;
  final BuildContext context;

  ScaffoldForegroundLive({required this.isCriadorLive, required this.aspectRatio, required this.context});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          SizedBox(
            width: double.infinity,
            height: MediaQuery.of(context).size.width / aspectRatio,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.max,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height / 4,
                  width: MediaQuery.of(context).size.width,
                  child: ChatWidget(
                    model: ChatModel(null, null, controller.appController.userModel!, controller.liveModel),
                  ),
                ),
                const VerticalSizedBox(),
                Observer(
                  builder: (_) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: TextFieldChatWidget(
                      loading: controller.loadingSendComentario,
                      sendComentario: (String? comentario) {
                        try {
                          controller.sendComentario(comentario);
                        } catch (e) {
                          ErrorDialog.show(context: context, content: e.toString());
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              AppBarLiveWidget(isCriadorLive: isCriadorLive),
              Padding(
                padding: const EdgeInsets.only(top: 12, right: 20),
                child: CircleButtonAppBar(
                  color: AppColors.opaci.withOpacity(0.4),
                  child: Icon(Icons.ballot),
                  messageTooltip: "Catálogos",
                  onTap: () async => await controller.showCatalogoBottomSheet(this.context),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 12, right: 20),
                child: CircleButtonAppBar(
                  color: AppColors.opaci.withOpacity(0.4),
                  child: Icon(Icons.shopping_cart),
                  messageTooltip: isCriadorLive ? "Reservas" : "Compras",
                  onTap: () async => await controller.showReservasBottomSheet(this.context),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
