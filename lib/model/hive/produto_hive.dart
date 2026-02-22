import 'package:hive_ce/hive.dart';

import 'hive_enums.dart';
import 'info_nutricional_hive.dart';

@HiveType(typeId: 9)
class ProdutoHive {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String categoriaId;
  @HiveField(2)
  final String nome;
  @HiveField(3)
  final String? marca;
  @HiveField(4)
  final String subtitulo;
  @HiveField(5)
  final String? descricao;
  @HiveField(6)
  final UnidadeMedidaHive unidade;
  @HiveField(7)
  final int precoCents;
  @HiveField(8)
  final int? precoAntigoCents;
  @HiveField(9)
  final String? badge;
  @HiveField(10)
  final bool esgotado;
  @HiveField(11)
  final bool favorito;
  @HiveField(12)
  final bool aceitaSubstituicaoPadrao;
  @HiveField(13)
  final String? imagemUrl;
  @HiveField(14)
  final InfoNutricionalHive? infoNutricional;
  @HiveField(15)
  final List<String> tags;

  const ProdutoHive({
    required this.id,
    required this.categoriaId,
    required this.nome,
    required this.marca,
    required this.subtitulo,
    required this.descricao,
    required this.unidade,
    required this.precoCents,
    required this.precoAntigoCents,
    required this.badge,
    required this.esgotado,
    required this.favorito,
    required this.aceitaSubstituicaoPadrao,
    required this.imagemUrl,
    required this.infoNutricional,
    required this.tags,
  });
}
