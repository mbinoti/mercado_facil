import 'package:hive_ce/hive.dart';

import 'hive_enums.dart';
import 'item_pedido_hive.dart';
import 'resumo_pedido_hive.dart';

@HiveType(typeId: 15)
class PedidoHive {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String numeroExibicao;
  @HiveField(2)
  final String usuarioId;
  @HiveField(3)
  final StatusPedidoHive status;
  @HiveField(4)
  final MetodoPagamentoHive metodoPagamento;
  @HiveField(5)
  final String enderecoEntregaTexto;
  @HiveField(6)
  final List<ItemPedidoHive> itens;
  @HiveField(7)
  final ResumoPedidoHive resumo;
  @HiveField(8)
  final DateTime criadoEm;
  @HiveField(9)
  final DateTime? confirmadoEm;
  @HiveField(10)
  final DateTime? entregueEm;
  @HiveField(11)
  final DateTime? estimativaInicio;
  @HiveField(12)
  final DateTime? estimativaFim;

  const PedidoHive({
    required this.id,
    required this.numeroExibicao,
    required this.usuarioId,
    required this.status,
    required this.metodoPagamento,
    required this.enderecoEntregaTexto,
    required this.itens,
    required this.resumo,
    required this.criadoEm,
    required this.confirmadoEm,
    required this.entregueEm,
    required this.estimativaInicio,
    required this.estimativaFim,
  });
}
