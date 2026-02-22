import 'package:hive_ce/hive.dart';

import 'hive_enums.dart';

@HiveType(typeId: 12)
class CheckoutRascunhoHive {
  @HiveField(0)
  final String usuarioId;
  @HiveField(1)
  final String enderecoId;
  @HiveField(2)
  final MetodoPagamentoHive metodoPagamento;
  @HiveField(3)
  final int subtotalCents;
  @HiveField(4)
  final int freteCents;
  @HiveField(5)
  final int descontoCents;
  @HiveField(6)
  final int totalCents;
  @HiveField(7)
  final DateTime? janelaEntregaInicio;
  @HiveField(8)
  final DateTime? janelaEntregaFim;
  @HiveField(9)
  final DateTime atualizadoEm;

  const CheckoutRascunhoHive({
    required this.usuarioId,
    required this.enderecoId,
    required this.metodoPagamento,
    required this.subtotalCents,
    required this.freteCents,
    required this.descontoCents,
    required this.totalCents,
    required this.janelaEntregaInicio,
    required this.janelaEntregaFim,
    required this.atualizadoEm,
  });
}
