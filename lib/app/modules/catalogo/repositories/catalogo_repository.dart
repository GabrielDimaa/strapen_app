import 'dart:io';

import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:strapen_app/app/modules/catalogo/constants/columns.dart';
import 'package:strapen_app/app/modules/catalogo/models/catalogo_model.dart';
import 'package:strapen_app/app/modules/catalogo/repositories/icatalogo_repository.dart';
import 'package:strapen_app/app/modules/produto/models/produto_model.dart';
import 'package:strapen_app/app/modules/produto/repositories/produto_repository.dart';
import 'package:strapen_app/app/modules/user/repositories/user_repository.dart';
import 'package:strapen_app/app/shared/extensions/string_extension.dart';
import 'package:strapen_app/app/shared/utils/parse_errors_utils.dart';

class CatalogoRepository implements ICatalogoRepository {
  @override
  String className() => "Catalogo";

  @override
  String classNameRelation() => "Produto_Catalogo";

  @override
  void validate(CatalogoModel model) {
    if (model.titulo.isNullOrEmpty()) throw Exception("Informe um título para o catálogo.");
    if (model.descricao.isNullOrEmpty()) throw Exception("Informe uma descrição para o catálogo.");
    if (model.foto == null) throw Exception("Selecione uma foto para o catálogo.");
    if (model.produtos?.isEmpty ?? true) throw Exception("Selecione uma foto para o catálogo.");
    if (model.user?.id == null) throw Exception("Houve um erro ao salvar o seu catálogo, tente novamente.\nSe o erro persistir, reinicie o aplicativo.");
  }

  @override
  ParseObject toParseObject(CatalogoModel model) {
    ParseObject parseObject = ParseObject(className())
      ..set<String?>(CATALOGO_ID_COLUMN, model.id)
      ..set<String>(CATALOGO_TITULO_COLUMN, model.titulo!)
      ..set<String>(CATALOGO_DESCRICAO_COLUMN, model.descricao!)
      ..set<ParseUser>(CATALOGO_USER_COLUMN, ParseUser(null, null, null)..set(CATALOGO_ID_COLUMN, model.user!.id!));

    return parseObject;
  }

  @override
  CatalogoModel toModel(ParseObject e) {
    return CatalogoModel(
      e.get<String>(CATALOGO_ID_COLUMN),
      e.get<DateTime>(CATALOGO_DATA_CRIADO_COLUMN),
      e.get<String>(CATALOGO_TITULO_COLUMN),
      e.get<String>(CATALOGO_DESCRICAO_COLUMN),
      e.get<List>(CATALOGO_FOTO_COLUMN)?.first.url,
      null,
      UserRepository(null).toModel(e.get(CATALOGO_USER_COLUMN))
    );
  }

