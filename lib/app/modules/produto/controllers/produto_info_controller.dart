import 'package:flutter/cupertino.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:strapen_app/app/app_controller.dart';
import 'package:strapen_app/app/modules/produto/constants/routes.dart';
import 'package:strapen_app/app/modules/produto/factories/produto_factory.dart';
import 'package:strapen_app/app/modules/produto/models/produto_model.dart';
import 'package:strapen_app/app/modules/produto/stores/produto_store.dart';
import 'package:strapen_app/app/modules/reserva/enums/enum_status_reserva.dart';
import 'package:strapen_app/app/modules/reserva/models/reserva_model.dart';
import 'package:strapen_app/app/modules/reserva/repositories/ireserva_repository.dart';
import 'package:strapen_app/app/modules/user/constants/routes.dart';
import 'package:strapen_app/app/shared/components/dialog/loading_dialog.dart';

part 'produto_info_controller.g.dart';

class ProdutoInfoController = _ProdutoInfoController with _$ProdutoInfoController;

abstract class _ProdutoInfoController with Store {
  final IReservaRepository _reservaRepository;
  final AppController _appController;

  _ProdutoInfoController(this._reservaRepository, this._appController);

  @observable
  ProdutoStore? produtoStore;

  @observable
  ReservaModel? reservaModel;

  @observable
  VoidCallback? reservarFunction;

  @observable
  VoidCallback? verAnuncianteNaLiveFunction;

  @observable
  VoidCallback? verClienteNaLiveFunction;

  @observable
  bool hasLive = false;

  @observable
  bool reservado = false;

  @computed
  bool get editavel => _appController.userModel!.id == (produtoStore?.anunciante?.id ?? false) && reservaModel == null && !hasLive;

  @computed
  bool get anuncianteVisible => verAnuncianteNaLiveFunction != null || (reservaModel != null && reservaModel?.anunciante?.id != _appController.userModel!.id);

  @computed
  bool get clienteVisible => verClienteNaLiveFunction != null || (reservaModel != null && reservaModel?.user?.id != _appController.userModel!.id);

  @computed
  bool get statusVisible => reservarFunction == null && reservaModel != null && !hasLive;

  @computed
  bool get comprarEnabled => reservarFunction != null && reservaModel == null && hasLive;

  @computed
  bool get finalizarVisible => reservaModel?.status == EnumStatusReserva.EmAberto && _appController.userModel!.id == reservaModel?.anunciante?.id && !hasLive;

  @computed
  bool get cancelarVisible => reservaModel?.status == EnumStatusReserva.EmAberto && !hasLive;

  @computed
  String get textQtd {
    if (produtoStore != null)
      return "${produtoStore!.quantidade} ${produtoStore!.quantidade! > 1 ? "unidades" : "unidade"} ${!editavel ? "${produtoStore!.quantidade! > 1 ? "restantes" : "restante"}" : ""}";

    return "";
  }

  @action
  void setProdutoStore(ProdutoStore? value) => produtoStore = value;

  @action
  void setReservaModel(ReservaModel? value) => reservaModel = value;

  @action
  void setReservarFunction(VoidCallback? value) => reservarFunction = value;

  @action
  void setVerAnuncianteNaLiveFunction(VoidCallback? value) => verAnuncianteNaLiveFunction = value;

  @action
  void setVerClienteNaLiveFunction(VoidCallback? value) => verClienteNaLiveFunction = value;

  @action
  void setHasLive(bool value) => hasLive = value;

  @action
  void setReservado(bool value) => reservado = value;

  @action
  Future<void> editarProduto() async {
    ProdutoModel? produto = await Modular.to.pushNamed(PRODUTO_ROUTE + PRODUTO_CREATE_ROUTE, arguments: produtoStore!.toModel());
    if (produto != null) {
      if (produto.id == null)
        Modular.to.pop(produto);
      else
        setProdutoStore(ProdutoFactory.fromModel(produto));
    }
  }

  @action
  Future<void> alterarStatus(BuildContext context, EnumStatusReserva status) async {
    try {
      await LoadingDialog.show(context, "Alterando status do produto...", () async {
        ReservaModel reservaClone = reservaModel!.clone()..status = status;

        bool success = await _reservaRepository.alterarStatus(reservaClone);
        if (!success) throw Exception("Não foi possível alterar o status!");

        setReservaModel(reservaClone);
      });
    } catch (e) {
      rethrow;
    }
  }

  @action
  Future<void> reservar() async {
    reservarFunction?.call();
  }

  @action
  Future<void> verAnunciante() async {
    //Verificação para caso seja dentro da Live, abrir em um BottomSheet
    if (verAnuncianteNaLiveFunction != null) {
      verAnuncianteNaLiveFunction!.call();
    } else {
      await Modular.to.pushNamed(USER_ROUTE, arguments: reservaModel!.anunciante);
    }
  }

  @action
  Future<void> verCliente() async {
    //Verificação para caso seja dentro da Live, abrir em um BottomSheet
    if (verClienteNaLiveFunction != null) {
      verClienteNaLiveFunction!.call();
    } else {
      await Modular.to.pushNamed(USER_ROUTE, arguments: reservaModel!.user);
    }
  }
}