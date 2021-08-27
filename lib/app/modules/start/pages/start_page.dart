import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:strapen_app/app/modules/start/constants/index_page.dart';
import 'package:strapen_app/app/modules/start/controllers/start_controller.dart';
import 'package:strapen_app/app/shared/components/bottom_app_bar/bottom_app_bar_default.dart';
import 'package:strapen_app/app/shared/components/bottom_app_bar/bottom_bar_item.dart';
import 'package:strapen_app/app/shared/components/padding/margin_bottom_bar.dart';

class StartPage extends StatefulWidget {
  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends ModularState<StartPage, StartController> {
  @override
  void initState() {
    super.initState();
    controller.toInit();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RouterOutlet(),
      bottomNavigationBar: Padding(
        padding: const MarginBottomAppBar(),
        child: Observer(builder: (_) => BottomAppBarDefault(
            children: [
              BottomAppBarItem(
                icon: Icons.home,
                label: "Home",
                ontap: controller.toHome,
                selected: controller.page == HOME_PAGE,
              ),
              BottomAppBarItem(
                icon: Icons.shopping_basket,
                label: "Produtos",
                ontap: controller.toProduto,
                selected: controller.page == PRODUTO_PAGE,
              ),
              BottomAppBarItem(
                icon: Icons.ballot,
                label: "Catálogos",
                ontap: controller.toCatalogo,
                selected: controller.page == CATALOGO_PAGE,
              ),
              BottomAppBarItem(
                icon: Icons.settings,
                label: "Config.",
                ontap: controller.toConfiguracoes,
                selected: controller.page == CONFIGURACOES_PAGE,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
