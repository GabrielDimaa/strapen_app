import 'package:mobx/mobx.dart';
import 'package:strapen_app/app/modules/produto/stores/produto_store.dart';

abstract class ProdutoFactory {
  static ProdutoStore novo() {
    return ProdutoStore(
      null,
      null,
      null,
      ObservableList(),
      null,
      null,
      null,
      null,
    );
  }
}