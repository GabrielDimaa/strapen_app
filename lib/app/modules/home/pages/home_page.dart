import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:strapen_app/app/app_widget.dart';
import 'package:strapen_app/app/modules/home/components/action_app_bar_home.dart';
import 'package:strapen_app/app/modules/home/controllers/home_controller.dart';
import 'package:strapen_app/app/modules/user/components/user_search_delegate.dart';
import 'package:strapen_app/app/shared/components/app_bar_default/app_bar_default.dart';
import 'package:transparent_image/transparent_image.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HomeController controller = Modular.get<HomeController>();

  @override
  void initState() {
    super.initState();
    controller.load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarDefault(
        title: Text("Home"),
        leadingWidget: Padding(
          padding: const EdgeInsets.only(left: 12, top: 6, bottom: 6),
          child: CircleAvatar(
            radius: 50,
            backgroundColor: AppColors.secondary,
            backgroundImage: FadeInImage.memoryNetwork(
              placeholder: kTransparentImage,
              image: controller.userStore.foto,
            ).image,
          ),
        ),
        actionsWidgets: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ActionAppBarHome(
                icon: Icons.search,
                onTap: () {
                  showSearch(context: context, delegate: UserSearchDelegate());
                },
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
