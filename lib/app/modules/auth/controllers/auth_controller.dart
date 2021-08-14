import 'dart:ui';

import 'package:mobx/mobx.dart';
import 'package:strapen_app/app/shared/interfaces/default_controller_interface.dart';

part 'auth_controller.g.dart';

class AuthController = _AuthController with _$AuthController;

abstract class _AuthController with Store implements IDefaultController {
  @observable
  bool loading = false;

  @override
  VoidCallback? initPage;

  @action
  void setLoading(bool value) => loading = value;

  @override
  void setInitPage(VoidCallback function) => initPage = function;

  @override
  Future<void> load() async {}
}