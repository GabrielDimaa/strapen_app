import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:strapen_app/app/app_widget.dart';
import 'package:strapen_app/app/modules/produto/components/produto_widget.dart';
import 'package:strapen_app/app/modules/produto/controllers/produto_info_controller.dart';
import 'package:strapen_app/app/modules/produto/factories/produto_factory.dart';
import 'package:strapen_app/app/modules/produto/models/produto_model.dart';
import 'package:strapen_app/app/modules/reserva/models/reserva_model.dart';

class ProdutoInfoPage extends StatefulWidget {
  final ProdutoModel produtoModel;
  final ReservaModel? reservaModel;

  const ProdutoInfoPage({required this.produtoModel, this.reservaModel});

  @override
  _ProdutoInfoPageState createState() => _ProdutoInfoPageState();
}

class _ProdutoInfoPageState extends ModularState<ProdutoInfoPage, ProdutoInfoController> {
  @override
  void initState() {
    super.initState();
    if (widget.reservaModel != null)
      controller.setReservaModel(widget.reservaModel);

    controller.setProdutoStore(ProdutoFactory.fromModel(widget.produtoModel));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background.withOpacity(0.6),
      body: Observer(
        builder: (_) => ProdutoWidget(
          editavel: controller.editavel,
          produtoStore: controller.produtoStore!,
          reservaModel: controller.reservaModel,
          onPressedEditar: () async => await controller.editarCatalogo(),
        ),
      ),
    );
  }
}
