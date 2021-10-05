import 'package:parse_server_sdk/parse_server_sdk.dart';
import 'package:strapen_app/app/modules/reserva/constants/columns.dart';
import 'package:strapen_app/app/modules/reserva/enums/enum_status_reserva.dart';
import 'package:strapen_app/app/modules/reserva/models/reserva_model.dart';
import 'package:strapen_app/app/modules/reserva/repositories/ireserva_repository.dart';
import 'package:strapen_app/app/modules/user/constants/columns.dart';
import 'package:strapen_app/app/modules/user/factories/user_factory.dart';
import 'package:strapen_app/app/modules/user/repositories/iuser_repository.dart';
import 'package:strapen_app/app/shared/extensions/string_extension.dart';
import 'package:strapen_app/app/shared/utils/parse_errors_utils.dart';

class ReservaRepository implements IReservaRepository {
  final IUserRepository _userRepository;

  ReservaRepository(this._userRepository);

  @override
  String className() => "Reserva";
  String messageError() => "Houve um erro ao reservar o produto.";

  @override
  void validate(ReservaModel model) {
    if (model.idProduto.isNullOrEmpty()) throw Exception(messageError());
    if (model.descricao.isNullOrEmpty()) throw Exception(messageError());
    if (model.descricaoDetalhada.isNullOrEmpty()) throw Exception(messageError());
    if ((model.quantidade ?? 0) <= 0) throw Exception("Informe uma quantidade válida para reservar o produto.");
    if ((model.preco ?? 0) <= 0) throw Exception(messageError());
    if ((model.fotos?.length ?? 0) == 0) throw Exception(messageError());
    if (model.user?.id == null) throw Exception(messageError());
    if (model.anunciante == null) throw Exception(messageError());
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
      ..set<ParseUser>(
        RESERVA_USER_COLUMN,
        ParseUser(null, null, null)..set(USER_ID_COLUMN, model.user!.id!),
      )
      ..set<String>(RESERVA_ANUNCIANTE_COLUMN, model.anunciante!.id!)
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
      e.get<List<String>>(RESERVA_FOTOS_COLUMN)?.map((e) => e).toList(),
      UserFactory.newModel()..id = e.get(RESERVA_USER_COLUMN).get<String>(USER_ID_COLUMN),
      null,
      EnumStatusReservaHelper.get(e.get<int>(RESERVA_STATUS_COLUMN) ?? 0),
      e.get<DateTime>(RESERVA_DATA_HORA_CRIADO_COLUMN),
    );
  }

  @override
  Future<ReservaModel> save(ReservaModel model) async {
    try {
      validate(model);

      ParseObject parseReserva = toParseObject(model);

      ParseResponse response = await parseReserva.save();

      if (!response.success) throw Exception(ParseErrorsUtils.get(response.statusCode));
      ParseObject parseResponse = (response.results as List<dynamic>).first;

      ReservaModel reservaModel = toModel(parseResponse);

      return reservaModel;
    } catch(e) {
      throw Exception(e);
    }
  }

  @override
  Future<List<ReservaModel>> getAll(String idUser) async {
    try {
      QueryBuilder query = QueryBuilder<ParseObject>(ParseObject(className()))
        ..whereEqualTo(
          RESERVA_USER_COLUMN,
          (ParseUser(null, null, null)..set(USER_ID_COLUMN, idUser)).toPointer(),
        );

      ParseResponse response = await query.query();

      if (!response.success) throw Exception(ParseErrorsUtils.get(response.statusCode));
      List<ParseObject>? parseResponseList = response.results as List<ParseObject>?;

      if (parseResponseList?.isEmpty ?? true) return [];

      List<ReservaModel> reservas = [];
      for (var parse in parseResponseList!) {
        reservas.add(toModel(parse)..anunciante = await _userRepository.getById(parse.get<String>(RESERVA_ANUNCIANTE_COLUMN)));
      }

      return reservas;
    } catch(e) {
      throw Exception(e);
    }
  }
}