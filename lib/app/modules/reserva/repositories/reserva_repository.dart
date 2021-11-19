import 'package:flutter_modular/flutter_modular.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:strapen_app/app/modules/live/constants/columns.dart';
import 'package:strapen_app/app/modules/live/controllers/live_controller.dart';
import 'package:strapen_app/app/modules/live/factories/live_factory.dart';
import 'package:strapen_app/app/modules/live/repositories/live_repository.dart';
import 'package:strapen_app/app/modules/reserva/constants/columns.dart';
import 'package:strapen_app/app/modules/reserva/enums/enum_status_reserva.dart';
import 'package:strapen_app/app/modules/reserva/models/reserva_model.dart';
import 'package:strapen_app/app/modules/reserva/repositories/ireserva_repository.dart';
import 'package:strapen_app/app/modules/user/constants/columns.dart';
import 'package:strapen_app/app/modules/user/repositories/user_repository.dart';
import 'package:strapen_app/app/shared/extensions/string_extension.dart';
import 'package:strapen_app/app/shared/utils/connectivity_utils.dart';
import 'package:strapen_app/app/shared/utils/parse_errors_utils.dart';

class ReservaRepository implements IReservaRepository {
  @override
  String className() => "Reserva";
  String messageError() => "Houve um erro ao reservar o produto.";

  LiveQuery? liveQuery;
  Subscription? subscription;

  @override
  void validate(ReservaModel model) {
    if (model.idProduto.isNullOrEmpty()) throw Exception(messageError());
    if (model.descricao.isNullOrEmpty()) throw Exception(messageError());
    if (model.descricaoDetalhada.isNullOrEmpty()) throw Exception(messageError());
    if ((model.quantidade ?? 0) <= 0) throw Exception("Informe uma quantidade válida para reservar o produto.");
    if ((model.preco ?? 0) <= 0) throw Exception(messageError());
    if ((model.fotos?.length ?? 0) == 0) throw Exception(messageError());
    if (model.user?.id == null) throw Exception(messageError());
    if (model.anunciante?.id == null) throw Exception(messageError());
  }

  @override
  ParseObject toParseObject(ReservaModel model) {
    return ParseObject(className())
      ..set<String?>(RESERVA_ID_COLUMN, model.id)
      ..set<String>(RESERVA_ID_PRODUTO_COLUMN, model.idProduto!)
      ..set<String>(RESERVA_DESCRICAO_COLUMN, model.descricao!)
      ..set<String>(RESERVA_DESCRICAO_DETALHADA_COLUMN, model.descricaoDetalhada!)
      ..set<int>(RESERVA_QUANTIDADE_COLUMN, model.quantidade!)
      ..set<double>(RESERVA_PRECO_COLUMN, model.preco!)
      ..set<List>(RESERVA_FOTOS_COLUMN, model.fotos!)
      ..set<ParseObject>(
        RESERVA_LIVE_COLUMN,
        ParseObject(LiveRepository(null, null).className())..set(LIVE_ID_COLUMN, model.live!.id!),
      )
      ..set<ParseUser>(
        RESERVA_USER_COLUMN,
        ParseUser(null, null, null)..set(USER_ID_COLUMN, model.user!.id!),
      )
      ..set<ParseUser>(
        RESERVA_ANUNCIANTE_COLUMN,
        ParseUser(null, null, null)..set(USER_ID_COLUMN, model.anunciante!.id!),
      )
      ..set<int>(RESERVA_STATUS_COLUMN, EnumStatusReservaHelper.getValue(model.status!));
  }

  @override
  ReservaModel toModel(ParseObject e) {
    return ReservaModel(
      e.get<String>(RESERVA_ID_COLUMN),
      e.get<String>(RESERVA_ID_PRODUTO_COLUMN),
      e.get<String>(RESERVA_DESCRICAO_COLUMN),
      e.get<String>(RESERVA_DESCRICAO_DETALHADA_COLUMN),
      e.get<int>(RESERVA_QUANTIDADE_COLUMN),
      e.get(RESERVA_PRECO_COLUMN) is int ? e.get<int>(RESERVA_PRECO_COLUMN)?.toDouble() ?? null : e.get<double>(RESERVA_PRECO_COLUMN),
      e.get<List>(RESERVA_FOTOS_COLUMN)?.map((e) => e.toString()).toList() ?? [],
      LiveFactory.newModel()..id = e.get(RESERVA_LIVE_COLUMN).get(LIVE_ID_COLUMN),
      UserRepository(null).toModel(e.get(RESERVA_USER_COLUMN)),
      UserRepository(null).toModel(e.get(RESERVA_ANUNCIANTE_COLUMN)),
      EnumStatusReservaHelper.get(e.get<int>(RESERVA_STATUS_COLUMN) ?? 0),
      e.get<DateTime>(RESERVA_DATA_HORA_CRIADO_COLUMN),
    );
  }

