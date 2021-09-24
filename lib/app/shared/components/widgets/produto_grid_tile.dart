import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:strapen_app/app/app_widget.dart';
import 'package:strapen_app/app/shared/components/sized_box/vertical_sized_box.dart';
import 'package:strapen_app/app/shared/extensions/double_extension.dart';
import 'package:transparent_image/transparent_image.dart';

class ProdutoGridTile extends StatelessWidget {
  final String image;
  final String descricao;
  final double preco;
  final int qtd;
  final VoidCallback? onTap;
  final bool isEditavel;

  const ProdutoGridTile({
    required this.image,
    required this.descricao,
    required this.preco,
    required this.qtd,
    required this.onTap,
    this.isEditavel = true,
  });

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final BorderRadius radius = BorderRadius.circular(16);
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: radius,
          border: Border.all(color: Colors.grey),
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Align(
              alignment: Alignment.center,
              child: ClipRRect(
                borderRadius: radius,
                child: FadeInImage.memoryNetwork(
                  placeholder: kTransparentImage,
                  image: image,
                  height: 110,
                ),
              ),
            ),
            const VerticalSizedBox(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  descricao,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.bodyText2,
                ),
                const VerticalSizedBox(0.5),
                ButtonBar(
                  buttonPadding: const EdgeInsets.all(0),
                  alignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Visibility(
                          visible: qtd == 0,
                          child: Text(
                            "Sem unidades",
                            style: textTheme.bodyText1!.copyWith(color: Colors.red, fontSize: 12),
                          ),
                          replacement: Text(
                            "$qtd ${qtd > 1 ? "unidades" : "unidade"}",
                            style: textTheme.bodyText1!.copyWith(color: Colors.grey, fontSize: 12),
                          ),
                        ),
                        Text(
                          preco.formatReal(),
                          style: textTheme.bodyText2!.copyWith(color: AppColors.primary),
                        ),
                      ],
                    ),
                    Visibility(
                      visible: isEditavel,
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          _buttonQtd(icon: Icons.edit, color: AppColors.primary, onTap: () {}),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buttonQtd({required IconData icon, required Color color, required VoidCallback onTap}) {
    final BorderRadius radius = BorderRadius.circular(12);

    return InkWell(
      onTap: onTap,
      borderRadius: radius,
      child: Ink(
        height: 32,
        width: 32,
        decoration: BoxDecoration(
          borderRadius: radius,
          color: color,
        ),
        child: Icon(
          icon,
          size: 18,
        ),
      ),
    );
  }
}
