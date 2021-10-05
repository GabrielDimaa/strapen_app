enum EnumStatusReserva {
  Cancelado,
  EmAberto,
  Finalizado
}

class EnumStatusReservaHelper {
  static const Map<EnumStatusReserva, int> _values = {
    EnumStatusReserva.Cancelado: 0,
    EnumStatusReserva.EmAberto: 1,
    EnumStatusReserva.Finalizado: 2,
  };

  static const Map<EnumStatusReserva, String> _descriptions = {
    EnumStatusReserva.Cancelado: "Cancelado",
    EnumStatusReserva.EmAberto: "Em aberto",
    EnumStatusReserva.Finalizado: "Finalizado",
  };

  static String description(EnumStatusReserva status) => _descriptions[status]!;

  static int getValue(EnumStatusReserva status) => _values[status]!;

  static EnumStatusReserva get(int value) => _values.keys.firstWhere((status) => getValue(status) == value);
}