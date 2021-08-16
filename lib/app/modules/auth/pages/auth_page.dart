import 'package:flutter/material.dart';
import 'package:strapen_app/app/app_widget.dart';
import 'package:strapen_app/app/shared/components/button/elevated_button_default.dart';
import 'package:strapen_app/app/shared/components/padding/padding_scaffold.dart';
import 'package:strapen_app/app/shared/components/sized_box/vertical_sized_box.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final double height = 170;
  final double padding = 20;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _header(),
                  Text(
                    "Strapen",
                    style: textTheme.headline5!.copyWith(color: AppColors.primary, fontSize: 40),
                    textAlign: TextAlign.center,
                  ),
                  Padding(
                    padding: PaddingScaffold(),
                    child: Column(
                      children: [
                        Text(
                          "Faça login agora para assistir ou criar Lives com seu catálogo de produtos.",
                          style: textTheme.bodyText2!.copyWith(fontSize: 18),
                        ),
                        const VerticalSizedBox(),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            "Esqueceu a senha?",
                            style: textTheme.bodyText2!.copyWith(fontSize: 14),
                          ),
                        ),
                        const VerticalSizedBox(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Não possui uma conta?"),
                            TextButton(
                              onPressed: () {},
                              child: Text(
                                "Registrar-se",
                                style: textTheme.bodyText2!.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              bottom: PaddingScaffold.value,
              left: PaddingScaffold.value,
              right: PaddingScaffold.value,
            ),
            child: ElevatedButtonDefault(
              child: Text("Entrar"),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }

  Widget _header() {
    return SizedBox(
      height: (height * 2) - (padding * 1.5),
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Container(
            height: height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(26),
              color: AppColors.primary,
            ),
          ),
          Positioned(
            bottom: 0,
            child: Align(
              alignment: Alignment.center,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: AppColors.background,
                ),
                alignment: Alignment.center,
                padding: EdgeInsets.only(top: padding),
                child: Image.asset(
                  "assets/images/logo.png",
                  width: 118,
                  height: 118,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
