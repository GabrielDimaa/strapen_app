import 'package:flutter_modular/flutter_modular.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:strapen_app/app/modules/catalogo/models/catalogo_model.dart';
import 'package:strapen_app/app/modules/catalogo/repositories/icatalogo_repository.dart';
import 'package:strapen_app/app/modules/live/constants/columns.dart';
import 'package:strapen_app/app/modules/live/controllers/live_controller.dart';
import 'package:strapen_app/app/modules/live/models/live_demonstracao_model.dart';
import 'package:strapen_app/app/modules/live/models/live_model.dart';
import 'package:strapen_app/app/modules/live/repositories/ilive_repository.dart';
import 'package:strapen_app/app/modules/user/constants/columns.dart';
import 'package:strapen_app/app/modules/user/models/user_model.dart';
import 'package:strapen_app/app/modules/user/repositories/iseguidor_repository.dart';
import 'package:strapen_app/app/modules/user/repositories/user_repository.dart';
import 'package:strapen_app/app/shared/extensions/string_extension.dart';
import 'package:strapen_app/app/shared/utils/parse_errors_utils.dart';

class LiveRepository implements ILiveRepository {
  final ICatalogoRepository? _catalogoRepository;
  final ISeguidorRepository? _seguidorRepository;

  LiveRepository(this._catalogoRepository, this._seguidorRepository);

  @override
  String className() => "Live";

  LiveQuery? liveQuery;
  Subscription? subscription;

  @override
  void validate(LiveModel model) {
    String messageError = "Houve um erro ao criar sua Live.\nSe o erro persistir reinicie o aplicativo.";
    if (model.streamKey.isNullOrEmpty()) throw Exception(messageError);
    if (model.liveId.isNullOrEmpty()) throw Exception(messageError);
    if (model.playBackId.isNullOrEmpty()) throw Exception(messageError);
    if (model.aspectRatio == null) throw Exception(messageError);
  }

  @override
  ParseObject toParseObject(LiveModel model) {
    ParseObject parseObject = ParseObject(className())
      ..set<String?>(LIVE_ID_COLUMN, model.id)
      ..set<String>(LIVE_ID_LIVE_COLUMN, model.liveId!)
      ..set<String>(LIVE_STREAM_KEY_COLUMN, model.streamKey!)
      ..set<String>(LIVE_PLAYBACK_ID_COLUMN, model.playBackId!)
      ..set<bool>(LIVE_FINALIZADA_COLUMN, model.finalizada ?? false)
      ..set<double>(LIVE_ASPECT_RATIO_COLUMN, model.aspectRatio!)
      ..set<ParseUser>(LIVE_USER_COLUMN, ParseUser(null, null, null)
        ..set(USER_ID_COLUMN, model.user!.id!));

    return parseObject;
  }

  @override
  LiveModel toModel(ParseObject e) {
    return LiveModel(
      e.get<String>(LIVE_ID_COLUMN),
      e.get<String>(LIVE_ID_LIVE_COLUMN),
      e.get<String>(LIVE_STREAM_KEY_COLUMN),
      e.get<String>(LIVE_PLAYBACK_ID_COLUMN),
      e.get<bool>(LIVE_FINALIZADA_COLUMN),
      e.get<double>(LIVE_ASPECT_RATIO_COLUMN),
      null,
      UserRepository(null).toModel(e.get(LIVE_USER_COLUMN)),
    );
  }

