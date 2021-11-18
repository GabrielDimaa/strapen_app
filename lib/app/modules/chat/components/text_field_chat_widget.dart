import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:strapen_app/app/app_widget.dart';
import 'package:strapen_app/app/shared/components/loading/circular_loading.dart';
import 'package:strapen_app/app/shared/components/padding/padding_list.dart';
import 'package:strapen_app/app/shared/components/sized_box/horizontal_sized_box.dart';

class TextFieldChatWidget extends StatelessWidget {
  final Function(String?) sendComentario;
  final bool loading;
  final bool enabled;

  TextFieldChatWidget({required this.sendComentario, required this.loading, required this.enabled});

  final TextEditingController controller = TextEditingController();
  final FocusNode focus = FocusNode();

  @override
  Widget build(BuildContext context) {
    final BorderRadius radius = BorderRadius.circular(12);
    final double height = 48;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: PaddingList.value),
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
                enabled: enabled && !loading,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => focus.unfocus(),
                textCapitalization: TextCapitalization.sentences,
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
              if (enabled && !loading) {
                sendComentario.call(controller.text);
                controller.clear();
                focus.unfocus();
              }
            },
            borderRadius: radius,
            child: Ink(
              height: height,
              width: height,
              decoration: BoxDecoration(
                borderRadius: radius,
                color: AppColors.opaci,
              ),
              child: loading
                  ? Padding(
                      padding: const EdgeInsets.all(12),
                      child: CircularLoading(),
                    )
                  : Icon(Icons.send, color: AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }
}
