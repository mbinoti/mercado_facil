import 'package:hive_ce/hive.dart';

@HiveType(typeId: 3)
class SessaoAppHive {
  @HiveField(0)
  final bool onboardingConcluido;
  @HiveField(1)
  final String? usuarioLogadoId;
  @HiveField(2)
  final String? enderecoSelecionadoId;
  @HiveField(3)
  final DateTime ultimoAcessoEm;

  const SessaoAppHive({
    required this.onboardingConcluido,
    required this.usuarioLogadoId,
    required this.enderecoSelecionadoId,
    required this.ultimoAcessoEm,
  });
}
