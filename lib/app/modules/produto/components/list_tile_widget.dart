import 'package:flutter/material.dart';
import 'package:strapen_app/app/app_widget.dart';
import 'package:strapen_app/app/shared/components/sized_box/horizontal_sized_box.dart';
import 'package:strapen_app/app/shared/components/sized_box/vertical_sized_box.dart';

class ListTileWidget extends StatelessWidget {
  final Widget image;
  final Widget title;
  final Widget qtd;
  final Widget preco;
  final VoidCallback onTap;

  ListTileWidget({
    required this.image,
    required this.title,
    required this.qtd,
    required this.preco,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      color: AppColors.opaci,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 14),
          child: Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    ClipRRect(borderRadius: BorderRadius.circular(18), child: image),
                    const HorizontalSizedBox(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        title,
                        const VerticalSizedBox(0.3),
                        qtd,
                        const VerticalSizedBox(0.3),
                        preco,
                      ],
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
