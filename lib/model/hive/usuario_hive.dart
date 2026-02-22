import 'package:hive_ce/hive.dart';

@HiveType(typeId: 4)
class UsuarioHive {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String nome;
  @HiveField(2)
  final String? email;
  @HiveField(3)
  final String? telefone;
  @HiveField(4)
  final DateTime criadoEm;
  @HiveField(5)
  final DateTime atualizadoEm;

  const UsuarioHive({
    required this.id,
    required this.nome,
    required this.email,
    required this.telefone,
    required this.criadoEm,
    required this.atualizadoEm,
  });
}
