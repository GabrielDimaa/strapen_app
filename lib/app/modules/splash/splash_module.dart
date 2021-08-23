import 'package:flutter_modular/flutter_modular.dart';
import 'package:strapen_app/app/app_controller.dart';
import 'package:strapen_app/app/modules/home/home_module.dart';
import 'package:strapen_app/app/modules/splash/controllers/splash_controller.dart';
import 'package:strapen_app/app/modules/splash/modules/apresentacao/apresentacao_module.dart';
import 'package:strapen_app/app/modules/splash/pages/splash_page.dart';
import 'package:strapen_app/app/shared/routes/routes.dart';

class SplashModule extends Module {
  @override
  final List<Bind> binds = [
    Bind((i) => SplashController(i.get<AppController>())),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(Modular.initialRoute, child: (_, args) => SplashPage()),
    ModuleRoute(APRESENTACAO_ROUTE, module: ApresentacaoModule()),
    ModuleRoute(HOME_ROUTE, module: HomeModule()),
  ];
}
