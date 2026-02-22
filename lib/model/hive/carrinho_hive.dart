import 'package:hive_ce/hive.dart';

import 'item_carrinho_hive.dart';

@HiveType(typeId: 11)
class CarrinhoHive {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String usuarioId;
  @HiveField(2)
  final List<ItemCarrinhoHive> itens;
  @HiveField(3)
  final String? cupomCodigo;
  @HiveField(4)
  final int descontoCupomCents;
  @HiveField(5)
  final int taxaEntregaCents;
  @HiveField(6)
  final int limiteFreteGratisCents;
  @HiveField(7)
  final int subtotalCents;
  @HiveField(8)
  final int totalCents;
  @HiveField(9)
  final DateTime atualizadoEm;

  const CarrinhoHive({
    required this.id,
    required this.usuarioId,
    required this.itens,
    required this.cupomCodigo,
    required this.descontoCupomCents,
    required this.taxaEntregaCents,
    required this.limiteFreteGratisCents,
    required this.subtotalCents,
    required this.totalCents,
    required this.atualizadoEm,
  });
}
