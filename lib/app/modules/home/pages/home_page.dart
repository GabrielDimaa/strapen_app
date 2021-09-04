import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:strapen_app/app/app_widget.dart';
import 'package:strapen_app/app/modules/home/components/action_app_bar_home.dart';
import 'package:strapen_app/app/modules/home/controllers/home_controller.dart';
import 'package:strapen_app/app/shared/components/app_bar_default/app_bar_default.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends ModularState<HomePage, HomeController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarDefault(
        title: Text("Home"),
        leadingWidget: Padding(
          padding: const EdgeInsets.only(left: 12, top: 6, bottom: 6),
          child: CircleAvatar(
            radius: 50,
            backgroundColor: AppColors.primary,
            backgroundImage: Image.asset("assets/images/test/avatar_test.png").image,
          ),
        ),
        actionsWidgets: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ActionAppBarHome(
                icon: Icons.search,
                onTap: (){},
              ),
              const SizedBox(width: 6),
              ActionAppBarHome(
                icon: Icons.shop,
                onTap: () async => await controller.toCreateLive(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
