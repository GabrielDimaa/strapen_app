import 'package:flutter_modular/flutter_modular.dart';
import 'package:strapen_app/app/app_controller.dart';
import 'package:strapen_app/app/modules/auth/auth_module.dart';
import 'package:strapen_app/app/modules/splash/modules/apresentacao/apresentacao_module.dart';
import 'package:strapen_app/app/modules/splash/splash_module.dart';
import 'package:strapen_app/app/shared/routes/routes.dart';

class AppModule extends Module {
  @override
  List<Bind> get binds => [
    Bind.singleton((i) => AppController()),
  ];

  @override
  List<ModularRoute> get routes => [
    ModuleRoute(Modular.initialRoute, module: SplashModule()),
    ModuleRoute("/$APRESENTACAO_ROUTE", module: ApresentacaoModule()),
    ModuleRoute("/$AUTH_ROUTE", module: AuthModule()),
  ];
}
