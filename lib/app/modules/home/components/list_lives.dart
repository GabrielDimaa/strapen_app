import 'package:flutter/material.dart';
import 'package:strapen_app/app/modules/home/components/card_live.dart';
import 'package:strapen_app/app/modules/live/models/live_model.dart';

class ListLives extends StatelessWidget {
  final List<LiveModel> lives;

  const ListLives({required this.lives});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
    );
  }
}
