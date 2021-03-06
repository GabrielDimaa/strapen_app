import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:strapen_app/app/modules/auth/modules/registro/controllers/registro_controller.dart';
import 'package:strapen_app/app/shared/components/app_bar_default/app_bar_default.dart';
import 'package:strapen_app/app/shared/components/button/elevated_button_default.dart';
import 'package:strapen_app/app/shared/components/dialog/sair_dialog.dart';
import 'package:strapen_app/app/shared/components/loading/linear_loading.dart';
import 'package:strapen_app/app/shared/components/padding/padding_scaffold.dart';
import 'package:strapen_app/app/shared/components/sized_box/vertical_sized_box.dart';

class RegistroWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<Widget> children;
  final VoidCallback onPressed;
  final String? descriptionButton;
  final Widget? extraButton;

  const RegistroWidget({
    required this.title,
    required this.subtitle,
    required this.children,
    required this.onPressed,
    this.descriptionButton,
    this.extraButton,
  });

  @override
  Widget build(BuildContext context) {
    final RegistroController controller = Modular.get<RegistroController>();
    final TextTheme textTheme = Theme.of(context).textTheme;
    return WillPopScope(
      onWillPop: !Modular.to.canPop() ? () async {
        return await SairDialog.show(context);
      } : null,
      child: Scaffold(
        appBar: AppBarDefault(),
        body: Padding(
          padding: const PaddingScaffold(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const VerticalSizedBox(),
                      Text(
                        title,
                        textAlign: TextAlign.start,
                        style: textTheme.headline2,
                      ),
                      const VerticalSizedBox(2),
                      Text(
                        subtitle,
                        textAlign: TextAlign.start,
                        style: textTheme.headline1,
                      ),
                      const VerticalSizedBox(2),
                      Observer(
                        builder: (_) => LinearLoading(visible: controller.loading),
                      ),
                      const VerticalSizedBox(2),
                      Column(
                        children: children,
                      ),
                      const VerticalSizedBox(2),
                    ],
                  ),
                ),
              ),
              Visibility(
                visible: extraButton != null,
                child: Column(
                  children: [
                    extraButton ?? Container(),
                    const VerticalSizedBox(),
                  ],
                ),
              ),
              Observer(
                builder: (_) => ElevatedButtonDefault(
                  child: Text(descriptionButton ?? "Avan??ar"),
                  onPressed: !controller.loading ? onPressed : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
