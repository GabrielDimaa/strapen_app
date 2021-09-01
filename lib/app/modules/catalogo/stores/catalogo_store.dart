import 'package:mobx/mobx.dart';
import 'package:strapen_app/app/modules/produto/models/produto_model.dart';
import 'package:strapen_app/app/modules/user/models/user_model.dart';

part 'catalogo_store.g.dart';

class CatalogoStore = _CatalogoStore with _$CatalogoStore;

abstract class _CatalogoStore with Store {
  String? id;

  @observable
  String? titulo;

  @observable
  String? descricao;

  @observable
  dynamic foto;

  @observable
  DateTime? dataCriado;

  @observable
  UserModel? user;

  @observable
  ObservableList<ProdutoModel>? produtos;

  @action
  void setTitulo(String? value) => titulo = value;

  @action
  void setDescricao(String? value) => descricao = value;

  @action
  void setFoto(dynamic value) => foto = value;

  @action
  void setDataCriado(DateTime? value) => dataCriado = value;

  @action
  void setUser(UserModel? value) => user = value;

  @action
  void setProdutos(ObservableList<ProdutoModel>? value) => produtos = value;

  _CatalogoStore(
    this.id,
    this.titulo,
    this.descricao,
    this.foto,
    this.dataCriado,
    this.user,
    this.produtos,
  );
}
