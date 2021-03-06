import 'package:flutter_modular/flutter_modular.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:strapen_app/app/modules/live/controllers/live_controller.dart';
import 'package:strapen_app/app/modules/produto/constants/columns.dart';
import 'package:mobx/mobx.dart';
import 'package:strapen_app/app/modules/produto/models/produto_model.dart';
import 'package:strapen_app/app/modules/produto/repositories/iproduto_repository.dart';
import 'package:strapen_app/app/modules/produto/stores/produto_store.dart';
import 'package:strapen_app/app/modules/user/constants/columns.dart';
import 'package:strapen_app/app/modules/user/factories/user_factory.dart';
import 'package:strapen_app/app/shared/extensions/string_extension.dart';
import 'package:strapen_app/app/shared/utils/connectivity_utils.dart';
import 'package:strapen_app/app/shared/utils/parse_errors_utils.dart';
import 'package:strapen_app/app/shared/utils/parse_images_utils.dart';

class ProdutoRepository implements IProdutoRepository {
  @override
  String className() => "Produto";

  LiveQuery? liveQuery;
  Subscription? subscription;

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
    ParseObject parseObject = ParseObject(className())
      ..set<String?>(PRODUTO_ID_COLUMN, model.id)
      ..set<String>(PRODUTO_DESCRICAO_COLUMN, model.descricao!)
      ..set<String>(PRODUTO_DESCRICAO_DETALHADA_COLUMN, model.descricaoDetalhada!)
      ..set<int>(PRODUTO_QUANTIDADE_COLUMN, model.quantidade!)
      ..set<double>(PRODUTO_PRECO_COLUMN, model.preco!)
      ..set<ParseUser>(
        PRODUTO_ANUNCIANTE_COLUMN,
        ParseUser(null, null, null)..set(USER_ID_COLUMN, model.anunciante!.id!),
      );

    return parseObject;
  }

  @override
  ProdutoModel toModel(ParseObject e) {
    return ProdutoModel(
      e.get<String>(PRODUTO_ID_COLUMN),
      e.get<String>(PRODUTO_DESCRICAO_COLUMN),
      e.get<String>(PRODUTO_DESCRICAO_DETALHADA_COLUMN),
      e.get<List>(PRODUTO_FOTOS_COLUMN)?.map((e) => e.url).toList(),
      e.get<int>(PRODUTO_QUANTIDADE_COLUMN),
      e.get(PRODUTO_PRECO_COLUMN) is int ? e.get<int>(PRODUTO_PRECO_COLUMN)?.toDouble() ?? null : e.get<double>(PRODUTO_PRECO_COLUMN),
      UserFactory.newModel()..id = e.get(PRODUTO_ANUNCIANTE_COLUMN).get<String>(USER_ID_COLUMN),
    );
  }

  @override
  Future<ProdutoModel?> save(ProdutoModel model) async {
    try {
      await ConnectivityUtils.hasInternet();
      validate(model);

      List<ParseFileBase> parseImages = await ParseImageUtils.save(model.fotos!);

      ParseObject parseProduto = toParseObject(model)..set<List<ParseFileBase>>(PRODUTO_FOTOS_COLUMN, parseImages);

      ParseResponse response = await parseProduto.save();

      if (!response.success) throw Exception(ParseErrorsUtils.get(response.statusCode));
      ParseObject parseResponse = (response.results as List<dynamic>).first;

      return toModel(parseResponse);
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<bool> delete(ProdutoModel model) async {
    try {
      await ConnectivityUtils.hasInternet();

      if (model.id == null) throw Exception("Houve um erro ao remover seu produto!");

      final ParseObject parseCatalogo = ParseObject(className());
      ParseResponse response = await parseCatalogo.delete(id: model.id!);

      return response.success;
    } catch(e) {
      throw Exception(e);
    }
  }

  Future<List<ProdutoModel>?> getByUser(String? id) async {
    try {
      await ConnectivityUtils.hasInternet();

      if (id == null) throw Exception("Houve um erro ao buscar seus produtos, tente novamente.\nSe o erro persistir, reinicie o aplicativo.");

      QueryBuilder query = QueryBuilder<ParseObject>(ParseObject(className()))
        ..whereEqualTo(
          PRODUTO_ANUNCIANTE_COLUMN,
          (ParseUser(null, null, null)..set(USER_ID_COLUMN, id)).toPointer())
        ..orderByDescending(PRODUTO_DATA_CRIADO_COLUMN);

      ParseResponse response = await query.query();

      if (!response.success) throw Exception(ParseErrorsUtils.get(response.statusCode));
      List<ParseObject>? parseResponse = response.results as List<ParseObject>?;

      List<ProdutoModel> produtos = parseResponse?.map((e) => toModel(e)).toList() ?? [];

      return produtos;
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<void> startListener() async {
    try {
      await ConnectivityUtils.hasInternet();

      final LiveController controller = Modular.get<LiveController>();

      if (liveQuery == null) liveQuery = LiveQuery();

      if (subscription == null) {
        final QueryBuilder<ParseObject> query = QueryBuilder<ParseObject>.or(
          ParseObject(className()),
          controller.produtos.map<QueryBuilder<ParseObject>>((prod) {
            return QueryBuilder<ParseObject>(ParseObject(className()))..whereEqualTo(PRODUTO_ID_COLUMN, prod.id);
          }).toList(),
        );

        subscription = await liveQuery!.client.subscribe(query);

        subscription!.on(LiveQueryEvent.update, (value) {
          final ProdutoModel prod = toModel(value);

          //É uma lista pois pode conter o mesmo produto em mais de um catálogo, contudo estará repetido
          final List<ProdutoStore> list = controller.produtos.where((e) => e.id == prod.id).toList();

          //Valores serão atualizados pela instância do objeto
          list.forEach((e) {
            e.descricao = prod.descricao;
            e.descricaoDetalhada = prod.descricaoDetalhada;
            e.quantidade = prod.quantidade;
            e.preco = prod.preco;
            e.fotos = prod.fotos!.asObservable();
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
