import 'package:flutter/material.dart';
import 'package:strapen_app/app/app_widget.dart';
import 'package:strapen_app/app/shared/components/sized_box/horizontal_sized_box.dart';

class CardLive extends StatelessWidget {
  final String playBackId;
  final String username;

  const CardLive({required this.playBackId, required this.username});

  @override
  Widget build(BuildContext context) {
    return  Container(
      margin: EdgeInsets.only(right: 12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            Image.network(
              "https://image.mux.com/$playBackId/thumbnail.png?width=150&height=190&fit_mode=smartcrop&time=35",
              width: 150,
              height: 190,
            ),
            Container(
              color: Colors.black12.withOpacity(0.5),
              padding: const EdgeInsets.all(12),
              height: 190,
              width: 150,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(36),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const CircleAvatar(
                              backgroundColor: Colors.red,
                              radius: 3,
                            ),
                            const HorizontalSizedBox(0.5),
                            Text(
                              "AO VIVO",
                              style: const TextStyle(fontSize: 11, color: Colors.red, fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        Text(
                          "@",
                          style: Theme.of(context).textTheme.bodyText1!.copyWith(color: AppColors.primary),
                        ),
                        Expanded(
                          child: Text(
                            username,
                            style: Theme.of(context).textTheme.bodyText1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
