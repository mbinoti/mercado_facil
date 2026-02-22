import 'package:hive_ce/hive.dart';

@HiveType(typeId: 8)
class InfoNutricionalHive {
  @HiveField(0)
  final double? caloriasKcal;
  @HiveField(1)
  final double? carboidratosG;
  @HiveField(2)
  final double? proteinasG;
  @HiveField(3)
  final double? gordurasG;
  @HiveField(4)
  final double? fibrasG;
  @HiveField(5)
  final double? potassioMg;
  @HiveField(6)
  final double? sodioMg;

  const InfoNutricionalHive({
    required this.caloriasKcal,
    required this.carboidratosG,
    required this.proteinasG,
    required this.gordurasG,
    required this.fibrasG,
    required this.potassioMg,
    required this.sodioMg,
  });
}
