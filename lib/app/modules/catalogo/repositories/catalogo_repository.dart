import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:strapen_app/app/modules/catalogo/constants/columns.dart';
import 'package:strapen_app/app/modules/catalogo/models/catalogo_model.dart';
import 'package:strapen_app/app/modules/catalogo/repositories/icatalogo_repository.dart';
import 'package:strapen_app/app/modules/produto/constants/columns.dart';
import 'package:strapen_app/app/modules/produto/models/produto_model.dart';
import 'package:strapen_app/app/modules/produto/repositories/produto_repository.dart';
import 'package:strapen_app/app/modules/user/repositories/user_repository.dart';
import 'package:strapen_app/app/shared/extensions/string_extension.dart';
import 'package:strapen_app/app/shared/utils/connectivity_utils.dart';
import 'package:strapen_app/app/shared/utils/parse_errors_utils.dart';
import 'package:strapen_app/app/shared/utils/parse_images_utils.dart';

class CatalogoRepository implements ICatalogoRepository {
  @override
  String className() => "Catalogo";

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
    return ParseObject(className())
      ..set<String?>(CATALOGO_ID_COLUMN, model.id)
      ..set<String>(CATALOGO_TITULO_COLUMN, model.titulo!)
      ..set<String>(CATALOGO_DESCRICAO_COLUMN, model.descricao!)
      ..set<ParseUser>(CATALOGO_USER_COLUMN, ParseUser(null, null, null)..set(CATALOGO_ID_COLUMN, model.user!.id!));
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
      UserRepository(null).toModel(e.get(CATALOGO_USER_COLUMN)),
    );
  }

  ///Contém os produtos antes de atualizar, dessa forma se tiver mudança nos produtos do catálogo
  ///deverá ser removido os produtos que não contiver na nova lista.
  @override
  Future<CatalogoModel> save(CatalogoModel model, List<ProdutoModel>? produtos) async {
    try {
      await ConnectivityUtils.hasInternet();
      validate(model);

      //Verifica se existe produtos removidos da nova lista do catálogo
      if (produtos != null && model.id != null)
        await _removeRelation(produtos, model);

      List<ParseFileBase> parseImagem = await ParseImageUtils.save([model.foto]);

      ParseObject parseCatalogo = toParseObject(model);
      parseCatalogo..set<List<ParseFileBase>>(CATALOGO_FOTO_COLUMN, parseImagem);
      parseCatalogo.addRelation(CATALOGO_PRODUTO_COLUMN, model.produtos!.map((e) {
        return ParseObject(ProdutoRepository().className())..objectId = e.id;
      }).toList());

      ParseResponse response = await parseCatalogo.save();

      if (!response.success) throw Exception(ParseErrorsUtils.get(response.statusCode));
      ParseObject? parseResponse = (response.results)?.first;

      if (parseResponse == null) throw Exception("Houve um erro ao salvar seu catálogo!");

      CatalogoModel catalogoResponse = toModel(parseResponse);
      model.id = catalogoResponse.id;
      model.dataCriado = catalogoResponse.dataCriado;
      model.foto = catalogoResponse.foto;

      return model;
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<bool> delete(CatalogoModel model) async {
    try {
      await ConnectivityUtils.hasInternet();

      if (model.id == null) throw Exception("Houve um erro ao remover seu catálogo!");

      final ParseObject parseCatalogo = ParseObject(className());
      ParseResponse response = await parseCatalogo.delete(id: model.id!);

      return response.success;
    } catch(e) {
      throw Exception(e);
    }
  }

  @override
  Future<List<CatalogoModel>?> getByUser(String? idUser) async {
    try {
      await ConnectivityUtils.hasInternet();

      if (idUser == null) throw Exception("Houve um erro ao buscar seus catálogo, tente novamente.\nSe o erro persistir, reinicie o aplicativo.");

      QueryBuilder query = QueryBuilder<ParseObject>(ParseObject(className()))
        ..whereEqualTo(CATALOGO_USER_COLUMN, (ParseUser(null, null, null)
          ..set(CATALOGO_ID_COLUMN, idUser)).toPointer())
        ..orderByDescending(CATALOGO_DATA_CRIADO_COLUMN)
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
  Future<CatalogoModel> getById(String? id) async {
    try {
      await ConnectivityUtils.hasInternet();

      if (id == null) throw Exception("Houve um erro, tente novamente.\nSe o erro persistir, reinicie o aplicativo.");

      QueryBuilder query = QueryBuilder<ParseObject>(ParseObject(className()))
        ..whereEqualTo(CATALOGO_ID_COLUMN, id)
        ..orderByDescending(CATALOGO_DATA_CRIADO_COLUMN)
        ..includeObject([CATALOGO_USER_COLUMN]);

      ParseResponse response = await query.query();

      if (!response.success) throw Exception(ParseErrorsUtils.get(response.statusCode));
      ParseObject? parseResponse = (response.results)?.first;

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
      await ConnectivityUtils.hasInternet();

      if (idCatalogo == null) throw Exception("Houve um erro, tente novamente.\nSe o erro persistir, reinicie o aplicativo.");

      QueryBuilder query = QueryBuilder<ParseObject>(ParseObject(ProdutoRepository().className()))
        ..whereRelatedTo(CATALOGO_PRODUTO_COLUMN, className(), idCatalogo)
        ..orderByDescending(PRODUTO_DATA_CRIADO_COLUMN);

      ParseResponse response = await query.query();

      if (!response.success) throw Exception(ParseErrorsUtils.get(response.statusCode));
      List<ParseObject>? parseResponse = response.results as List<ParseObject>?;

      if (parseResponse == null)
        throw Exception("Houve um erro ao buscar os produtos.");

      List<ProdutoModel> produtos = parseResponse.map((e) => ProdutoRepository().toModel(e)).toList();

      return produtos;
    } catch(e) {
      throw Exception(e);
    }
  }

  Future<void> _removeRelation(List<ProdutoModel> produtos, CatalogoModel catalogo) async {
    try {
      List<ProdutoModel> produtosParaRemover = [];
      produtos.forEach((e) {
        if (!catalogo.produtos!.any((prod) => prod.id == e.id))
          produtosParaRemover.add(e);
      });

      if (produtosParaRemover.isEmpty) return;

      final ParseObject parse = ParseObject(className())..set(CATALOGO_ID_COLUMN, catalogo.id);

      parse.removeRelation(
        CATALOGO_PRODUTO_COLUMN,
        produtosParaRemover.map((e) {
          return ParseObject(ProdutoRepository().className())..objectId = e.id;
        }).toList());

      await parse.update();
    } catch (e) {
      throw Exception(e);
    }
  }
}
