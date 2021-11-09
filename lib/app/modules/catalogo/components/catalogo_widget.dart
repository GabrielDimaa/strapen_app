import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:strapen_app/app/app_widget.dart';
import 'package:strapen_app/app/modules/catalogo/controllers/catalogo_info_controller.dart';
import 'package:strapen_app/app/modules/produto/stores/produto_store.dart';
import 'package:strapen_app/app/shared/components/padding/padding_scaffold.dart';
import 'package:strapen_app/app/shared/components/sized_box/vertical_sized_box.dart';
import 'package:strapen_app/app/shared/components/widgets/produto_grid_tile.dart';
import 'package:strapen_app/app/shared/components/widgets/produto_grid_view.dart';
import 'package:transparent_image/transparent_image.dart';

class CatalogoWidget extends StatefulWidget {
  @override
  State<CatalogoWidget> createState() => _CatalogoWidgetState();
}

class _CatalogoWidgetState extends State<CatalogoWidget> {
  final CatalogoInfoController controller = Modular.get<CatalogoInfoController>();

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
              child: Observer(builder: (_) {
                if (controller.catalogoStore?.foto == null) {
                  return Ink(
                    height: 180,
                    width: 180,
                    decoration: BoxDecoration(color: AppColors.opaci, borderRadius: BorderRadius.circular(16)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [Icon(Icons.add_photo_alternate, size: 78), Text("Adicione foto do seu produto.")],
                      ),
                    ),
                  );
                } else {
                  return controller.catalogoStore!.foto is File
                      ? Image.file(
                          controller.catalogoStore!.foto,
                          height: 180,
                          width: 180,
                        )
                      : FadeInImage.memoryNetwork(
                          placeholder: kTransparentImage,
                          image: controller.catalogoStore!.foto,
                          height: 180,
                          width: 180,
                        );
                }
              }),
            ),
          ),
          const VerticalSizedBox(3),
          Observer(
            builder: (_) => _title(context: context, label: controller.catalogoStore?.titulo ?? "Sem título"),
          ),
          const VerticalSizedBox(),
          Observer(
            builder: (_) => Text(
              controller.catalogoStore?.descricao ?? "Sem descrição",
              style: Theme.of(context).textTheme.bodyText1,
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
              physics: const NeverScrollableScrollPhysics(),
              itemCount: controller.catalogoStore?.produtos?.length ?? 0,
              itemBuilder: (_, i) {
                final ProdutoStore prod = controller.catalogoStore!.produtos![i];
                return Observer(
                  builder: (_) => ProdutoGridTile(
                    image: prod.fotos.first,
                    descricao: prod.descricao!,
                    preco: prod.preco!,
                    qtd: prod.quantidade!,
                    onTap: () => controller.produtoFunction!.call(prod),
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
