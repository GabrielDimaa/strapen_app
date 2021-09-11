import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:strapen_app/app/app_controller.dart';
import 'package:strapen_app/app/modules/live/constants/routes.dart';
import 'package:strapen_app/app/modules/user/repositories/iuser_repository.dart';
import 'package:strapen_app/app/shared/config/preferences/session_preferences.dart';
import 'package:strapen_app/app/shared/config/preferences/session_preferences_model.dart';

part 'home_controller.g.dart';

class HomeController = _HomeController with _$HomeController;

abstract class _HomeController with Store {
  final AppController _appController;

  _HomeController(this._appController);

  @action
  Future<void> toCreateLive() async {
    if (_appController.userModel!.firstLive ?? false) {
      Modular.to.pushNamed(LIVE_ROUTE + LIVE_PRIMEIRA_ROUTE);
    } else {
      Modular.to.pushNamed(LIVE_ROUTE + LIVE_CREATE_ROUTE);
    }
  }
}