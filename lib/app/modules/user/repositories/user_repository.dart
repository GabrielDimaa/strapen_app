import 'dart:typed_data';

import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:strapen_app/app/modules/user/constants/columns.dart';
import 'package:strapen_app/app/modules/user/models/user_model.dart';
import 'package:strapen_app/app/modules/user/repositories/iuser_repository.dart';
import 'package:strapen_app/app/shared/config/preferences/session_preferences.dart';
import 'package:strapen_app/app/shared/config/preferences/session_preferences_model.dart';
import 'package:strapen_app/app/shared/extensions/string_extension.dart';
import 'package:strapen_app/app/shared/utils/parse_errors_utils.dart';

class UserRepository implements IUserRepository {
  final SessionPreferences? _sharedPreferences;

  UserRepository(this._sharedPreferences);

  @override
  String className() => "User";

  @override
  void validate(UserModel model) {
    if (model.nome.isNullOrEmpty()) throw Exception("Informe seu nome completo.");
    if (model.dataNascimento == null) throw Exception("Informe sua data de nascimento.");
    if (model.cpfCnpj.isNullOrEmpty()) throw Exception("Informe um CPF ou CNPJ válido.");
    if (model.username.isNullOrEmpty()) throw Exception("Informe seu nome de usuário.");
    if (model.telefone.isNullOrEmpty()) throw Exception("Informe seu número de telefone.");
    if (model.email.isNullOrEmpty()) throw Exception("Informe seu endereço de e-mail.");
    if (model.cep.isNullOrEmpty()) throw Exception("Informe seu CEP.");
    if (model.cidade.isNullOrEmpty()) throw Exception("Informe sua cidade.");
    if (model.senha.isNullOrEmpty()) throw Exception("Informe uma senha válida para sua conta.");
  }

  @override
  ParseUser toParseObject(UserModel model) {
    return ParseUser.createUser(model.email, model.senha, model.email)
      ..set<String?>(USER_ID_COLUMN, model.id)
      ..set<String>(USER_NOME_COLUMN, model.nome!)
      ..set<String>(USER_USERNAME_COLUMN, model.username!)
      ..set<DateTime>(USER_DATANASCIMENTO_COLUMN, model.dataNascimento!)
      ..set<String>(USER_CPFCNPJ_COLUMN, model.cpfCnpj!)
      ..set<String>(USER_TELEFONE_COLUMN, model.telefone!)
      ..set<String?>(USER_DESCRICAO_COLUMN, model.descricao)
      ..set<String>(USER_CEP_COLUMN, model.cep!)
      ..set<String>(USER_CIDADE_COLUMN, model.cidade!)
      ..set<Uint8List?>(USER_FOTO_COLUMN, model.foto)
      ..set<bool>(USER_FIST_LIVE_COLUMN, model.firstLive ?? true);
  }

  @override
  UserModel toModel(ParseObject e) {
    return UserModel(
      e.get<String>(USER_ID_COLUMN),
      e.get<String>(USER_NOME_COLUMN),
      e.get<String?>(USER_DESCRICAO_COLUMN),
      e.get<DateTime>(USER_DATANASCIMENTO_COLUMN),
      e.get<String>(USER_CPFCNPJ_COLUMN),
      e.get<Uint8List?>(USER_FOTO_COLUMN),
      e.get<String>(USER_USERNAME_COLUMN),
      e.get<String>(USER_EMAIL_COLUMN),
      e.get<String>(USER_TELEFONE_COLUMN),
      e.get<String>(USER_CEP_COLUMN),
      e.get<String>(USER_CIDADE_COLUMN),
      null,
      e.get<bool>(USER_FIST_LIVE_COLUMN),
    );
  }

  @override
  Future<void> saveSession(UserModel model, String senha, String session) async {
    await _sharedPreferences!.save(
      SessionPreferencesModel(
        model.id,
        model.username,
        model.email,
        senha,
        session,
      ),
    );
  }

  @override
  Future<UserModel> save(UserModel model) async {
    try {
      final String senha = model.senha!;

      validate(model);

      ParseUser user = toParseObject(model);
      ParseResponse response = await user.signUp();

      if (!response.success) throw Exception(ParseErrorsUtils.get(response.statusCode));
      ParseObject parse = (response.results as List<dynamic>).first;

      model = toModel(parse);

      await saveSession(model, senha, parse.get<String>("sessionToken")!);

      return model;
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<bool> existsData(String column, String data, String messageError) async {
    try {
      final QueryBuilder<ParseObject> query = QueryBuilder(ParseUser.forQuery());
      query..whereEqualTo(column, data);

      final ParseResponse response = await query.query();

      if (!response.success) throw Exception(ParseErrorsUtils.get(response.statusCode));

      if ((response.results?.length ?? 0) > 0) throw Exception(messageError);

      return false;
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<void> updateFirstLive(String id) async {
    try {
      final ParseObject parseObject = ParseUser(null, null, null)
        ..objectId = id
        ..set<bool>(USER_FIST_LIVE_COLUMN, false);

      final ParseResponse response = await parseObject.save();

      if (!response.success) throw Exception(ParseErrorsUtils.get(response.statusCode));
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<void> updateSenha(UserModel model) async {
    try {
      if (model.id == null || model.senha.isNullOrEmpty()) throw Exception("Houve um erro ao alterar sua senha.");

      final ParseObject parseObject = ParseUser(null, null, null)
        ..objectId = model.id
        ..set<String>(USER_SENHA_COLUMN, model.senha!);

      final ParseResponse response = await parseObject.save();

      if (!response.success) throw Exception(ParseErrorsUtils.get(response.statusCode));
    } catch (e) {
      throw Exception(e);
    }
  }
}
