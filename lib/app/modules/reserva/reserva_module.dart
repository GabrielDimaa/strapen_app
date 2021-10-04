import 'package:flutter_modular/flutter_modular.dart';
import 'package:strapen_app/app/modules/reserva/pages/reserva_list_page.dart';
import 'package:strapen_app/app/modules/reserva/repositories/reserva_repository.dart';

class ReservaModule extends Module {
  @override
  final List<Bind> binds = [
    Bind((i) => ReservaRepository()),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(Modular.initialRoute, child: (_, args) => ReservaListPage()),
  ];
}