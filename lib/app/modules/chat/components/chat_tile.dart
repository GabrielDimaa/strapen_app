import 'package:flutter/material.dart';
import 'package:strapen_app/app/app_widget.dart';
import 'package:strapen_app/app/modules/chat/models/chat_model.dart';
import 'package:strapen_app/app/shared/components/sized_box/horizontal_sized_box.dart';
import 'package:transparent_image/transparent_image.dart';

class ChatTile extends StatelessWidget {
  final ChatModel model;
  final bool mine;

  const ChatTile({required this.model, this.mine = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 22,
            backgroundImage: FadeInImage.memoryNetwork(
              placeholder: kTransparentImage,
              image: model.user!.foto,
            ).image,
          ),
          const HorizontalSizedBox(),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.secondary.withOpacity(0.6), width: 0.4),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    mine ? "Você" : "@${model.user!.username!}",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: mine ? AppColors.primary : AppColors.secondary,
                    ),
                  ),
                  Text(model.comentario!, style: TextStyle(fontSize: 14))
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
