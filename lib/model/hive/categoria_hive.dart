import 'package:hive_ce/hive.dart';

@HiveType(typeId: 6)
class CategoriaHive {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String nome;
  @HiveField(2)
  final int? iconeCodePoint;
  @HiveField(3)
  final int ordem;
  @HiveField(4)
  final bool ativa;

  const CategoriaHive({
    required this.id,
    required this.nome,
    required this.iconeCodePoint,
    required this.ordem,
    required this.ativa,
  });
}
