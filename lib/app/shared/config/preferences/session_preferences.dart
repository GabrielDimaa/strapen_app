import 'package:shared_preferences/shared_preferences.dart';
import 'package:strapen_app/app/shared/config/preferences/session_preferences_model.dart';

abstract class ISessionPreferences {
  void save(SessionPreferencesModel dto);

  SessionPreferencesModel get();

  void delete();
}

class SessionPreferences implements ISessionPreferences {
  SharedPreferences? sharedPreferences;

  SessionPreferences() {
    SharedPreferences.getInstance().then((value) => sharedPreferences = value);
  }

  static const String _userId = "userId";
  static const String _username = "username";
  static const String _email = "email";
  static const String _senha = "senha";
  static const String _sessionToken = "sessionToken";

  @override
  void save(SessionPreferencesModel dto) {
    sharedPreferences!.setString(_userId, dto.userId!);
    sharedPreferences!.setString(_username, dto.username!);
    sharedPreferences!.setString(_email, dto.email!);
    sharedPreferences!.setString(_senha, dto.senha!);
    sharedPreferences!.setString(_sessionToken, dto.sessionToken!);
  }

  @override
  SessionPreferencesModel get() {
    return SessionPreferencesModel(
      sharedPreferences!.getString(_userId),
      sharedPreferences!.getString(_username),
      sharedPreferences!.getString(_email),
      sharedPreferences!.getString(_senha),
      sharedPreferences!.getString(_sessionToken),
    );
  }

  @override
  void delete() {
    sharedPreferences!.remove(_userId);
    sharedPreferences!.remove(_username);
    sharedPreferences!.remove(_email);
    sharedPreferences!.remove(_senha);
    sharedPreferences!.remove(_sessionToken);
  }
}
