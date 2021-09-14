import 'package:parse_server_sdk/parse_server_sdk.dart';
import 'package:strapen_app/app/modules/produto/constants/columns.dart';
import 'package:strapen_app/app/modules/produto/models/produto_model.dart';
import 'package:strapen_app/app/modules/produto/repositories/iproduto_repository.dart';
import 'package:strapen_app/app/modules/user/factories/user_factory.dart';
import 'package:strapen_app/app/shared/extensions/string_extension.dart';
import 'package:strapen_app/app/shared/utils/parse_errors_utils.dart';
import 'package:strapen_app/app/shared/utils/parse_images_utils.dart';

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
    ParseObject parseObject = ParseObject(className())
      ..set<String?>(PRODUTO_ID_COLUMN, model.id)
      ..set<String>(PRODUTO_DESCRICAO_COLUMN, model.descricao!)
      ..set<String>(PRODUTO_DESCRICAO_DETALHADA_COLUMN, model.descricaoDetalhada!)
      ..set<int>(PRODUTO_QUANTIDADE_COLUMN, model.quantidade!)
      ..set<double>(PRODUTO_PRECO_COLUMN, model.preco!)
      ..set<ParseUser>(
        PRODUTO_ANUNCIANTE_COLUMN,
        ParseUser(null, null, null)..set(PRODUTO_ID_COLUMN, model.anunciante!.id!),
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
      UserFactory.newModel()..id = e.get(PRODUTO_ANUNCIANTE_COLUMN).get<String>(PRODUTO_ID_COLUMN),
    );
  }

  @override
  Future<ProdutoModel?> save(ProdutoModel model) async {
    try {
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

  Future<List<ProdutoModel>?> getByUser(String? id) async {
    try {
      if (id == null) throw Exception("Houve um erro ao buscar seus produtos, tente novamente.\nSe o erro persistir, reinicie o aplicativo.");

      QueryBuilder query = QueryBuilder<ParseObject>(ParseObject(className()))
        ..whereEqualTo(
          PRODUTO_ANUNCIANTE_COLUMN,
          (ParseUser(null, null, null)..set(PRODUTO_ID_COLUMN, id)).toPointer(),
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
}
