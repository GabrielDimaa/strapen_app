import 'package:flutter_modular/flutter_modular.dart';
import 'package:strapen_app/app/modules/splash/modules/apresentacao/controllers/apresentacao_controller.dart';
import 'package:strapen_app/app/modules/splash/modules/apresentacao/pages/apresentacao_conta_page.dart';
import 'package:strapen_app/app/modules/splash/modules/apresentacao/pages/apresentacao_page.dart';
import 'package:strapen_app/app/shared/routes/routes.dart';

class ApresentacaoModule extends Module {
  @override
  final List<Bind> binds = [
    Bind((i) => ApresentacaoController()),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(Modular.initialRoute, child: (_, args) => ApresentacaoPage()),
    ChildRoute(APRESENTACAO_CONTA_ROUTE, child: (_, args) => ApresentacaoContaPage()),
  ];
}