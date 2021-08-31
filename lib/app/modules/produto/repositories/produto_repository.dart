import 'dart:io';

import 'package:parse_server_sdk/parse_server_sdk.dart';
import 'package:strapen_app/app/modules/produto/constants/columns.dart';
import 'package:strapen_app/app/modules/produto/models/produto_model.dart';
import 'package:strapen_app/app/modules/produto/repositories/iproduto_repository.dart';
import 'package:strapen_app/app/modules/user/factories/user_factory.dart';
import 'package:strapen_app/app/shared/extensions/string_extension.dart';
import 'package:strapen_app/app/shared/utils/parse_errors_utils.dart';

class ProdutoRepository implements IProdutoRepository {
  @override
  String className() => "Produto";

  @override
  void validate(ProdutoModel model) {
    if (model.descricao.isNullOrEmpty()) throw Exception("Informe uma descrição para o produto.");
    if (model.descricaoDetalhada.isNullOrEmpty()) throw Exception("Informe uma descrição mais detalhada para o produto.");
    if ((model.quantidade ?? 0) <= 0) throw Exception("Informe uma quantidade válida para o produto.");
    if ((model.preco ?? 0) <= 0) throw Exception("Informe um preço válido para o produto.");
    if ((model.fotos?.length ?? 0) == 0) throw Exception("Selecione fotos do seu produto.");
    if (model.anunciante?.id == null) throw Exception("Houve um erro ao salvar o seu produto, tente novamente.\nSe o erro persistir, reinicie o aplicativo.");
  }

  @override
  ParseObject toParseObject(ProdutoModel model) {
    ParseObject parseObject = ParseObject(className())..set<String?>(ID_COLUMN, model.id)..set<String>(DESCRICAO_COLUMN, model.descricao!)..set<String>(DESCRICAO_DETALHADA_COLUMN, model.descricaoDetalhada!)..set<int>(QUANTIDADE_COLUMN, model.quantidade!)..set<double>(PRECO_COLUMN, model.preco!)..set<ParseUser>(ANUNCIANTE_COLUMN, ParseUser(null, null, null)..set(ID_COLUMN, model.anunciante!.id!));

    if (model.userReserva != null) parseObject.set<ParseUser>(USER_RESERVA_COLUMN, ParseUser(null, null, null)..set(ID_COLUMN, model.userReserva!.id!));

    return parseObject;
  }

  @override
  ProdutoModel toModel(ParseObject e) {
    return ProdutoModel(
      e.get<String>(ID_COLUMN),
      e.get<String>(DESCRICAO_COLUMN),
      e.get<String>(DESCRICAO_DETALHADA_COLUMN),
      e.get<List>(FOTOS_COLUMN)?.map((e) => e.url).toList(),
      e.get<int>(QUANTIDADE_COLUMN),
      e.get(PRECO_COLUMN) is int ? e.get<int>(PRECO_COLUMN)?.toDouble() ?? null : e.get<double>(PRECO_COLUMN),
      UserFactory.newModel()..id = e.get(ANUNCIANTE_COLUMN).get<String>(ID_COLUMN),
      e.containsKey(USER_RESERVA_COLUMN) ? (UserFactory.newModel()..id = e.get(USER_RESERVA_COLUMN).get<String>(ID_COLUMN)) : null,
    );
  }

  @override
  Future<ProdutoModel?> save(ProdutoModel model) async {
    try {
      validate(model);

      List<ParseFileBase> parseImages = await _saveImagens(model.fotos!);

      ParseObject parseProduto = toParseObject(model)..set<List<ParseFileBase>>(FOTOS_COLUMN, parseImages);

      ParseResponse response = await parseProduto.save();

      if (!response.success) throw Exception(ParseErrorsUtils.get(response.statusCode));
      ParseObject parseResponse = (response.results as List<dynamic>).first;

      return toModel(parseResponse);
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<List<ProdutoModel>?> getByUser(String? id) async {
    try {
      if (id == null) throw Exception("Houve um erro ao buscar seus produtos, tente novamente.\nSe o erro persistir, reinicie o aplicativo.");

      QueryBuilder query = QueryBuilder<ParseObject>(ParseObject(className()))
        ..whereEqualTo(
          ANUNCIANTE_COLUMN,
          (ParseUser(null, null, null)..set(ID_COLUMN, id)).toPointer(),
        );

      ParseResponse response = await query.query();

      if (!response.success) throw Exception(ParseErrorsUtils.get(response.statusCode));
      List<ParseObject>? parseResponse = response.results as List<ParseObject>?;

      List<ProdutoModel> produtos = parseResponse?.map((e) => toModel(e)).toList() ?? [];

      return produtos;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<List<ParseFileBase>> _saveImagens(List<dynamic> fotos) async {
    final List<ParseFileBase> parseImagens = <ParseFileBase>[];
    int count = 1;

    try {
      for (var foto in fotos) {
        if (foto is File) {
          ParseFile parseFile = ParseFile(foto, name: "image$count");

          ParseResponse response = await parseFile.save();
          if (!response.success) throw Exception(ParseErrorsUtils.get(response.statusCode));

          parseImagens.add(parseFile);
        } else {
          final parseFile = ParseFile(null)
            ..name = "image$count"
            ..url = foto.toString();

          parseImagens.add(parseFile);
        }

        count++;
      }

      return parseImagens;
    } catch (e) {
      throw Exception(e);
    }
  }
}
