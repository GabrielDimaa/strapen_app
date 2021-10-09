import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:strapen_app/app/app_widget.dart';
import 'package:strapen_app/app/modules/reserva/components/status_reserva_widget.dart';
import 'package:strapen_app/app/modules/reserva/enums/enum_status_reserva.dart';
import 'package:strapen_app/app/shared/components/sized_box/vertical_sized_box.dart';
import 'package:strapen_app/app/shared/extensions/double_extension.dart';
import 'package:strapen_app/app/shared/extensions/datetime_extension.dart';
import 'package:transparent_image/transparent_image.dart';

class ProdutoGridTile extends StatelessWidget {
  final VoidCallback? onTap;
  final String image;
  final String descricao;
  final double? preco;
  final int? qtd;
  final DateTime? data;
  final EnumStatusReserva? status;

  const ProdutoGridTile({
    required this.onTap,
    required this.image,
    required this.descricao,
    this.preco,
    this.qtd,
    this.data,
    this.status,
  });

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final BorderRadius radius = BorderRadius.circular(16);
    return InkWell(
      onTap: onTap,
      borderRadius: radius,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: radius,
          border: Border.all(color: Colors.grey),
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                    if (status != null)
                      Align(
                        alignment: Alignment.centerRight,
                        child: StatusReservaWidget(status: status!),
                      ),
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
                                if (data != null)
                                  Text(
                                    data!.formated,
                                    style: textTheme.bodyText1!.copyWith(color: Colors.grey, fontSize: 12),
                                  ),
                                Visibility(
                                  visible: qtd != null,
                                  child: Visibility(
                                    visible: qtd == 0,
                                    child: Text(
                                      "Sem unidades",
                                      style: textTheme.bodyText1!.copyWith(color: Colors.red, fontSize: 12),
                                    ),
                                    replacement: Text(
                                      "$qtd ${(qtd ?? 0) > 1 ? "unidades" : "unidade"}",
                                      style: textTheme.bodyText1!.copyWith(color: Colors.grey, fontSize: 12),
                                    ),
                                  ),
                                ),
                                if (preco != null)
                                  Text(
                                    preco.formatReal(),
                                    style: textTheme.bodyText2!.copyWith(color: AppColors.primary),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
