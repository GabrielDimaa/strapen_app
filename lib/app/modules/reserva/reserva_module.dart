import 'package:flutter_modular/flutter_modular.dart';
import 'package:strapen_app/app/app_controller.dart';
import 'package:strapen_app/app/modules/reserva/controllers/reserva_list_controller.dart';
import 'package:strapen_app/app/modules/reserva/pages/reserva_list_page.dart';
import 'package:strapen_app/app/modules/reserva/repositories/ireserva_repository.dart';
import 'package:strapen_app/app/modules/reserva/repositories/reserva_repository.dart';
import 'package:strapen_app/app/modules/user/repositories/user_repository.dart';
import 'package:strapen_app/app/shared/config/preferences/session_preferences.dart';

class ReservaModule extends Module {
  @override
  final List<Bind> binds = [
    Bind((i) => ReservaRepository()),
    Bind((i) => UserRepository(i.get<SessionPreferences>())),
    Bind((i) => ReservaListController(i.get<IReservaRepository>(), i.get<AppController>())),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(Modular.initialRoute, child: (_, args) => ReservaListPage()),
  ];
}