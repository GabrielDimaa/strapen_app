import 'package:mobx/mobx.dart';

part 'cpf_cnpj_controller.g.dart';

class CpfCnpjController = _CpfCnpjController with _$CpfCnpjController;

abstract class _CpfCnpjController with Store {
  @observable
  bool isCpf = true;

  @action
  void setIsCpf(bool value) => isCpf = value;
}