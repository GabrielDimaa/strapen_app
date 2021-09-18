import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:strapen_app/app/app_widget.dart';
import 'package:strapen_app/app/shared/components/padding/padding_list.dart';
import 'package:strapen_app/app/shared/components/sized_box/horizontal_sized_box.dart';

class TextFieldChatWidget extends StatelessWidget {
  final Function(String?) sendComentario;

  TextFieldChatWidget({required this.sendComentario});

  final TextEditingController controller = TextEditingController();
  final FocusNode focus = FocusNode();

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
                controller: controller,
                focusNode: focus,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => focus.unfocus(),
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
            onTap: () {
              sendComentario.call(controller.text);
              controller.clear();
              focus.unfocus();
            },
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
