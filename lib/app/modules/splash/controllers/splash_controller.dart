import 'package:mobx/mobx.dart';
import 'package:strapen_app/app/app_controller.dart';

part 'splash_controller.g.dart';

class SplashController = _SplashController with _$SplashController;

abstract class _SplashController with Store {
  final AppController _appController;

  _SplashController(this._appController);

  @action
  Future<void> load() async {
    await _appController.checkSession(isAberturaApp: true);
  }
}