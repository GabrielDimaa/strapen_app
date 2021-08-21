import 'dart:ui';

import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:strapen_app/app/shared/config/preferences/session_preferences.dart';
import 'package:strapen_app/app/shared/config/preferences/session_preferences_model.dart';
import 'package:strapen_app/app/shared/interfaces/default_controller_interface.dart';
import 'package:strapen_app/app/shared/routes/routes.dart';

part 'splash_controller.g.dart';

class SplashController = _SplashController with _$SplashController;

abstract class _SplashController with Store implements IDefaultController {
  final SessionPreferences _sessionPreferences;

  _SplashController(this._sessionPreferences);

  @observable
  bool loading = false;

  @override
  VoidCallback? initPage;

  @action
  void setLoading(bool value) => loading = value;

  @override
  void setInitPage(VoidCallback function) => initPage = function;

  @override
  Future<void> load() async {
    SessionPreferencesModel sessionModel = await _sessionPreferences.get();

    if (sessionModel.isNull) {
      Modular.to.navigate(APRESENTACAO_ROUTE);
    } else {
      Modular.to.navigate(HOME_ROUTE);
    }
  }
}