  @override
  Future<CatalogoModel> save(CatalogoModel model) async {
    try {
      validate(model);

      List<ParseFileBase> parseImagem = await _saveImagem(model.foto!);

      ParseObject parseCatalogo = toParseObject(model);
      parseCatalogo..set<List<ParseFileBase>>(CATALOGO_FOTO_COLUMN, parseImagem);

      ParseResponse response = await parseCatalogo.save();

      if (!response.success) throw Exception(ParseErrorsUtils.get(response.statusCode));
      ParseObject parseResponse = (response.results as List<dynamic>).first;

      CatalogoModel catalogoResponse = toModel(parseResponse);
      model.id = catalogoResponse.id;
      model.dataCriado = catalogoResponse.dataCriado;

      await saveProdutosCatalogo(model).catchError((value) {
        throw Exception("FALTA IMPLEMENTAR!!!");
      });

      return model;
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<void> saveProdutosCatalogo(CatalogoModel model) async {
    for (var it in model.produtos!) {
      ParseObject parseObject = ParseObject(classNameRelation())
        ..set<ParseObject>(CATALOGO_PRODUTO_COLUMN, ParseObject(ProdutoRepository().className())..set(CATALOGO_ID_COLUMN, it.id))
        ..set<ParseObject>(CATALOGO_COLUMN, ParseObject(className())..set(CATALOGO_ID_COLUMN, model.id));

      await parseObject.save();
    }
  }

  @override
  Future<List<CatalogoModel>?> getByUser(String? idUser) async {
    try {
      if (idUser == null) throw Exception("Houve um erro ao buscar seus catálogo, tente novamente.\nSe o erro persistir, reinicie o aplicativo.");

      QueryBuilder query = QueryBuilder<ParseObject>(ParseObject(className()))
        ..whereEqualTo(CATALOGO_USER_COLUMN, (ParseUser(null, null, null)
          ..set(CATALOGO_ID_COLUMN, idUser)).toPointer())
        ..includeObject([CATALOGO_USER_COLUMN]);

      ParseResponse response = await query.query();

      if (!response.success) throw Exception(ParseErrorsUtils.get(response.statusCode));
      List<ParseObject>? parseResponse = response.results as List<ParseObject>?;

      List<CatalogoModel> catalogos = parseResponse?.map((e) => toModel(e)).toList() ?? [];

      return catalogos;
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<CatalogoModel> getByIdCatalogo(String? id) async {
    try {
      if (id == null) throw Exception("Houve um erro, tente novamente.\nSe o erro persistir, reinicie o aplicativo.");

      QueryBuilder query = QueryBuilder<ParseObject>(ParseObject(className()))
        ..whereEqualTo(CATALOGO_ID_COLUMN, id)
        ..includeObject([CATALOGO_USER_COLUMN]);

      ParseResponse response = await query.query();

      if (!response.success) throw Exception(ParseErrorsUtils.get(response.statusCode));
      ParseObject? parseResponse = (response.results as List<ParseObject>?)?.first;

      if (parseResponse == null)
        throw Exception("Houve um erro ao buscar o catálogo.");

      CatalogoModel model = toModel(parseResponse);
      model.produtos = await getProdutosCatalogo(model.id);

      return model;
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<List<ProdutoModel>> getProdutosCatalogo(String? idCatalogo) async {
    try {
      if (idCatalogo == null) throw Exception("Houve um erro, tente novamente.\nSe o erro persistir, reinicie o aplicativo.");

      QueryBuilder query = QueryBuilder<ParseObject>(ParseObject(classNameRelation()))
        ..whereEqualTo(CATALOGO_COLUMN, (ParseObject(className())..set(CATALOGO_ID_COLUMN, idCatalogo)).toPointer())
        ..includeObject([CATALOGO_PRODUTO_COLUMN]);

      ParseResponse response = await query.query();

      if (!response.success) throw Exception(ParseErrorsUtils.get(response.statusCode));
      List<ParseObject>? listParse = response.results as List<ParseObject>?;

      List<ProdutoModel> produtos = listParse?.map((e) {
        return ProdutoRepository().toModel(e.get(CATALOGO_PRODUTO_COLUMN));
      }).toList() ?? [];

      if (produtos.isEmpty)
        throw Exception("Houve um erro ao buscar os produtos do catálogo.");

      return produtos;
    } catch(e) {
      throw Exception(e);
    }
  }

  Future<List<ParseFileBase>> _saveImagem(dynamic foto) async {
    final List<ParseFileBase>? parseImagem;

    try {
      if (foto is File) {
        ParseFile parseFile = ParseFile(foto, name: "image1_catalogo");

        ParseResponse response = await parseFile.save();
        if (!response.success) throw Exception(ParseErrorsUtils.get(response.statusCode));

        parseImagem = [parseFile];
      } else {
        final parseFile = ParseFile(null)
          ..name = "image1_catalogo"
          ..url = foto.toString();

        parseImagem = [parseFile];
      }

      return parseImagem;
    } catch (e) {
      throw Exception(e);
    }
  }
}
