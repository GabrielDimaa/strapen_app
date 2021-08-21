import 'package:shared_preferences/shared_preferences.dart';
import 'package:strapen_app/app/shared/config/preferences/session_preferences_model.dart';

abstract class ISessionPreferences {
  Future<void> save(SessionPreferencesModel dto);

  Future<SessionPreferencesModel> get();

  Future<void> delete();
}

class SessionPreferences implements ISessionPreferences {
  SharedPreferences? _sharedPreferences;

  SessionPreferences();

  static const String _userId = "userId";
  static const String _username = "username";
  static const String _email = "email";
  static const String _senha = "senha";
  static const String _sessionToken = "sessionToken";
  static const String _isFirstLive = "isFirstLive";

  Future<void> _checkPreferences() async {
    if (_sharedPreferences == null)
      _sharedPreferences = await SharedPreferences.getInstance();
  }

  @override
  Future<void> save(SessionPreferencesModel dto) async {
    await _checkPreferences();

    _sharedPreferences!.setString(_userId, dto.userId!);
    _sharedPreferences!.setString(_username, dto.username!);
    _sharedPreferences!.setString(_email, dto.email!);
    _sharedPreferences!.setString(_senha, dto.senha!);
    _sharedPreferences!.setString(_sessionToken, dto.sessionToken!);
    _sharedPreferences!.setBool(_isFirstLive, dto.isFirstLive);
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
      _sharedPreferences!.getBool(_isFirstLive) ?? true,
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
    _sharedPreferences!.remove(_isFirstLive);
  }
}
