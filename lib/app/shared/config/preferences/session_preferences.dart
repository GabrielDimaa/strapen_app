import 'package:shared_preferences/shared_preferences.dart';
import 'package:strapen_app/app/shared/config/preferences/session_preferences_model.dart';

abstract class ISessionPreferences {
  void save(SessionPreferencesModel dto);

  SessionPreferencesModel get();

  void delete();
}

class SessionPreferences implements ISessionPreferences {
  SharedPreferences? _sharedPreferences;

  SessionPreferences() {
    SharedPreferences.getInstance().then((value) {
      _sharedPreferences = value;
    });
  }

  static const String _userId = "userId";
  static const String _username = "username";
  static const String _email = "email";
  static const String _senha = "senha";
  static const String _sessionToken = "sessionToken";

  @override
  void save(SessionPreferencesModel dto) {
    _sharedPreferences!.setString(_userId, dto.userId!);
    _sharedPreferences!.setString(_username, dto.username!);
    _sharedPreferences!.setString(_email, dto.email!);
    _sharedPreferences!.setString(_senha, dto.senha!);
    _sharedPreferences!.setString(_sessionToken, dto.sessionToken!);
  }

  @override
  SessionPreferencesModel get() {
    return SessionPreferencesModel(
      _sharedPreferences!.getString(_userId),
      _sharedPreferences!.getString(_username),
      _sharedPreferences!.getString(_email),
      _sharedPreferences!.getString(_senha),
      _sharedPreferences!.getString(_sessionToken),
    );
  }

  @override
  void delete() {
    _sharedPreferences!.remove(_userId);
    _sharedPreferences!.remove(_username);
    _sharedPreferences!.remove(_email);
    _sharedPreferences!.remove(_senha);
    _sharedPreferences!.remove(_sessionToken);
  }
}
