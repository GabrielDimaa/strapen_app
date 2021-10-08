import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:strapen_app/app/app_widget.dart';
import 'package:strapen_app/app/modules/home/components/action_app_bar_home.dart';
import 'package:strapen_app/app/modules/home/components/list_lives.dart';
import 'package:strapen_app/app/modules/home/controllers/home_controller.dart';
import 'package:strapen_app/app/modules/user/components/user_search_delegate.dart';
import 'package:strapen_app/app/shared/components/app_bar_default/app_bar_default.dart';
import 'package:strapen_app/app/shared/components/loading/circular_loading.dart';
import 'package:strapen_app/app/shared/components/padding/padding_scaffold.dart';
import 'package:strapen_app/app/shared/components/sized_box/vertical_sized_box.dart';
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
    final TextTheme textTheme = Theme.of(context).textTheme;
    TextStyle style() => textTheme.headline1!.copyWith(fontWeight: FontWeight.w600, color: AppColors.primary);

    return Scaffold(
      appBar: AppBarDefault(
        title: Text("Home"),
        leadingWidget: Padding(
          padding: const EdgeInsets.only(left: 12, top: 6, bottom: 6),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () async => await controller.toPerfil(),
                child: CircleAvatar(
                  radius: 26,
                  backgroundColor: AppColors.secondary,
                  backgroundImage: FadeInImage.memoryNetwork(
                    placeholder: kTransparentImage,
                    image: controller.userStore.foto,
                  ).image,
                ),
              ),
            ],
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Observer(
            builder: (_) {
              if (controller.loading)
                return const Expanded(child: const CircularLoading());
              else
                return Expanded(
                  child: SingleChildScrollView(
                    padding: const PaddingScaffold(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const VerticalSizedBox(2.5),
                        Visibility(
                          visible: (controller.lives?.livesSeguindo?.length ?? 0) > 0,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Seguindo", style: style()),
                              const VerticalSizedBox(2),
                              ListLives(lives: controller.lives?.livesSeguindo ?? []),
                            ],
                          ),
                          replacement: _canalDeLives(textTheme),
                        ),
                        const VerticalSizedBox(3),
                        Visibility(
                          visible: (controller.lives?.livesSeguindo?.length ?? 0) > 0,
                          child: _canalDeLives(textTheme),
                        ),
                        const VerticalSizedBox(3),
                      ],
                    ),
                  ),
                );
            },
          ),
        ],
      ),
    );
  }

  Widget _canalDeLives(TextTheme textTheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Canal de Lives", style: textTheme.headline1!.copyWith(fontWeight: FontWeight.w600, color: AppColors.primary)),
        const VerticalSizedBox(2),
        ListLives(lives: controller.lives?.livesOutros ?? []),
      ],
    );
  }
}
