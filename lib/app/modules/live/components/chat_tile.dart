import 'package:flutter/material.dart';
import 'package:strapen_app/app/app_widget.dart';
import 'package:strapen_app/app/modules/user/models/user_model.dart';
import 'package:transparent_image/transparent_image.dart';

class ChatTile extends StatelessWidget {
  final UserModel model;
  final String comentario;

  const ChatTile({required this.model, required this.comentario});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        CircleAvatar(
          radius: 26,
          backgroundImage: FadeInImage.memoryNetwork(
            placeholder: kTransparentImage,
            image: model.foto,
          ).image,
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.secondary),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(model.username!, style: TextStyle(fontWeight: FontWeight.w600)),
                Text(comentario, style: TextStyle(fontSize: 14))
              ],
            ),
          ),
        ),
      ],
    );
  }
}
