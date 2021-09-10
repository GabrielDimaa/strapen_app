import 'package:flutter/material.dart';
import 'package:strapen_app/app/app_widget.dart';
import 'package:strapen_app/app/shared/components/sized_box/vertical_sized_box.dart';

class ConcluidoDialog extends StatelessWidget {
  final String message;

  const ConcluidoDialog({required this.message});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return AlertDialog(
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset("assets/images/concluido.png", width: 150, height: 150),
          const VerticalSizedBox(3),
          Text("Concluído!", style: textTheme.headline1!.copyWith(color: AppColors.primary)),
          const VerticalSizedBox(1.5),
          Text(message, style: textTheme.bodyText2!.copyWith(fontSize: 18), textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
