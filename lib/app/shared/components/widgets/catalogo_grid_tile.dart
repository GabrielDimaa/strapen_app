import 'package:flutter/material.dart';
import 'package:strapen_app/app/app_widget.dart';
import 'package:strapen_app/app/shared/components/sized_box/vertical_sized_box.dart';

class CatalogoGridTile extends StatelessWidget {
  final String image;
  final String title;
  final String subtitle;

  const CatalogoGridTile({required this.image, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(image, height: 110),
            ),
            const VerticalSizedBox(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    title,
                    overflow: TextOverflow.fade,
                    softWrap: false,
                    style: textTheme.bodyText2!.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const VerticalSizedBox(0.7),
                Text(
                  subtitle,
                  style: textTheme.bodyText1!.copyWith(color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
