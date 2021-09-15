import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:strapen_app/app/app_widget.dart';
import 'package:strapen_app/app/modules/auth/modules/registro/components/registro_widget.dart';
import 'package:strapen_app/app/modules/auth/modules/registro/controllers/registro_controller.dart';
import 'package:strapen_app/app/shared/components/bottom_sheet/bottom_sheet_image_picker.dart';
import 'package:strapen_app/app/shared/components/dialog/error_dialog.dart';
import 'package:strapen_app/app/shared/components/sized_box/horizontal_sized_box.dart';
import 'package:strapen_app/app/shared/components/sized_box/vertical_sized_box.dart';

class RegistroPage6 extends StatefulWidget {
  @override
  _RegistroPage6State createState() => _RegistroPage6State();
}

class _RegistroPage6State extends State<RegistroPage6> {
  final RegistroController controller = Modular.get<RegistroController>();

  @override
  Widget build(BuildContext context) {
    final BorderRadius borderRadius = BorderRadius.circular(100);
    return RegistroWidget(
      title: "Escolha a foto do seu perfil.",
      subtitle: "Sua foto estará visível para todos usuários.",
      children: [
        Align(
          alignment: Alignment.center,
          child: InkWell(
            borderRadius: borderRadius,
            onTap: () async => await _showBottomSheet(),
            child: Observer(
              builder: (_) => Ink(
                height: 212,
                width: 212,
                decoration: BoxDecoration(
                  color: AppColors.opaci,
                  borderRadius: borderRadius,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      spreadRadius: 1,
                      blurRadius: 1,
                      offset: Offset(1, 1),
                    ),
                  ],
                ),
                child: controller.userStore.foto != null
                    ? ClipRRect(
                        borderRadius: borderRadius,
                        child: Image.file(controller.userStore.foto),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add_a_photo, size: 86),
                            const VerticalSizedBox(),
                            const Text("Inserir foto"),
                          ],
                        ),
                      ),
              ),
            ),
          ),
        ),
        const VerticalSizedBox(),
        Observer(
          builder: (_) => Visibility(
            visible: controller.userStore.foto != null,
            child: TextButton(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.edit),
                  const HorizontalSizedBox(),
                  Text("Alterar foto"),
                ],
              ),
              onPressed: () async => await _showBottomSheet(),
            ),
          ),
        ),
      ],
      onPressed: () async {
        try {
          if (controller.userStore.foto == null) throw Exception("Nenhuma foto selecionada.");

          await controller.nextPage(7);
        } catch (e) {
          ErrorDialog.show(context: context, content: e.toString());
        }
      },
    );
  }

  Future<void> _showBottomSheet() async {
    await showModalBottomSheet(
      context: context,
      builder: (_) => BottomSheetImagePicker(
        onTapCamera: () async => await controller.getImagePicker(true),
        onTapGaleria: () async => await controller.getImagePicker(false),
      ),
    );
  }
}
