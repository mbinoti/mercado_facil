import 'package:hive_ce/hive.dart';

@HiveType(typeId: 14)
class ResumoPedidoHive {
  @HiveField(0)
  final int itensQuantidade;
  @HiveField(1)
  final int subtotalCents;
  @HiveField(2)
  final int freteCents;
  @HiveField(3)
  final int descontoCents;
  @HiveField(4)
  final int totalCents;

  const ResumoPedidoHive({
    required this.itensQuantidade,
    required this.subtotalCents,
    required this.freteCents,
    required this.descontoCents,
    required this.totalCents,
  });
}
