import 'dart:ui';

import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:strapen_app/app/app_controller.dart';
import 'package:strapen_app/app/shared/interfaces/default_controller_interface.dart';
import 'package:strapen_app/app/shared/routes/routes.dart';

part 'splash_controller.g.dart';

class SplashController = _SplashController with _$SplashController;

abstract class _SplashController with Store implements IDefaultController {
  final AppController _appController;

  _SplashController(this._appController);

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
    await _appController.checkSession(isAberturaApp: true);

    Modular.to.navigate(HOME_ROUTE);
  }
}