import 'package:flutter/material.dart';
import 'package:strapen_app/app/app_widget.dart';
import 'package:strapen_app/app/shared/components/padding/padding_list.dart';
import 'package:strapen_app/app/shared/components/sized_box/horizontal_sized_box.dart';

class TextFieldComentarioWidget extends StatelessWidget {
  final VoidCallback sendComentario;

  const TextFieldComentarioWidget({required this.sendComentario});

  @override
  Widget build(BuildContext context) {
    final BorderRadius radius = BorderRadius.circular(12);
    final double height = 48;
    return Padding(
      padding: const EdgeInsets.all(PaddingList.value),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: height,
              decoration: BoxDecoration(
                borderRadius: radius,
                color: AppColors.opaci,
              ),
              child: TextField(
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                  hintText: "Escreva um comentário...",
                  disabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                ),
              ),
            ),
          ),
          const HorizontalSizedBox(),
          InkWell(
            onTap: sendComentario,
            borderRadius: radius,
            child: Ink(
              height: height,
              width: height,
              decoration: BoxDecoration(
                borderRadius: radius,
                color: AppColors.opaci,
              ),
              child: Icon(Icons.send, color: AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }
}
