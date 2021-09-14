import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:strapen_app/app/app_widget.dart';
import 'package:strapen_app/app/modules/catalogo/controllers/catalogo_info_controller.dart';
import 'package:strapen_app/app/modules/catalogo/factories/catalogo_factory.dart';
import 'package:strapen_app/app/modules/catalogo/models/catalogo_model.dart';
import 'package:strapen_app/app/modules/produto/models/produto_model.dart';
import 'package:strapen_app/app/shared/components/app_bar_default/app_bar_default.dart';
import 'package:strapen_app/app/shared/components/app_bar_default/widgets/circle_background_app_bar.dart';
import 'package:strapen_app/app/shared/components/loading/circular_loading.dart';
import 'package:strapen_app/app/shared/components/padding/padding_scaffold.dart';
import 'package:strapen_app/app/shared/components/sized_box/vertical_sized_box.dart';
import 'package:strapen_app/app/shared/components/widgets/produto_grid_tile.dart';
import 'package:transparent_image/transparent_image.dart';

class CatalogoInfoPage extends StatefulWidget {
  final CatalogoModel model;

  const CatalogoInfoPage({required this.model});

  @override
  _CatalogoInfoPageState createState() => _CatalogoInfoPageState();
}

class _CatalogoInfoPageState extends ModularState<CatalogoInfoPage, CatalogoInfoController> {
  @override
  void initState() {
    super.initState();
    controller.setCatalogoStore(CatalogoFactory.fromModel(widget.model));
    controller.load(context);
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBarDefault(
        title: Text("Catálogo"),
        actionsWidgets: [
          CircleButtonAppBar(
            child: Icon(Icons.edit, color: Colors.white),
            onTap: () {},
          ),
        ],
      ),
      body: Observer(
        builder: (_) {
          if (controller.loading) {
            return CircularLoading();
          } else {
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
                        image: controller.catalogoStore!.foto!,
                        height: 180,
                        width: 180,
                      ),
                    ),
                  ),
                  const VerticalSizedBox(3),
                  _title(label: controller.catalogoStore!.titulo!),
                  const VerticalSizedBox(),
                  Text(
                    controller.catalogoStore!.descricao!,
                    style: textTheme.bodyText1,
                  ),
                  const VerticalSizedBox(),
                  ListTile(
                    title: Text("Anunciante"),
                    contentPadding: const EdgeInsets.all(0),
                    onTap: () {},
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                    ),
                  ),
                  const VerticalSizedBox(1.5),
                  const Divider(),
                  const VerticalSizedBox(2.5),
                  _title(label: "Produtos", color: AppColors.primary),
                  const VerticalSizedBox(2),
                  GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: controller.catalogoStore!.produtos?.length ?? 0,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.65,
                    ),
                    itemBuilder: (_, i) {
                      final ProdutoModel prod = controller.catalogoStore!.produtos![i];
                      return ProdutoGridTile(
                        image: prod.fotos!.first,
                        descricao: prod.descricao!,
                        preco: prod.preco!,
                        qtd: prod.quantidade!,
                      );
                    },
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget _title({required label, Color? color}) {
    return Text(
      label,
      style: Theme.of(context).textTheme.headline1!.copyWith(fontWeight: FontWeight.w600, color: color),
    );
  }
}