  @override
  Future<ReservaModel> save(ReservaModel model) async {
    try {
      await ConnectivityUtils.hasInternet();
      validate(model);

      ParseObject parseReserva = toParseObject(model);

      ParseResponse response = await parseReserva.save();

      if (!response.success) throw Exception(response.error?.message ?? "Não foi possível completar a compra desse produto!");
      ParseObject parseResponse = (response.results as List<dynamic>).first;

      ReservaModel reservaModel = toModel(parseResponse);

      return reservaModel;
    } catch(e) {
      throw Exception(e);
    }
  }

  @override
  Future<bool> alterarStatus(ReservaModel model) async {
    try {
      await ConnectivityUtils.hasInternet();

      if (model.id == null) throw Exception("Houve um erro ao tentar alterar o status do pedido!");

      ParseObject parseReserva = ParseObject(className());
      parseReserva.set<String>(RESERVA_ID_COLUMN, model.id!);
      parseReserva.set<int>(RESERVA_STATUS_COLUMN, EnumStatusReservaHelper.getValue(model.status!));

      final ParseResponse response = await parseReserva.save();

      if (!response.success) throw Exception(response.error?.message ?? "Não foi possível alterar o status!");

      return response.success;
    } catch(e) {
      throw Exception(e);
    }
  }

  @override
  Future<List<ReservaModel>> getAllCompras(String idUser, {int? limit}) async {
    try {
      await ConnectivityUtils.hasInternet();

      QueryBuilder query = QueryBuilder<ParseObject>(ParseObject(className()))
        ..includeObject([RESERVA_USER_COLUMN, RESERVA_ANUNCIANTE_COLUMN])
        ..whereEqualTo(
          RESERVA_USER_COLUMN,
          (ParseUser(null, null, null)..set(USER_ID_COLUMN, idUser)).toPointer())
        ..orderByDescending(RESERVA_DATA_HORA_CRIADO_COLUMN);

      if (limit != null) query..setLimit(limit);

      ParseResponse response = await query.query();

      if (!response.success) throw Exception(ParseErrorsUtils.get(response.statusCode));
      List<ParseObject>? parseResponseList = response.results as List<ParseObject>?;

      return parseResponseList?.map((e) => toModel(e)).toList() ?? [];
    } catch(e) {
      throw Exception(e);
    }
  }

  @override
  Future<List<ReservaModel>> getAllReservas(String idUser, {int? limit}) async {
    try {
      await ConnectivityUtils.hasInternet();

      QueryBuilder query = QueryBuilder<ParseObject>(ParseObject(className()))
        ..includeObject([RESERVA_USER_COLUMN, RESERVA_ANUNCIANTE_COLUMN])
        ..whereEqualTo(
            RESERVA_ANUNCIANTE_COLUMN,
            (ParseUser(null, null, null)..set(USER_ID_COLUMN, idUser)).toPointer())
        ..orderByDescending(RESERVA_DATA_HORA_CRIADO_COLUMN);

      if (limit != null) query..setLimit(limit);

      ParseResponse response = await query.query();

      if (!response.success) throw Exception(ParseErrorsUtils.get(response.statusCode));
      List<ParseObject>? parseResponseList = response.results as List<ParseObject>?;

      return parseResponseList?.map((e) => toModel(e)).toList() ?? [];
    } catch(e) {
      throw Exception(e);
    }
  }

  ///LiveQuery utilizado apenas para os usuários que estão transmitindo a Live.
  Future<void> startListener(String idLive) async {
    try {
      await ConnectivityUtils.hasInternet();

      if (liveQuery == null) liveQuery = LiveQuery();

      if (subscription == null) {
        final QueryBuilder query = QueryBuilder<ParseObject>(ParseObject(className()))
          ..whereEqualTo(
            RESERVA_LIVE_COLUMN,
            (ParseObject(LiveRepository(null, null).className())..set(LIVE_ID_COLUMN, idLive)).toPointer());

        subscription = await liveQuery!.client.subscribe(query);

        subscription!.on(LiveQueryEvent.create, (value) {
          final LiveController liveController = Modular.get<LiveController>();
          liveController.reservas.add(toModel(value));
        });
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  void stopListener() => liveQuery?.client.unSubscribe(subscription!);
}