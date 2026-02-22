import 'package:hive_ce/hive.dart';

import 'hive_enums.dart';

@HiveType(typeId: 10)
class ItemCarrinhoHive {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String produtoId;
  @HiveField(2)
  final String nomeSnapshot;
  @HiveField(3)
  final String subtituloSnapshot;
  @HiveField(4)
  final UnidadeMedidaHive unidade;
  @HiveField(5)
  final double quantidade;
  @HiveField(6)
  final int precoUnitarioCents;
  @HiveField(7)
  final int? precoAntigoUnitarioCents;
  @HiveField(8)
  final bool aceitaSubstituicao;
  @HiveField(9)
  final String? observacao;
  @HiveField(10)
  final DateTime adicionadoEm;

  const ItemCarrinhoHive({
    required this.id,
    required this.produtoId,
    required this.nomeSnapshot,
    required this.subtituloSnapshot,
    required this.unidade,
    required this.quantidade,
    required this.precoUnitarioCents,
    required this.precoAntigoUnitarioCents,
    required this.aceitaSubstituicao,
    required this.observacao,
    required this.adicionadoEm,
  });
}
