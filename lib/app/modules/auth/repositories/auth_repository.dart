import 'package:parse_server_sdk/parse_server_sdk.dart';
import 'package:strapen_app/app/modules/auth/models/auth_model.dart';
import 'package:strapen_app/app/modules/auth/repositories/iauth_repository.dart';
import 'package:strapen_app/app/modules/user/constants/columns.dart';
import 'package:strapen_app/app/modules/user/models/user_model.dart';
import 'package:strapen_app/app/modules/user/repositories/iuser_repository.dart';
import 'package:strapen_app/app/shared/config/preferences/session_preferences.dart';
import 'package:strapen_app/app/shared/config/preferences/session_preferences_model.dart';
import 'package:strapen_app/app/shared/exceptions/email_exception.dart';
import 'package:strapen_app/app/shared/extensions/string_extension.dart';
import 'package:strapen_app/app/shared/utils/connectivity_utils.dart';
import 'package:strapen_app/app/shared/utils/parse_errors_utils.dart';

class AuthRepository implements IAuthRepository {
  final IUserRepository _userRepository;
  final SessionPreferences _sessionPreferences;

  AuthRepository(this._userRepository, this._sessionPreferences);

  @override
  void validate(AuthModel model) {
    if (model.email.isNullOrEmpty()) throw Exception("Informe seu e-mail para fazer login.");
    if (model.senha.isNullOrEmpty()) throw Exception("Informe sua senha para fazer login.");
  }

  @override
  Future<UserModel?> login(AuthModel model) async {
    try {
      await ConnectivityUtils.hasInternet();
      validate(model);

      final String senha = model.senha!;

      final user = ParseUser(model.email, model.senha, model.email);
      ParseResponse response = await user.login();

      if (!response.success) throw Exception(ParseErrorsUtils.get(response.statusCode));
      ParseObject parse = response.result;

      if (!(parse.get<bool>(USER_EMAIL_VERIFIED_COLUMN) ?? false))
        throw EmailException("E-mail ainda não foi verificado!\nConfira sua caixa de entrada e verifique o E-mail.");

      UserModel userModel = _userRepository.toModel(parse);

      await _userRepository.saveSession(userModel, senha, parse.get<String>("sessionToken")!);

      return userModel;
    } on EmailException catch (e) {
      throw EmailException(e.toString());
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<bool> logout({AuthModel? model, bool deleteSession = true}) async {
    try {
      await ConnectivityUtils.hasInternet();

      if (model == null) {
        SessionPreferencesModel session = await _sessionPreferences.get();

        if (session.senha != null && session.email != null)
          model = AuthModel(session.email, session.senha, session.sessionToken);
      }

      if (model != null) {
        final user = ParseUser(null, model.senha, model.email);
        var response = await user.logout();

        if (!response.success) throw Exception(ParseErrorsUtils.get(response.statusCode));

        if (deleteSession)
          await _sessionPreferences.delete();
      }

      return true;
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<bool> checkSession(AuthModel model) async {
    await ConnectivityUtils.hasInternet();

    ParseResponse? response = await ParseUser.getCurrentUserFromServer(model.sessionToken!);

    if (!(response?.success ?? false)) {
      await logout(model: model, deleteSession: false);

      UserModel? userModel = await login(model);

      return userModel != null ? true : false;
    } else {
      return true;
    }
  }

  @override
  String className() {
    // TODO: implement className
    throw UnimplementedError();
  }

  @override
  AuthModel toModel(ParseObject e) {
    // TODO: implement toModel
    throw UnimplementedError();
  }

  @override
  ParseObject toParseObject(AuthModel model) {
    // TODO: implement toParseObject
    throw UnimplementedError();
  }
}
