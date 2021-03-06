import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:strapen_app/app/modules/auth/constants/routes.dart';
import 'package:strapen_app/app/modules/auth/repositories/iauth_repository.dart';
import 'package:strapen_app/app/modules/splash/modules/apresentacao/constants/routes.dart';
import 'package:strapen_app/app/modules/start/constants/routes.dart';
import 'package:strapen_app/app/modules/user/models/user_model.dart';
import 'package:strapen_app/app/shared/config/preferences/session_preferences.dart';
import 'package:strapen_app/app/shared/config/preferences/session_preferences_model.dart';

import 'modules/auth/models/auth_model.dart';

part 'app_controller.g.dart';

class AppController = _AppController with _$AppController;

abstract class _AppController with Store {
  final IAuthRepository _authRepository;
  final SessionPreferences _sessionPreferences;

  _AppController(this._authRepository, this._sessionPreferences);

  @observable
  UserModel? userModel;

  @action
  void setUserModel(UserModel? value) => userModel = value;

  Future<void> checkSession({bool isAberturaApp = false}) async {
    try {
      SessionPreferencesModel sessionModel = await _sessionPreferences.get();

      if (sessionModel.withoutSenha) {
        Modular.to.navigate(AUTH_ROUTE);
      } else if (sessionModel.isNull) {
        Modular.to.navigate(APRESENTACAO_ROUTE);
      } else {
        AuthModel authModel = AuthModel(sessionModel.email, sessionModel.senha, sessionModel.sessionToken);

        if (isAberturaApp) {
          UserModel? userModel = await _authRepository.login(authModel);

          if (userModel == null) {
            Modular.to.navigate(AUTH_ROUTE);
          } else {
            setUserModel(userModel);
            Modular.to.navigate(START_ROUTE);
          }
        } else {
          if (!await _authRepository.checkSession(authModel)) {
            Modular.to.navigate(AUTH_ROUTE);
          }
        }
      }
    } catch (e) {
      Modular.to.navigate(AUTH_ROUTE);
    }
  }
}
