import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:strapen_app/app/app_widget.dart';
import 'package:strapen_app/app/modules/live/constants/routes.dart';
import 'package:strapen_app/app/shared/components/app_bar_default/app_bar_default.dart';
import 'package:strapen_app/app/shared/components/button/elevated_button_default.dart';
import 'package:strapen_app/app/shared/components/dialog/loading_dialog.dart';
import 'package:strapen_app/app/shared/components/image/vetor.dart';
import 'package:strapen_app/app/shared/components/padding/padding_scaffold.dart';
import 'package:strapen_app/app/shared/components/scaffold/scaffold_gradiente.dart';
import 'package:strapen_app/app/shared/components/sized_box/vertical_sized_box.dart';

class LivePrimeiraPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return ScaffoldGradiente(
      padding: const PaddingScaffold(),
      appBar: AppBarDefault(
        iconColor: AppColors.primary,
        backgroundColorBackButton: Colors.white,
        backgroundColor: AppColors.primary,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Vamos iniciar sua primeira Live?",
                    textAlign: TextAlign.start,
                    style: textTheme.headline2,
                  ),
                  const VerticalSizedBox(2),
                  Text(
                    "Antes de iniciar a Live você pode criar um catálogo com produtos ou escolher algum que já esteja pronto.",
                    textAlign: TextAlign.start,
                    style: textTheme.headline1,
                  ),
                  const VerticalSizedBox(3),
                  Vetor(path: "assets/images/mulher_exibindo_manequim.png"),
                ],
              ),
            ),
          ),
          ElevatedButtonDefault(
            child: Text("Avançar"),
            primary: Colors.white,
            onPrimary: AppColors.primary,
            onPressed: () async {
              await LoadingDialog.show(context, "Carregando...", () async {
                await Modular.to.popAndPushNamed(LIVE_ROUTE + LIVE_CREATE_ROUTE);
              });
            },
          ),
        ],
      ),
    );
  }
}
