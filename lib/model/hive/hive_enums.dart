import 'package:hive_ce/hive.dart';

@HiveType(typeId: 0)
enum UnidadeMedidaHive {
  @HiveField(0)
  unidade,
  @HiveField(1)
  kg,
  @HiveField(2)
  g,
  @HiveField(3)
  l,
  @HiveField(4)
  ml,
  @HiveField(5)
  pacote,
}

@HiveType(typeId: 1)
enum MetodoPagamentoHive {
  @HiveField(0)
  pix,
  @HiveField(1)
  cartao,
  @HiveField(2)
  carteira,
}

@HiveType(typeId: 2)
enum StatusPedidoHive {
  @HiveField(0)
  criado,
  @HiveField(1)
  confirmado,
  @HiveField(2)
  separando,
  @HiveField(3)
  emRota,
  @HiveField(4)
  entregue,
  @HiveField(5)
  cancelado,
}
