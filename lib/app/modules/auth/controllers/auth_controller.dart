import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:strapen_app/app/app_controller.dart';
import 'package:strapen_app/app/modules/auth/constants/routes.dart';
import 'package:strapen_app/app/modules/auth/modules/registro/constants/routes.dart';
import 'package:strapen_app/app/modules/auth/repository/auth_repository_interface.dart';
import 'package:strapen_app/app/modules/auth/stores/auth_store.dart';
import 'package:strapen_app/app/modules/start/constants/routes.dart';
import 'package:strapen_app/app/modules/user/models/user_model.dart';

part 'auth_controller.g.dart';

class AuthController = _AuthController with _$AuthController;

abstract class _AuthController with Store {
  final IAuthRepository _authRepository;
  final AppController _appController;

  _AuthController(this._authRepository, this._appController);

  @observable
  AuthStore authStore = AuthStore(null, null, null);

  @observable
  bool loading = false;

  @observable
  bool visible = false;

  @action
  void setLoading(bool value) => loading = value;

  @action
  void setVisible(bool value) => visible = value;

  @action
  Future<void> login() async {
    try {
      setLoading(true);

      UserModel? userModel = await _authRepository.login(authStore.toModel());

      if (userModel != null) {
        _appController.setUserModel(userModel);

        Modular.to.navigate(START_ROUTE);
      }
    } finally {
      setLoading(false);
    }
  }

  @action
  void esqueceuSenha() {}

  @action
  void registrar() => Modular.to.pushNamed(AUTH_ROUTE + REGISTRO_ROUTE);
}
