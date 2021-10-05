import 'package:flutter/material.dart';
import 'package:strapen_app/app/app_widget.dart';
import 'package:strapen_app/app/modules/reserva/enums/enum_status_reserva.dart';

class StatusReservaWidget extends StatelessWidget {
  final EnumStatusReserva status;

  const StatusReservaWidget({required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      decoration: BoxDecoration(
        color: _getBackground(status),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _getForeground(status)),
      ),
      child: Text(
        EnumStatusReservaHelper.description(status),
        style: TextStyle(
          color: _getForeground(status),
          fontSize: 14,
        ),
      ),
    );
  }

  Color _getBackground(EnumStatusReserva status) {
    switch (status) {
      case EnumStatusReserva.Cancelado:
        return AppColors.error.withOpacity(0.4);
      case EnumStatusReserva.EmAberto:
        return Color(0xFFFFE900).withOpacity(0.4);
      case EnumStatusReserva.Finalizado:
        return AppColors.primaryOpaci;
    }
  }

  Color _getForeground(EnumStatusReserva status) {
    switch (status) {
      case EnumStatusReserva.Cancelado:
        return AppColors.error;
      case EnumStatusReserva.EmAberto:
        return Color(0xFFFFE900);
      case EnumStatusReserva.Finalizado:
        return AppColors.primary;
    }
  }
}
