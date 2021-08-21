import 'package:flutter_modular/flutter_modular.dart';
import 'package:strapen_app/app/modules/user/repositories/user_repository.dart';
import 'package:strapen_app/app/shared/config/preferences/session_preferences.dart';

class RegistroModule extends Module {
  @override
  final List<Bind> binds = [
    Bind((i) => UserRepository(i.get<SessionPreferences>())),
  ];

  @override
  final List<ModularRoute> routes = [];
}