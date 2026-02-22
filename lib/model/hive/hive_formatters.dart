import 'hive_enums.dart';

String formatMoedaCents(int cents) {
  final negative = cents < 0;
  final absolute = cents.abs();
  final reais = absolute ~/ 100;
  final centavos = absolute % 100;
  final centsStr = centavos.toString().padLeft(2, '0');
  final value = 'R\$ $reais,$centsStr';
  return negative ? '- $value' : value;
}

String formatQuantidade(double quantidade) {
  if (quantidade == quantidade.roundToDouble()) {
    return quantidade.toInt().toString();
  }
  return quantidade.toStringAsFixed(1).replaceAll('.', ',');
}

String unidadeLabel(UnidadeMedidaHive unidade) {
  switch (unidade) {
    case UnidadeMedidaHive.unidade:
      return 'un';
    case UnidadeMedidaHive.kg:
      return 'kg';
    case UnidadeMedidaHive.g:
      return 'g';
    case UnidadeMedidaHive.l:
      return 'L';
    case UnidadeMedidaHive.ml:
      return 'ml';
    case UnidadeMedidaHive.pacote:
      return 'pacote';
  }
}

String formatPrecoProduto(int precoCents, UnidadeMedidaHive unidade) {
  return '${formatMoedaCents(precoCents)} / ${unidadeLabel(unidade)}';
}

String enderecoLinhaCurta(String logradouro, String numero, String bairro) {
  return '$logradouro, $numero - $bairro';
}

String enderecoLinhaCompleta({
  required String logradouro,
  required String numero,
  required String? complemento,
  required String bairro,
  required String cidade,
  required String estado,
}) {
  final complementoParte = (complemento == null || complemento.isEmpty)
      ? ''
      : ' - $complemento';
  return '$logradouro, $numero$complementoParte\n$bairro - $cidade, $estado';
}

String formatHorario(DateTime time) {
  final h = time.hour.toString().padLeft(2, '0');
  final m = time.minute.toString().padLeft(2, '0');
  return '$h:$m';
}
