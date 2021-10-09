import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:strapen_app/app/app_widget.dart';
import 'package:strapen_app/app/modules/catalogo/stores/catalogo_store.dart';
import 'package:strapen_app/app/modules/produto/stores/produto_store.dart';
import 'package:strapen_app/app/shared/components/padding/padding_scaffold.dart';
import 'package:strapen_app/app/shared/components/sized_box/vertical_sized_box.dart';
import 'package:strapen_app/app/shared/components/widgets/produto_grid_tile.dart';
import 'package:strapen_app/app/shared/components/widgets/produto_grid_view.dart';
import 'package:transparent_image/transparent_image.dart';

class CatalogoWidget extends StatelessWidget {
  final CatalogoStore catalogoStore;
  final Function(ProdutoStore) onPressedProduto;
  final bool isLive;

  const CatalogoWidget({
    required this.catalogoStore,
    required this.onPressedProduto,
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
              child: Observer(
                builder: (_) => FadeInImage.memoryNetwork(
                  placeholder: kTransparentImage,
                  image: catalogoStore.foto,
                  height: 180,
                  width: 180,
                ),
              ),
            ),
          ),
          const VerticalSizedBox(3),
          Observer(
            builder: (_) => _title(context: context, label: catalogoStore.titulo!),
          ),
          const VerticalSizedBox(),
          Observer(
            builder: (_) => Text(
              catalogoStore.descricao!,
              style: Theme.of(context).textTheme.bodyText1,
            ),
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
          Observer(
            builder: (_) => ProdutoGridView(
              itemCount: catalogoStore.produtos!.length,
              itemBuilder: (_, i) {
                final ProdutoStore prod = catalogoStore.produtos![i];
                return Observer(
                  builder: (_) => ProdutoGridTile(
                    image: prod.fotos.first,
                    descricao: prod.descricao!,
                    preco: prod.preco!,
                    qtd: prod.quantidade!,
                    onTap: () => onPressedProduto.call(prod),
                  ),
                );
              },
            ),
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
