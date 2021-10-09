import 'package:flutter_modular/flutter_modular.dart';
import 'package:strapen_app/app/app_controller.dart';
import 'package:strapen_app/app/modules/catalogo/repositories/catalogo_repository.dart';
import 'package:strapen_app/app/modules/catalogo/repositories/icatalogo_repository.dart';
import 'package:strapen_app/app/modules/home/controllers/home_controller.dart';
import 'package:strapen_app/app/modules/home/pages/home_page.dart';
import 'package:strapen_app/app/modules/live/repositories/ilive_repository.dart';
import 'package:strapen_app/app/modules/live/repositories/live_repository.dart';
import 'package:strapen_app/app/modules/live/services/ilive_service.dart';
import 'package:strapen_app/app/modules/live/services/live_service.dart';
import 'package:strapen_app/app/modules/reserva/repositories/ireserva_repository.dart';
import 'package:strapen_app/app/modules/reserva/repositories/reserva_repository.dart';
import 'package:strapen_app/app/modules/user/repositories/iseguidor_repository.dart';
import 'package:strapen_app/app/modules/user/repositories/seguidor_repository.dart';

class HomeModule extends Module {
  @override
  final List<Bind> binds = [
    Bind((i) => CatalogoRepository()),
    Bind((i) => SeguidorRepository()),
    Bind((i) => ReservaRepository()),
    Bind((i) => LiveRepository(i.get<ICatalogoRepository>(), i.get<ISeguidorRepository>())),
    Bind((i) => LiveService(i.get<ILiveRepository>())),
    Bind((i) => HomeController(i.get<IReservaRepository>(), i.get<ILiveService>(), i.get<AppController>()), export: true),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(Modular.initialRoute, child: (_, args) => HomePage()),
  ];
}