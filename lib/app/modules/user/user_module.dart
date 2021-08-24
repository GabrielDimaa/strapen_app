import 'package:flutter_modular/flutter_modular.dart';
import 'package:strapen_app/app/modules/user/pages/user_page.dart';
import 'package:strapen_app/app/modules/user/repositories/user_repository.dart';
import 'package:strapen_app/app/shared/config/preferences/session_preferences.dart';
import 'package:strapen_app/app/shared/routes/routes.dart';

class UserModule extends Module {
  @override
  final List<Bind> binds = [
    Bind((i) => UserRepository(i.get<SessionPreferences>())),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(USER_ROUTE, child: (_, args) => UserPage()),
  ];
}