  @override
  Future<LiveModel> save(LiveModel model) async {
    try {
      validate(model);

      ParseObject parseLive = toParseObject(model);
      parseLive.addRelation(LIVE_CATALOGO_COLUMN, model.catalogos!.map((e) {
        return ParseObject(_catalogoRepository!.className())..objectId = e.id;
      }).toList());

      ParseResponse response = await parseLive.save();

      if (!response.success) throw Exception(ParseErrorsUtils.get(response.statusCode));
      ParseObject parseResponse = (response.results as List<dynamic>).first;

      LiveModel liveModelResponse = toModel(parseResponse);
      model.id = liveModelResponse.id;

      return model;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<LiveModel?> isAovivo(UserModel userModel) async {
    try {
      if (userModel.id == null) throw Exception("Houve um erro, tente novamente.\nSe o erro persistir, reinicie o aplicativo.");

      QueryBuilder query = QueryBuilder<ParseObject>(ParseObject(className()))
        ..whereEqualTo(LIVE_USER_COLUMN, (ParseUser(null, null, null)
          ..set(USER_ID_COLUMN, userModel.id)).toPointer())
        ..includeObject([LIVE_USER_COLUMN])
        ..orderByDescending(LIVE_DATA_CRIADO_COLUMN)
        ..setLimit(1);

      ParseResponse response = await query.query();

      if (response.result != null) {
        if (!response.success) throw Exception(ParseErrorsUtils.get(response.statusCode));
        ParseObject parseResponse = (response.results as List<dynamic>).first;

        return toModel(parseResponse);
      }

      return null;
    } catch(e) {
      throw Exception(e);
    }
  }

  @override
  Future<void> finalizar(LiveModel model) async {
    try {
      if (model.id == null) throw Exception("Houve um erro ao finalizar a Live.");

      final ParseObject parseObject = ParseObject(className())
        ..objectId = model.id
        ..set<bool>(LIVE_FINALIZADA_COLUMN, true);

      final ParseResponse response = await parseObject.save();

      if (!response.success) throw Exception(ParseErrorsUtils.get(response.statusCode));
    } catch(e) {
      throw Exception(e);
    }
  }

  @override
  Future<List<CatalogoModel>> getCatalogosLive(String idLive) async {
    try {
      QueryBuilder query = QueryBuilder<ParseObject>(ParseObject(_catalogoRepository!.className()))
        ..whereRelatedTo(LIVE_CATALOGO_COLUMN, className(), idLive);

      ParseResponse response = await query.query();

      if (!response.success) throw Exception(ParseErrorsUtils.get(response.statusCode));
      List<ParseObject>? parseResponse = response.results as List<ParseObject>?;

      if (parseResponse == null)
        throw Exception("Houve um erro ao buscar os catálogos.");

      List<CatalogoModel> catalogos = parseResponse.map((e) => _catalogoRepository!.toModel(e)).toList();

      for (var cat in catalogos) {
        cat.produtos = await _catalogoRepository!.getProdutosCatalogo(cat.id);
      }

      return catalogos;
    } catch(e) {
      throw Exception(e);
    }
  }

  @override
  Future<int> getCountLives(String idUser) async {
    try {
      final QueryBuilder<ParseObject> query = QueryBuilder(ParseObject(className()));
      query
        ..whereEqualTo(
          LIVE_USER_COLUMN,
          (ParseUser(null, null, null)
            ..set(USER_ID_COLUMN, idUser)).toPointer(),
        )
        ..count();

      final ParseResponse? response = await query.count();

      return (response?.result?[0] ?? 0) as int;
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<LiveDemonstracaoModel> getLivesDemonstracao(String idUser) async {
    try {
      LiveDemonstracaoModel livesFiltradas = LiveDemonstracaoModel([], []);
      List<String> usersId = await _seguidorRepository!.getAllSeguindo(idUser);

      if (usersId.isNotEmpty) {
        final QueryBuilder query = QueryBuilder<ParseObject>.or(
          ParseObject(className()),
          usersId.map((id) {
            return QueryBuilder(ParseObject(className()))
              ..whereEqualTo(LIVE_USER_COLUMN, (ParseUser(null, null, null)..set(USER_ID_COLUMN, id)).toPointer());
          }).toList())
          ..whereEqualTo(LIVE_FINALIZADA_COLUMN, false)
          ..includeObject([LIVE_USER_COLUMN])
          ..orderByDescending(LIVE_DATA_CRIADO_COLUMN)
          ..setLimit(15);

        final ParseResponse response = await query.query();

        if (!response.success) throw Exception(ParseErrorsUtils.get(response.statusCode));
        final List<ParseObject>? parseResponse = response.results as List<ParseObject>?;

        if (parseResponse?.isNotEmpty ?? false)
          livesFiltradas.livesSeguindo!.addAll(parseResponse!.map((e) {
            //Busca somente o username
            return toModel(e)..user!.username = e.get(LIVE_USER_COLUMN).get<String>(USER_USERNAME_COLUMN);
          }).toList());
      }

      QueryBuilder query;

      if (usersId.isNotEmpty) {
        query = QueryBuilder<ParseObject>.or(
          ParseObject(className()),
          usersId.map((id) {
            return QueryBuilder(ParseObject(className()))
              ..whereNotEqualTo(LIVE_USER_COLUMN, (ParseUser(null, null, null)..set(USER_ID_COLUMN, id)).toPointer());
          }).toList());
      } else {
        query = QueryBuilder<ParseObject>(ParseObject(className()));
      }

      query.includeObject([LIVE_USER_COLUMN]);
      query..whereEqualTo(LIVE_FINALIZADA_COLUMN, false);
      query..orderByDescending(LIVE_DATA_CRIADO_COLUMN);
      query..setLimit(15);

      final ParseResponse response = await query.query();

      if (!response.success) throw Exception(ParseErrorsUtils.get(response.statusCode));
      final List<ParseObject>? parseResponse = response.results as List<ParseObject>?;

      if (parseResponse?.isNotEmpty ?? false)
        livesFiltradas.livesOutros!.addAll(parseResponse!.map((e) => toModel(e)).toList());

      return livesFiltradas;
    } catch(e) {
      throw Exception(e);
    }
  }

  Future<void> startListener(String idLive) async {
    try {
      if (liveQuery == null) liveQuery = LiveQuery();

      if (subscription == null) {
        final QueryBuilder query = QueryBuilder<ParseObject>(ParseObject(className()))
          ..whereEqualTo(LIVE_ID_COLUMN, idLive);

        subscription = await liveQuery!.client.subscribe(query);

        subscription!.on(LiveQueryEvent.update, (value) {
          final LiveController liveController = Modular.get<LiveController>();

          final LiveModel model = toModel(value);
          //Inserido o delay considerando o delay da Live
          Future.delayed(Duration(seconds: 12), () {
            liveController.setLiveEncerrada(model.finalizada ?? false);
          });
        });
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  void stopListener() => liveQuery?.client.unSubscribe(subscription!);
}