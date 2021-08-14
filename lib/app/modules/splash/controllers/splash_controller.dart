import 'dart:ui';

import 'package:mobx/mobx.dart';
import 'package:strapen_app/app/shared/interfaces/default_controller_interface.dart';

part 'splash_controller.g.dart';

class SplashController = _SplashController with _$SplashController;

abstract class _SplashController with Store implements IDefaultController {
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