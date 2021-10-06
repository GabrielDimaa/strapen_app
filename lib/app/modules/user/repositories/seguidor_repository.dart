import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:strapen_app/app/modules/user/constants/columns.dart';
import 'package:strapen_app/app/modules/user/models/seguidor_model.dart';
import 'package:strapen_app/app/modules/user/models/user_model.dart';
import 'package:strapen_app/app/modules/user/repositories/iseguidor_repository.dart';
import 'package:strapen_app/app/shared/utils/parse_errors_utils.dart';

class SeguidorRepository implements ISeguidorRepository {
  @override
  String className() => "Seguidor";

  @override
  void validate(SeguidorModel model) {
    final String messageError = "Não foi possível seguir esse usuário.";
    if (model.user == null) throw Exception(messageError);
    if (model.seguindo == null) throw Exception(messageError);
  }

  @override
  ParseObject toParseObject(SeguidorModel model) {
    // TODO: implement toParseObject
    throw UnimplementedError();
  }

  @override
  SeguidorModel toModel(ParseObject e) {
    // TODO: implement toParseObject
    throw UnimplementedError();
  }

  @override
  Future<bool> seguir(UserModel user, UserModel seguirUser) async {
    try {
      ParseObject parseObject = ParseObject(className())
        ..set<ParseUser>(
          SEGUIDOR_USER_COLUMN,
          ParseUser(null, null, null)..set(USER_ID_COLUMN, user.id!),
        )
        ..set<ParseUser>(
          SEGUIDOR_SEGUINDO_COLUMN,
          ParseUser(null, null, null)..set(USER_ID_COLUMN, seguirUser.id!),
        );

      ParseResponse response = await parseObject.save();

      if (!response.success) throw Exception(ParseErrorsUtils.get(response.statusCode));
      ParseObject parseResponse = (response.results as List<dynamic>).first;

      return parseResponse.get<String>(SEGUIDOR_ID_COLUMN) != null;
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<bool> deixarSeguir(UserModel user, UserModel seguirUser) async {
    try {
      final QueryBuilder<ParseObject> query = QueryBuilder(ParseObject(className()));
      query
        ..whereEqualTo(
          SEGUIDOR_USER_COLUMN,
          (ParseUser(null, null, null)..set(USER_ID_COLUMN, user.id!)).toPointer(),
        )
        ..whereEqualTo(
          SEGUIDOR_SEGUINDO_COLUMN,
          (ParseUser(null, null, null)..set(USER_ID_COLUMN, seguirUser.id!)).toPointer(),
        );

      ParseResponse? response = await query.query();
      if (!response.success) throw Exception(ParseErrorsUtils.get(response.statusCode));
      ParseObject parseResponse = (response.results as List<dynamic>).first;

      response = await ParseObject(className()).delete(id: parseResponse.get<String>(USER_ID_COLUMN));

      if (!response.success) throw Exception(ParseErrorsUtils.get(response.statusCode));
      parseResponse = (response.results as List<dynamic>).first;

      return response.success;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<bool> estaSeguindo(UserModel user, UserModel seguirUser) async {
    try {
      final QueryBuilder<ParseObject> query = QueryBuilder(ParseObject(className()));
      query
        ..whereEqualTo(
          SEGUIDOR_USER_COLUMN,
          (ParseUser(null, null, null)..set(USER_ID_COLUMN, user.id!)).toPointer(),
        )
        ..whereEqualTo(
          SEGUIDOR_SEGUINDO_COLUMN,
          (ParseUser(null, null, null)..set(USER_ID_COLUMN, seguirUser.id!)).toPointer(),
        );

      ParseResponse response = await query.query();

      if (!response.success) throw Exception(ParseErrorsUtils.get(response.statusCode));
      ParseObject? parseResponse = (response.results as List<dynamic>).first;

      return parseResponse?.get<String>(SEGUIDOR_ID_COLUMN) != null;
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<int> getCountSeguidores(String idUser) async {
    try {
      final QueryBuilder<ParseObject> query = QueryBuilder(ParseObject(className()));
      query
        ..whereEqualTo(
          SEGUIDOR_SEGUINDO_COLUMN,
          (ParseUser(null, null, null)..set(USER_ID_COLUMN, idUser)).toPointer(),
        )
        ..count();

      final ParseResponse? response = await query.count();

      return (response?.result?[0] ?? 0) as int;
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<int> getCountSeguindo(String idUser) async {
    try {
      final QueryBuilder<ParseObject> query = QueryBuilder(ParseObject(className()));
      query
        ..whereEqualTo(
          SEGUIDOR_USER_COLUMN,
          (ParseUser(null, null, null)..set(USER_ID_COLUMN, idUser)).toPointer(),
        )
        ..count();

      final ParseResponse? response = await query.count();

      return (response?.result?[0] ?? 0) as int;
    } catch (e) {
      throw Exception(e);
    }
  }
}
