import 'dart:io';

import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:strapen_app/app/modules/catalogo/constants/columns.dart';
import 'package:strapen_app/app/modules/catalogo/models/catalogo_model.dart';
import 'package:strapen_app/app/modules/catalogo/repositories/icatalogo_repository.dart';
import 'package:strapen_app/app/modules/produto/repositories/produto_repository.dart';
import 'package:strapen_app/app/modules/user/factories/user_factory.dart';
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
      ..set<String?>(ID_COLUMN, model.id)
      ..set<String>(TITULO_COLUMN, model.titulo!)
      ..set<String>(DESCRICAO_COLUMN, model.descricao!)
      ..set<ParseUser>(
        USER_COLUMN,
        ParseUser(null, null, null)..set(ID_COLUMN, model.user!.id!),
      );

    return parseObject;
  }

  @override
  CatalogoModel toModel(ParseObject e) {
    return CatalogoModel(
      e.get<String>(ID_COLUMN),
      e.get<DateTime>(DATA_CRIADO_COLUMN),
      e.get<String>(TITULO_COLUMN),
      e.get<String>(DESCRICAO_COLUMN),
      e.get<List>(FOTO_COLUMN)?.first.url,
      null,
      UserFactory.newModel()..id = e.get(USER_COLUMN).get<String>(ID_COLUMN),
    );
  }

  @override
  Future<CatalogoModel> save(CatalogoModel model) async {
    try {
      validate(model);

      List<ParseFileBase> parseImagem = await _saveImagem(model.foto!);

      ParseObject parseCatalogo = toParseObject(model);
      parseCatalogo..set<List<ParseFileBase>>(FOTO_COLUMN, parseImagem);

      ParseResponse response = await parseCatalogo.save();

      if (!response.success) throw Exception(ParseErrorsUtils.get(response.statusCode));
      ParseObject parseResponse = (response.results as List<dynamic>).first;

      CatalogoModel catalogoResponse = toModel(parseResponse);
      model.id = catalogoResponse.id;
      model.dataCriado = catalogoResponse.dataCriado;

      await saveProdutosCatalogo(model).catchError((value) {
        print("FALTA REMOVER O CATÀLOGO!!!");
      });

      return model;
    } catch(e) {
      throw Exception(e);
    }
  }

  @override
  Future<void> saveProdutosCatalogo(CatalogoModel model) async {
    for (var it in model.produtos!) {
      ParseObject parseObject = ParseObject(classNameRelation())
        ..set<ParseObject>(PRODUTO_COLUMN, ParseObject(ProdutoRepository().className())..set(ID_COLUMN, it.id))
        ..set<ParseObject>(CATALOGO_COLUMN, ParseObject(className())..set(ID_COLUMN, model.id));

      await parseObject.save();
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
