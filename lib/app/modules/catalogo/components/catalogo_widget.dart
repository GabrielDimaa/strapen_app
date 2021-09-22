import 'package:flutter/material.dart';
import 'package:strapen_app/app/app_widget.dart';
import 'package:strapen_app/app/modules/produto/models/produto_model.dart';
import 'package:strapen_app/app/shared/components/padding/padding_scaffold.dart';
import 'package:strapen_app/app/shared/components/sized_box/vertical_sized_box.dart';
import 'package:strapen_app/app/shared/components/widgets/produto_grid_tile.dart';
import 'package:transparent_image/transparent_image.dart';

class CatalogoWidget extends StatelessWidget {
  final String image;
  final String titulo;
  final String descricao;
  final List<ProdutoModel> produtos;
  final Function(ProdutoModel) onPressed;
  final bool isLive;

  const CatalogoWidget({
    required this.image,
    required this.titulo,
    required this.descricao,
    required this.produtos,
    required this.onPressed,
    this.isLive = false,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const PaddingScaffold(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const VerticalSizedBox(),
          Align(
            alignment: Alignment.center,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: FadeInImage.memoryNetwork(
                placeholder: kTransparentImage,
                image: image,
                height: 180,
                width: 180,
              ),
            ),
          ),
          const VerticalSizedBox(3),
          _title(context: context, label: titulo),
          const VerticalSizedBox(),
          Text(
            descricao,
            style: Theme.of(context).textTheme.bodyText1,
          ),
          const VerticalSizedBox(),
          Visibility(
            visible: isLive,
            child: ListTile(
              title: Text("Anunciante"),
              contentPadding: const EdgeInsets.all(0),
              onTap: () {},
              trailing: const Icon(
                Icons.arrow_forward_ios,
                size: 16,
              ),
            ),
          ),
          const VerticalSizedBox(1.5),
          const Divider(),
          const VerticalSizedBox(2.5),
          _title(
            context: context,
            label: "Produtos",
            color: AppColors.primary,
          ),
          const VerticalSizedBox(2),
          GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: produtos.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.65,
            ),
            itemBuilder: (_, i) {
              final ProdutoModel prod = produtos[i];
              return ProdutoGridTile(
                image: prod.fotos!.first,
                descricao: prod.descricao!,
                preco: prod.preco!,
                qtd: prod.quantidade!,
                onTap: () => onPressed.call(prod),
                isEditavel: !isLive,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _title({required BuildContext context, required String label, Color? color}) {
    return Text(
      label,
      style: Theme.of(context).textTheme.headline1!.copyWith(fontWeight: FontWeight.w600, color: color),
    );
  }
}
