import 'package:mobx/mobx.dart';
import 'package:strapen_app/app/modules/catalogo/models/catalogo_model.dart';
import 'package:strapen_app/app/modules/produto/stores/produto_store.dart';
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
  ObservableList<ProdutoStore>? produtos;

  @observable
  bool selected = false;

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
  void setProdutos(ObservableList<ProdutoStore>? value) => produtos = value;

  @action
  void setSelected(bool value) => selected = value;

  _CatalogoStore(
    this.id,
    this.titulo,
    this.descricao,
    this.foto,
    this.dataCriado,
    this.user,
    this.produtos,
  );

  CatalogoModel toModel() {
    return CatalogoModel(
      this.id,
      this.dataCriado,
      this.titulo,
      this.descricao,
      this.foto,
      this.produtos?.map((e) => e.toModel()).toList(),
      this.user,
    );
  }
}
