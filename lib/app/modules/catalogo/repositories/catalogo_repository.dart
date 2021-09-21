import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:strapen_app/app/modules/catalogo/constants/columns.dart';
import 'package:strapen_app/app/modules/catalogo/models/catalogo_model.dart';
import 'package:strapen_app/app/modules/catalogo/repositories/icatalogo_repository.dart';
import 'package:strapen_app/app/modules/produto/models/produto_model.dart';
import 'package:strapen_app/app/modules/produto/repositories/produto_repository.dart';
import 'package:strapen_app/app/modules/user/repositories/user_repository.dart';
import 'package:strapen_app/app/shared/extensions/string_extension.dart';
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

      List<ParseFileBase> parseImagem = await ParseImageUtils.save([model.foto]);

      ParseObject parseCatalogo = toParseObject(model);
      parseCatalogo..set<List<ParseFileBase>>(CATALOGO_FOTO_COLUMN, parseImagem);
      parseCatalogo.addRelation(CATALOGO_PRODUTO_COLUMN, model.produtos!.map((e) {
        return ParseObject(ProdutoRepository().className())..objectId = e.id;
      }).toList());

      ParseResponse response = await parseCatalogo.save();

      if (!response.success) throw Exception(ParseErrorsUtils.get(response.statusCode));
      ParseObject parseResponse = (response.results as List<dynamic>).first;

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

      QueryBuilder query = QueryBuilder<ParseObject>(ParseObject(ProdutoRepository().className()))
        ..whereRelatedTo(CATALOGO_PRODUTO_COLUMN, className(), idCatalogo);

      ParseResponse response = await query.query();

      if (!response.success) throw Exception(ParseErrorsUtils.get(response.statusCode));
      List<ParseObject>? parseResponse = response.results as List<ParseObject>?;

      if (parseResponse == null)
        throw Exception("Houve um erro ao buscar o catálogo.");

      List<ProdutoModel> produtos = parseResponse.map((e) => ProdutoRepository().toModel(e)).toList();

      return produtos;
    } catch(e) {
      throw Exception(e);
    }
  }
}
