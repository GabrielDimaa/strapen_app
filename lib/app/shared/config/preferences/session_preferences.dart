import 'package:shared_preferences/shared_preferences.dart';
import 'package:strapen_app/app/modules/user/models/user_model.dart';
import 'package:strapen_app/app/shared/config/preferences/session_preferences_model.dart';

abstract class ISessionPreferences {
  Future<void> save(SessionPreferencesModel dto);
  Future<SessionPreferencesModel> get();
  Future<void> delete();
  Future<void> updateSenha(String senha);
  Future<void> updateDadosPessoais(UserModel model);
}

class SessionPreferences implements ISessionPreferences {
  SharedPreferences? _sharedPreferences;

  SessionPreferences();

  static const String _userId = "userId";
  static const String _username = "username";
  static const String _email = "email";
  static const String _senha = "senha";
  static const String _sessionToken = "sessionToken";

  Future<void> _checkPreferences() async {
    if (_sharedPreferences == null)
      _sharedPreferences = await SharedPreferences.getInstance();
  }

  @override
  Future<void> save(SessionPreferencesModel model) async {
    await _checkPreferences();

    await delete();

    _sharedPreferences!.setString(_userId, model.userId!);
    _sharedPreferences!.setString(_username, model.username!);
    _sharedPreferences!.setString(_email, model.email!);
    _sharedPreferences!.setString(_senha, model.senha!);
    _sharedPreferences!.setString(_sessionToken, model.sessionToken!);
  }

  @override
  Future<SessionPreferencesModel> get() async {
    await _checkPreferences();

    return SessionPreferencesModel(
      _sharedPreferences!.getString(_userId),
      _sharedPreferences!.getString(_username),
      _sharedPreferences!.getString(_email),
      _sharedPreferences!.getString(_senha),
      _sharedPreferences!.getString(_sessionToken),
    );
  }

  @override
  Future<void> delete() async {
    await _checkPreferences();

    _sharedPreferences!.remove(_userId);
    _sharedPreferences!.remove(_username);
    _sharedPreferences!.remove(_email);
    _sharedPreferences!.remove(_senha);
    _sharedPreferences!.remove(_sessionToken);
  }

  @override
  Future<void> updateSenha(String senha) async {
    await _checkPreferences();

    _sharedPreferences!.setString(_senha, senha);
  }

  @override
  Future<void> updateDadosPessoais(UserModel model) async {
    await _checkPreferences();

    SessionPreferencesModel sessionModel = await get();
    _sharedPreferences!.setString(_username, model.username!);
    _sharedPreferences!.setString(_email, model.email!);
    _sharedPreferences!.setString(_senha, sessionModel.senha!);
    _sharedPreferences!.setString(_sessionToken, sessionModel.sessionToken!);
  }
}
