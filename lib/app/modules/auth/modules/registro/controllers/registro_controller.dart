import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:strapen_app/app/shared/routes/routes.dart';

part 'registro_controller.g.dart';

class RegistroController = _RegistroController with _$RegistroController;

abstract class _RegistroController with Store {
  @action
  void toPage2() {
    Modular.to.pushNamed(AUTH_ROUTE + REGISTRO_ROUTE + REGISTRO2_ROUTE);
  }
}