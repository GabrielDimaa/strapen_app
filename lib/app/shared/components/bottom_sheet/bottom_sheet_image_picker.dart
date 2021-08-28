import 'package:flutter/material.dart';
import 'package:strapen_app/app/shared/components/sized_box/horizontal_sized_box.dart';
import 'package:strapen_app/app/shared/components/sized_box/vertical_sized_box.dart';

class BottomSheetImagePicker extends StatelessWidget {
  final VoidCallback onTapCamera;
  final VoidCallback onTapGaleria;

  const BottomSheetImagePicker({required this.onTapCamera, required this.onTapGaleria});

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      onClosing: () {},
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const VerticalSizedBox(),
          TextButton(
            onPressed: onTapCamera,
            child: _content(
              context: context,
              icon: Icons.camera,
              text: "Câmera",
            ),
          ),
          TextButton(
            onPressed: onTapGaleria,
            child: _content(
              context: context,
              icon: Icons.insert_photo_rounded,
              text: "Galeria",
            ),
          ),
          const VerticalSizedBox(),
        ],
      ),
    );
  }

  Widget _content({required BuildContext context, required IconData icon, required String text}) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: Colors.white),
        const HorizontalSizedBox(),
        Text(text, style: Theme.of(context).textTheme.bodyText2),
      ],
    );
  }
}
