import 'package:hive_ce/hive.dart';

import 'hive_enums.dart';

@HiveType(typeId: 13)
class ItemPedidoHive {
  @HiveField(0)
  final String produtoId;
  @HiveField(1)
  final String nome;
  @HiveField(2)
  final double quantidade;
  @HiveField(3)
  final UnidadeMedidaHive unidade;
  @HiveField(4)
  final int precoUnitarioCents;
  @HiveField(5)
  final int totalItemCents;

  const ItemPedidoHive({
    required this.produtoId,
    required this.nome,
    required this.quantidade,
    required this.unidade,
    required this.precoUnitarioCents,
    required this.totalItemCents,
  });
}
