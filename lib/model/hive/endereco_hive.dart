import 'package:hive_ce/hive.dart';

@HiveType(typeId: 5)
class EnderecoHive {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String usuarioId;
  @HiveField(2)
  final String apelido;
  @HiveField(3)
  final String logradouro;
  @HiveField(4)
  final String numero;
  @HiveField(5)
  final String bairro;
  @HiveField(6)
  final String cidade;
  @HiveField(7)
  final String estado;
  @HiveField(8)
  final String cep;
  @HiveField(9)
  final String? complemento;
  @HiveField(10)
  final String? referencia;
  @HiveField(11)
  final double? latitude;
  @HiveField(12)
  final double? longitude;
  @HiveField(13)
  final bool padrao;

  const EnderecoHive({
    required this.id,
    required this.usuarioId,
    required this.apelido,
    required this.logradouro,
    required this.numero,
    required this.bairro,
    required this.cidade,
    required this.estado,
    required this.cep,
    required this.complemento,
    required this.referencia,
    required this.latitude,
    required this.longitude,
    required this.padrao,
  });
}
