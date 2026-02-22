import 'package:flutter/material.dart';

import '../../app_routes.dart';
import '../../model/hive/hive_models.dart';
import '../theme/app_theme.dart';

class AddressSelectionScreen extends StatelessWidget {
  const AddressSelectionScreen({super.key});

  void _goHome(BuildContext context) {
    Navigator.pushReplacementNamed(context, AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    final savedAddresses = MercadoSeedData.enderecos;
    final selectedAddressId = MercadoSeedData.sessao.enderecoSelecionadoId;

    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F0),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF0F2F0),
        centerTitle: true,
        title: const Text(
          'Selecao de Endereco',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 17,
            color: Color(0xFF121614),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(14, 8, 14, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _AddressSearchField(),
            const SizedBox(height: 14),
            _MapPreviewCard(city: MercadoSeedData.enderecoSelecionado.cidade),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _goHome(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF19E45E),
                  foregroundColor: const Color(0xFF101512),
                  elevation: 0,
                  minimumSize: const Size.fromHeight(56),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                icon: const Icon(Icons.my_location_rounded),
                label: const Text(
                  'Usar minha localizacao atual',
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 17),
                ),
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'Enderecos salvos',
              style: TextStyle(
                color: Color(0xFF131715),
                fontWeight: FontWeight.w800,
                fontSize: 31,
              ),
            ),
            const SizedBox(height: 14),
            for (int i = 0; i < savedAddresses.length; i++) ...[
              _SavedAddressTile(
                title: savedAddresses[i].apelido,
                subtitle: enderecoLinhaCurta(
                  savedAddresses[i].logradouro,
                  savedAddresses[i].numero,
                  savedAddresses[i].bairro,
                ),
                icon: _addressIcon(savedAddresses[i].apelido),
                iconColor: _addressIconColor(savedAddresses[i].apelido),
                iconBackground: _addressIconBackground(savedAddresses[i].apelido),
                selected: savedAddresses[i].id == selectedAddressId,
                onTap: () => _goHome(context),
              ),
              if (i != savedAddresses.length - 1) const SizedBox(height: 12),
            ],
            const SizedBox(height: 12),
            _AddAddressTile(onTap: () => _goHome(context)),
          ],
        ),
      ),
    );
  }
}

