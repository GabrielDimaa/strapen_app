import 'dart:typed_data';

import 'package:mobx/mobx.dart';
import 'package:strapen_app/app/modules/produto/models/produto_model.dart';
import 'package:strapen_app/app/modules/user/models/user_model.dart';

part 'produto_store.g.dart';

class ProdutoStore = _ProdutoStore with _$ProdutoStore;

abstract class _ProdutoStore with Store {
  @observable
  int? id;

  @observable
  String? descricao;

  @observable
  String? descricaoDetalhada;

  @observable
  ObservableList<Uint8List> fotos = ObservableList<Uint8List>();

  @observable
  int? quantidade;

  @observable
  double? valor;

  @observable
  UserModel? anunciante;

  @observable
  UserModel? userReserva;

  @action
  void setId(int? value) => id = value;

  @action
  void setDescricao(String? value) => descricao = value;

  @action
  void setDescricaoDetalhada(String? value) => descricaoDetalhada = value;

  @action
  void setAllFotos(ObservableList<Uint8List> value) => fotos = value;

  @action
  void setFoto(Uint8List value) => fotos.add(value);

  @action
  void setQuantidade(int? value) => quantidade = value;

  @action
  void setValor(double? value) => valor = value;

  @action
  void setAnunciante(UserModel? value) => anunciante = value;

  @action
  void setUserReserva(UserModel? value) => userReserva = value;

  _ProdutoStore(
    this.id,
    this.descricao,
    this.descricaoDetalhada,
    this.fotos,
    this.quantidade,
    this.valor,
    this.anunciante,
    this.userReserva,
  );

  ProdutoModel toModel() {
    return ProdutoModel(
      this.id,
      this.descricao,
      this.descricaoDetalhada,
      this.fotos,
      this.quantidade,
      this.valor,
      this.anunciante,
      this.userReserva,
    );
  }
}
