import 'package:flutter_modular/flutter_modular.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:strapen_app/app/app_controller.dart';
import 'package:strapen_app/app/modules/user/constants/columns.dart';
import 'package:strapen_app/app/modules/user/models/user_model.dart';
import 'package:strapen_app/app/modules/user/repositories/iuser_repository.dart';
import 'package:strapen_app/app/shared/config/preferences/session_preferences.dart';
import 'package:strapen_app/app/shared/config/preferences/session_preferences_model.dart';
import 'package:strapen_app/app/shared/extensions/string_extension.dart';
import 'package:strapen_app/app/shared/utils/parse_errors_utils.dart';
import 'package:strapen_app/app/shared/utils/parse_images_utils.dart';

class UserRepository implements IUserRepository {
  final SessionPreferences? _sessionPreferences;

  UserRepository(this._sessionPreferences);

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
    if (model.foto == null) throw Exception("Selecione uma foto para seu perfil.");
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
      ..set<String?>(USER_BIO_COLUMN, model.bio)
      ..set<String>(USER_CEP_COLUMN, model.cep!)
      ..set<String>(USER_CIDADE_COLUMN, model.cidade!)
      ..set<bool>(USER_FIST_LIVE_COLUMN, model.firstLive ?? true);
  }

  @override
  UserModel toModel(ParseObject e) {
    return UserModel(
      e.get<String>(USER_ID_COLUMN),
      e.get<String>(USER_NOME_COLUMN),
      e.get<String?>(USER_BIO_COLUMN),
      e.get<DateTime>(USER_DATANASCIMENTO_COLUMN),
      e.get<String>(USER_CPFCNPJ_COLUMN),
      e.get<dynamic>(USER_FOTO_COLUMN)?.first?.url,
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
    await _sessionPreferences!.save(
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

      List<ParseFileBase> parseImage = await ParseImageUtils.save([model.foto]);

      ParseUser user = toParseObject(model)..set<List<ParseFileBase>>(USER_FOTO_COLUMN, parseImage);
      user.setACL(ParseACL()
        ..setPublicReadAccess(allowed: true)
        ..setPublicWriteAccess(allowed: true));

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
  Future<UserModel> getById(String? id) async {
    try {
      if (id == null) throw Exception("Houve um erro ao buscar o usuário!");

      QueryBuilder query = QueryBuilder<ParseObject>(ParseObject(className()))..whereEqualTo(USER_ID_COLUMN, id);

      ParseResponse response = await query.query();

      if (!response.success) throw Exception(ParseErrorsUtils.get(response.statusCode));
      ParseObject parse = (response.results as List<dynamic>).first;

      return toModel(parse);
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<void> update(UserModel model) async {
    try {
      if (model.id == null) throw Exception("Houve um erro ao atualizar seus dados.");

      List<ParseFileBase> parseImage = await ParseImageUtils.save([model.foto]);

      ParseUser user = toParseObject(model)..set<List<ParseFileBase>>(USER_FOTO_COLUMN, parseImage);
      ParseResponse response = await user.save();

      if (!response.success) throw Exception(ParseErrorsUtils.get(response.statusCode));

      SessionPreferencesModel session = await _sessionPreferences!.get();
      await _sessionPreferences!.save(SessionPreferencesModel(
        model.id,
        model.username,
        model.email,
        session.senha,
        session.sessionToken,
      ));
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

      await _sessionPreferences!.updateSenha(model.senha!);

      if (!response.success) throw Exception(ParseErrorsUtils.get(response.statusCode));
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<UserModel?> fetchSearch(String text) async {
    try {
      final QueryBuilder<ParseObject> query = QueryBuilder(ParseUser.forQuery());
      query.whereContains(USER_NOME_COLUMN, text.toLowerCase(), caseSensitive: false);
      query.whereNotEqualTo(USER_ID_COLUMN, Modular.get<AppController>().userModel!.id);
      query.setLimit(30);

      final ParseResponse response = await query.query();

      if (!response.success) throw Exception(ParseErrorsUtils.get(response.statusCode));
      ParseObject? parseResponse = (response.results as List<ParseObject>?)?.first;

      if (parseResponse != null) return toModel(parseResponse);

      return null;
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<void> seguirUser(UserModel text) async {
    try {

    } catch(e) {
      throw Exception(e);
    }
  }
}