class _AddressSearchField extends StatelessWidget {
  const _AddressSearchField();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE3E7E5)),
      ),
      child: const Row(
        children: [
          SizedBox(width: 14),
          Icon(Icons.search, color: Color(0xFFA6ACA8)),
          SizedBox(width: 8),
          Text(
            'Buscar endereco e numero',
            style: TextStyle(
              color: Color(0xFFA8ADAA),
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}

class _MapPreviewCard extends StatelessWidget {
  final String city;

  const _MapPreviewCard({required this.city});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 236,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFDCE3E0)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: Stack(
          children: [
            Positioned.fill(child: CustomPaint(painter: _MapPainter())),
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const _PinMarker(),
                  const SizedBox(height: 4),
                  Text(
                    city,
                    style: const TextStyle(
                      color: Color(0xFF161A18),
                      fontWeight: FontWeight.w700,
                      fontSize: 23,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              right: 10,
              bottom: 10,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Text(
                  'Toque para expandir',
                  style: TextStyle(
                    color: Color(0xFF7F8683),
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PinMarker extends StatelessWidget {
  const _PinMarker();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: kGreen,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.18),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: const Icon(Icons.location_on, color: Colors.white, size: 22),
    );
  }
}

class _SavedAddressTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final Color iconBackground;
  final bool selected;
  final VoidCallback onTap;

  const _SavedAddressTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    required this.iconBackground,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: iconBackground,
              child: Icon(icon, color: iconColor),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Color(0xFF151918),
                      fontWeight: FontWeight.w800,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Color(0xFF8C9390),
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: selected ? kGreen : const Color(0xFFB0B7B3),
                  width: 2,
                ),
              ),
              child: selected
                  ? Center(
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          color: kGreen,
                          shape: BoxShape.circle,
                        ),
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

class _AddAddressTile extends StatelessWidget {
  final VoidCallback onTap;

  const _AddAddressTile({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CustomPaint(
        painter: _DashedRRectPainter(
          color: const Color(0xFFD6DBD8),
          radius: 18,
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
          child: const Row(
            children: [
              Icon(Icons.add_location_alt_rounded, color: Color(0xFF9CA3AF)),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Adicionar novo endereco',
                  style: TextStyle(
                    color: Color(0xFF676F7B),
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
              ),
              Icon(Icons.chevron_right, color: Color(0xFF9CA3AF)),
            ],
          ),
        ),
      ),
    );
  }
}

IconData _addressIcon(String alias) {
  final normalized = alias.toLowerCase();
  if (normalized == 'casa') return Icons.home_rounded;
  if (normalized == 'trabalho') return Icons.work_rounded;
  return Icons.location_on_rounded;
}

Color _addressIconColor(String alias) {
  final normalized = alias.toLowerCase();
  if (normalized == 'casa') return const Color(0xFF1BB75A);
  if (normalized == 'trabalho') return const Color(0xFF6A7483);
  return const Color(0xFF2E7D32);
}

Color _addressIconBackground(String alias) {
  final normalized = alias.toLowerCase();
  if (normalized == 'casa') return const Color(0xFFE5F7EB);
  if (normalized == 'trabalho') return const Color(0xFFF0F2F3);
  return const Color(0xFFE6F4EA);
}

class _DashedRRectPainter extends CustomPainter {
  final Color color;
  final double radius;

  const _DashedRRectPainter({required this.color, required this.radius});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    final borderPath = Path()
      ..addRRect(
        RRect.fromRectAndRadius(Offset.zero & size, Radius.circular(radius)),
      );

    for (final metric in borderPath.computeMetrics()) {
      double distance = 0;
      while (distance < metric.length) {
        final next = (distance + 6).clamp(0, metric.length).toDouble();
        canvas.drawPath(metric.extractPath(distance, next), paint);
        distance += 10;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedRRectPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.radius != radius;
  }
}

class _MapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final background = Paint()..color = const Color(0xFFE6EEF1);
    canvas.drawRect(Offset.zero & size, background);

    final roadMajor = Paint()
      ..color = const Color(0xFFC1CFD8)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;
    final roadMinor = Paint()
      ..color = const Color(0xFFD5E0E6)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final path1 = Path()
      ..moveTo(-10, size.height * 0.28)
      ..cubicTo(
        size.width * 0.2,
        size.height * 0.18,
        size.width * 0.44,
        size.height * 0.42,
        size.width + 18,
        size.height * 0.26,
      );
    canvas.drawPath(path1, roadMajor);

    final path2 = Path()
      ..moveTo(size.width * 0.1, -8)
      ..cubicTo(
        size.width * 0.22,
        size.height * 0.25,
        size.width * 0.28,
        size.height * 0.56,
        size.width * 0.17,
        size.height + 14,
      );
    canvas.drawPath(path2, roadMajor);

    final path3 = Path()
      ..moveTo(size.width * 0.62, -16)
      ..cubicTo(
        size.width * 0.68,
        size.height * 0.26,
        size.width * 0.81,
        size.height * 0.58,
        size.width * 0.9,
        size.height + 10,
      );
    canvas.drawPath(path3, roadMajor);

    final minorLines = <Path>[
      Path()
        ..moveTo(-12, size.height * 0.46)
        ..lineTo(size.width + 18, size.height * 0.54),
      Path()
        ..moveTo(-10, size.height * 0.7)
        ..lineTo(size.width + 20, size.height * 0.76),
      Path()
        ..moveTo(size.width * 0.38, -8)
        ..lineTo(size.width * 0.46, size.height + 14),
      Path()
        ..moveTo(size.width * 0.02, size.height * 0.1)
        ..lineTo(size.width * 0.35, size.height * 0.85),
      Path()
        ..moveTo(size.width * 0.74, size.height * 0.06)
        ..lineTo(size.width * 0.42, size.height * 0.92),
    ];
    for (final minor in minorLines) {
      canvas.drawPath(minor, roadMinor);
    }

    final mapPoint = Paint()..color = const Color(0xFF4FA8E4);
    final points = <Offset>[
      Offset(size.width * 0.08, size.height * 0.18),
      Offset(size.width * 0.2, size.height * 0.34),
      Offset(size.width * 0.31, size.height * 0.22),
      Offset(size.width * 0.54, size.height * 0.3),
      Offset(size.width * 0.67, size.height * 0.13),
      Offset(size.width * 0.78, size.height * 0.44),
      Offset(size.width * 0.83, size.height * 0.28),
      Offset(size.width * 0.25, size.height * 0.67),
      Offset(size.width * 0.58, size.height * 0.7),
      Offset(size.width * 0.9, size.height * 0.76),
    ];
    for (final point in points) {
      canvas.drawCircle(point, 3.2, mapPoint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
