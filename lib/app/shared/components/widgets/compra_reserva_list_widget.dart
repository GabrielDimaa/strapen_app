import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:strapen_app/app/modules/produto/constants/routes.dart';
import 'package:strapen_app/app/modules/produto/factories/produto_factory.dart';
import 'package:strapen_app/app/modules/reserva/constants/routes.dart';
import 'package:strapen_app/app/modules/reserva/models/reserva_model.dart';
import 'package:strapen_app/app/shared/components/sized_box/vertical_sized_box.dart';
import 'package:strapen_app/app/shared/components/widgets/produto_grid_tile.dart';

import 'empty_list_horizontal_widget.dart';

class CompraReservaListWidget extends StatefulWidget {
  final List<ReservaModel> list;
  final bool reserva;

  const CompraReservaListWidget({required this.list, required this.reserva});

  @override
  _CompraReservaListWidgetState createState() => _CompraReservaListWidgetState();
}

class _CompraReservaListWidgetState extends State<CompraReservaListWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _headerList(
          context: context,
          title: widget.reserva ? "Reservas" : "Compras",
          onPressed: () async {
            if (widget.reserva) {
              await Modular.to.pushNamed(RESERVA_ROUTE, arguments: widget.reserva);
            } else {
              await Modular.to.pushNamed(RESERVA_ROUTE, arguments: widget.reserva);
            }
          },
        ),
        const VerticalSizedBox(0.5),
        if (widget.reserva)
          Visibility(
            visible: widget.list.isNotEmpty,
            child: _list(list: widget.list),
            replacement: EmptyListHorizontalWidget(
              pathImage: "assets/images/empty_reserva.svg",
              message: "Nenhuma reserva realizada.\nCrie uma Live para os usuários reservarem seus produtos!",
            ),
          ),
        if (!widget.reserva)
          Visibility(
            visible: widget.list.isNotEmpty,
            child: _list(list: widget.list),
            replacement: EmptyListHorizontalWidget(
              pathImage: "assets/images/empty_compra.svg",
              message: "Nenhuma compra realizada.\nAssista alguma Live para comprar produtos!",
            ),
          ),
      ],
    );
  }

  Widget _headerList({required BuildContext context, required String title, required VoidCallback onPressed}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.headline1!.copyWith(fontWeight: FontWeight.w600),
        ),
        TextButton(
          onPressed: onPressed,
          child: Row(
            children: [
              const Text("Ver todos"),
              Icon(Icons.keyboard_arrow_right),
            ],
          ),
        ),
      ],
    );
  }

  Widget _list({required List<ReservaModel> list}) {
    return SizedBox(
      height: 250,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: list.length,
        itemBuilder: (_, i) {
          final ReservaModel res = list[i];
          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: ProdutoGridTile(
              image: res.fotos!.first,
              descricao: res.descricao!,
              data: res.dataHoraReserva,
              preco: res.preco! * res.quantidade!,
              status: res.status,
              onTap: () async {
                final ReservaModel? reserva = await Modular.to.pushNamed(PRODUTO_ROUTE + PRODUTO_INFO_ROUTE, arguments: {
                  'produtoModel': ProdutoFactory.fromReservaModel(res),
                  'reservaModel': res,
                });
                if (reserva != null) {
                  setState(() => res.status = reserva.status);
                }
              },
            ),
          );
        },
      ),
    );
  }
}
