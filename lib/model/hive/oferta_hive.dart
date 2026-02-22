import 'package:hive_ce/hive.dart';

@HiveType(typeId: 7)
class OfertaHive {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String tag;
  @HiveField(2)
  final String titulo;
  @HiveField(3)
  final String subtitulo;
  @HiveField(4)
  final int corInicioHex;
  @HiveField(5)
  final int corFimHex;
  @HiveField(6)
  final double larguraCard;
  @HiveField(7)
  final DateTime inicioEm;
  @HiveField(8)
  final DateTime fimEm;
  @HiveField(9)
  final String? categoriaId;

  const OfertaHive({
    required this.id,
    required this.tag,
    required this.titulo,
    required this.subtitulo,
    required this.corInicioHex,
    required this.corFimHex,
    required this.larguraCard,
    required this.inicioEm,
    required this.fimEm,
    required this.categoriaId,
  });
}
