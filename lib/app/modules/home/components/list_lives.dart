import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_svg/svg.dart';
import 'package:strapen_app/app/app_widget.dart';
import 'package:strapen_app/app/modules/home/components/card_live.dart';
import 'package:strapen_app/app/modules/home/controllers/home_controller.dart';
import 'package:strapen_app/app/modules/live/models/live_model.dart';
import 'package:strapen_app/app/shared/components/sized_box/vertical_sized_box.dart';

class ListLives extends StatelessWidget {
  final HomeController controller = Modular.get<HomeController>();
  final List<LiveModel> lives;

  ListLives({required this.lives});

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: lives.isNotEmpty,
      child: SizedBox(
        height: 190,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: lives.length,
          itemBuilder: (_, i) {
            final LiveModel live = lives[i];
            return CardLive(
              playBackId: live.playBackId!,
              username: live.user!.username!,
            );
          },
        ),
      ),
      replacement: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SvgPicture.asset(
            "assets/images/empty_lives.svg",
            height: 140,
            width: 140,
          ),
          const VerticalSizedBox(1.5),
          const Text(
            "Nenhuma Live sendo transmitida agora.\nComece uma você mesmo!",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14),
          ),
          const VerticalSizedBox(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                borderRadius: BorderRadius.circular(12),
                splashColor: AppColors.primary.withOpacity(0.4),
                highlightColor: AppColors.primaryDark.withOpacity(0.4),
                onTap: () async => await controller.toCreateLive(),
                child: Ink(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.primary)
                  ),
                  child: Text("Iniciar", style: TextStyle(color: AppColors.primary)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
