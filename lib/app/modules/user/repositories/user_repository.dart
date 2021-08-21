import 'dart:typed_data';

import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:strapen_app/app/modules/user/constants/columns.dart';
import 'package:strapen_app/app/modules/user/models/user_model.dart';
import 'package:strapen_app/app/modules/user/repositories/user_repository_interface.dart';
import 'package:strapen_app/app/shared/config/preferences/session_preferences.dart';
import 'package:strapen_app/app/shared/config/preferences/session_preferences_model.dart';
import 'package:strapen_app/app/shared/extensions/string_extension.dart';
import 'package:strapen_app/app/shared/utils/parse_errors_utils.dart';

class UserRepository implements IUserRepository {
  final SessionPreferences _sharedPreferences;

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
    return ParseUser.createUser(model.username, model.senha, model.email)
      ..set<String?>(ID_COLUMN, model.id)
      ..set<String>(NOME_COLUMN, model.nome!)
      ..set<DateTime>(DATANASCIMENTO_COLUMN, model.dataNascimento!)
      ..set<String>(CPFCNPJ_COLUMN, model.cpfCnpj!)
      ..set<String>(TELEFONE_COLUMN, model.telefone!)
      ..set<String?>(DESCRICAO_COLUMN, model.descricao)
      ..set<String>(CEP_COLUMN, model.cep!)
      ..set<String>(CIDADE_COLUMN, model.cidade!)
      ..set<Uint8List?>(FOTO_COLUMN, model.foto);
  }

  @override
  UserModel toModel(ParseObject e) {
    return UserModel(
      e.get<String>(ID_COLUMN),
      e.get<String>(NOME_COLUMN),
      e.get<String?>(DESCRICAO_COLUMN),
      e.get<DateTime>(DATANASCIMENTO_COLUMN),
      e.get<String>(CPFCNPJ_COLUMN),
      e.get<Uint8List?>(FOTO_COLUMN),
      e.get<String>(USERNAME_COLUMN),
      e.get<String>(EMAIL_COLUMN),
      e.get<String>(TELEFONE_COLUMN),
      e.get<String>(CEP_COLUMN),
      e.get<String>(CIDADE_COLUMN),
      null,
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

      _sharedPreferences.save(
        SessionPreferencesModel(
          model.id,
          model.username,
          model.email,
          senha,
          parse.get<String>("sessionToken"),
        ),
      );

      return model;
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
