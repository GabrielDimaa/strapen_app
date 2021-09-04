import 'package:mobx/mobx.dart';
import 'package:strapen_app/app/modules/produto/models/produto_model.dart';
import 'package:strapen_app/app/modules/user/models/user_model.dart';

part 'produto_store.g.dart';

class ProdutoStore = _ProdutoStore with _$ProdutoStore;

abstract class _ProdutoStore with Store {
  @observable
  String? id;

  @observable
  String? descricao;

  @observable
  String? descricaoDetalhada;

  @observable
  ObservableList<dynamic> fotos = ObservableList<dynamic>();

  @observable
  int? quantidade = 1;

  @observable
  double? preco;

  @observable
  UserModel? anunciante;

  @action
  void setId(String? value) => id = value;

  @action
  void setDescricao(String? value) => descricao = value;

  @action
  void setDescricaoDetalhada(String? value) => descricaoDetalhada = value;

  @action
  void setAllFotos(ObservableList<dynamic> value) => fotos = value;

  @action
  void setFoto(dynamic value) => fotos.add(value);

  @action
  void setQuantidade(int? value) => quantidade = value;

  @action
  void setValor(double? value) => preco = value;

  @action
  void setAnunciante(UserModel? value) => anunciante = value;

  _ProdutoStore(
    this.id,
    this.descricao,
    this.descricaoDetalhada,
    this.fotos,
    this.quantidade,
    this.preco,
    this.anunciante,
  );

  ProdutoModel toModel() {
    return ProdutoModel(
      this.id,
      this.descricao,
      this.descricaoDetalhada,
      this.fotos,
      this.quantidade,
      this.preco,
      this.anunciante,
    );
  }
}
