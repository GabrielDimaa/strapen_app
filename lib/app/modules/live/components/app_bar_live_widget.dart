import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:strapen_app/app/app_widget.dart';
import 'package:strapen_app/app/modules/live/controllers/live_controller.dart';
import 'package:strapen_app/app/shared/components/app_bar_default/app_bar_default.dart';
import 'package:strapen_app/app/shared/components/app_bar_default/widgets/circle_background_app_bar.dart';
import 'package:strapen_app/app/shared/components/sized_box/horizontal_sized_box.dart';

class AppBarLiveWidget extends StatelessWidget with PreferredSizeWidget {
  final LiveController controller = Modular.get<LiveController>();

  final bool isCriadorLive;

  AppBarLiveWidget({required this.isCriadorLive});

  @override
  Widget build(BuildContext context) {
    return AppBarDefault(
      backgroundColorBackButton: AppColors.opaci.withOpacity(0.4),
      leadingSize: 500,
      leadingWidget: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const HorizontalSizedBox(),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.1),
              borderRadius: BorderRadius.circular(36),
            ),
            child: Observer(
              builder: (_) {
                if (controller.liveEncerrada) {
                  controller.showDialogInformarLiveEncerrada(context);
                }

                return Visibility(
                  visible: !controller.liveEncerrada,
                  child: Row(
                    children: [
                      const CircleAvatar(
                        backgroundColor: Colors.red,
                        radius: 4,
                      ),
                      const HorizontalSizedBox(0.5),
                      Text(
                        "AO VIVO",
                        style: const TextStyle(color: Colors.red, fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                  replacement: const Text(
                    "ENCERRADA",
                    style: TextStyle(color: Colors.red, fontWeight: FontWeight.w700),
                  ),
                );
              }
            ),
          ),
        ],
      ),
      actionsWidgets: [
        CircleButtonAppBar(
          color: AppColors.opaci.withOpacity(0.4),
          child: Icon(Icons.close, color: Colors.white),
          messageTooltip: "Encerrar",
          onTap: () async {
            if (isCriadorLive)
              await controller.stopLive(context);
            else
              await controller.stopWatch(context);
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
