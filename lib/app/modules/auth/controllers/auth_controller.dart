import 'package:flutter/cupertino.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:strapen_app/app/app_controller.dart';
import 'package:strapen_app/app/modules/auth/components/email_verified_dialog.dart';
import 'package:strapen_app/app/modules/auth/constants/routes.dart';
import 'package:strapen_app/app/modules/auth/modules/registro/constants/routes.dart';
import 'package:strapen_app/app/modules/auth/repositories/iauth_repository.dart';
import 'package:strapen_app/app/modules/auth/stores/auth_store.dart';
import 'package:strapen_app/app/modules/start/constants/routes.dart';
import 'package:strapen_app/app/modules/user/constants/routes.dart';
import 'package:strapen_app/app/modules/user/models/user_model.dart';
import 'package:strapen_app/app/modules/user/repositories/iuser_repository.dart';
import 'package:strapen_app/app/shared/exceptions/email_exception.dart';

part 'auth_controller.g.dart';

class AuthController = _AuthController with _$AuthController;

abstract class _AuthController with Store {
  final IAuthRepository _authRepository;
  final IUserRepository _userRepository;
  final AppController _appController;

  _AuthController(this._authRepository, this._userRepository, this._appController);

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
  Future<void> login(BuildContext context) async {
    try {
      setLoading(true);

      UserModel? userModel = await _authRepository.login(authStore.toModel());

      if (userModel != null) {
        _appController.setUserModel(userModel);

        Modular.to.navigate(START_ROUTE);
      }
    } on EmailException catch (_) {
      EmailVerifiedDialog.show(context);
    } catch (_) {
      rethrow;
    } finally {
      setLoading(false);
    }
  }

  @action
  Future<void> esqueceuSenha() async {
    await Modular.to.pushNamed(USER_ROUTE + USER_SENHA_ROUTE);
  }

  @action
  Future<void> registrar() async {
    if (!loading) {
      await _authRepository.logout(null);
      Modular.to.pushNamed(AUTH_ROUTE + REGISTRO_ROUTE);
    }
  }

  @action
  Future<void> reenviarEmail() async {
    try {
      setLoading(true);
      await _userRepository.reenviarEmail(authStore.email!);
    } finally {
      setLoading(false);
    }
  }
}
