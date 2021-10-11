import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:strapen_app/app/app_widget.dart';
import 'package:strapen_app/app/modules/catalogo/stores/catalogo_store.dart';
import 'package:strapen_app/app/modules/live/components/catalogo_bottom_sheet.dart';
import 'package:strapen_app/app/modules/live/controllers/live_controller.dart';
import 'package:strapen_app/app/shared/components/padding/padding_list.dart';
import 'package:strapen_app/app/shared/components/sized_box/vertical_sized_box.dart';
import 'package:strapen_app/app/shared/components/widgets/catalogo_grid_tile.dart';
import 'package:strapen_app/app/shared/components/widgets/catalogo_grid_view.dart';
import 'package:strapen_app/app/shared/components/widgets/snap_bottom_sheet.dart';
import 'package:strapen_app/app/shared/extensions/datetime_extension.dart';

class CatalogoListBottomSheet extends StatefulWidget {
  final BuildContext context;

  const CatalogoListBottomSheet({required this.context});

  @override
  _CatalogoListBottomSheetState createState() => _CatalogoListBottomSheetState();

  static Future<void> show({required BuildContext context}) async {
    return await showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.background,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(44),
          topRight: Radius.circular(44),
        ),
      ),
      isScrollControlled: true,
      builder: (_) => CatalogoListBottomSheet(context: context,),
    );
  }
}

class _CatalogoListBottomSheetState extends State<CatalogoListBottomSheet> {
  final LiveController controller = Modular.get<LiveController>();

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.45,
      child: Padding(
        padding: const PaddingList(),
        child: Column(
          children: [
            const VerticalSizedBox(2),
            const SnapBottomSheet(),
            const VerticalSizedBox(3),
            Expanded(
              child: Observer(
                builder: (_) => CatalogoGridView(
                  itemCount: controller.catalogos.length,
                  itemBuilder: (_, i) {
                    final CatalogoStore cat = controller.catalogos[i];
                    return CatalogoGridTile(
                      image: cat.foto,
                      title: cat.titulo!,
                      subtitle: cat.dataCriado!.formated,
                      onTap: () async => await CatalogoBottomSheet.show(
                        context: widget.context,
                        catalogo: cat,
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
