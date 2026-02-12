import 'package:flutter/material.dart';

import '../app_routes.dart';
import '../theme/app_theme.dart';
import '../widgets/address_card.dart';
import '../widgets/app_text_field.dart';

class AddressSelectionScreen extends StatelessWidget {
  const AddressSelectionScreen({super.key});

  void _goHome(BuildContext context) {
    Navigator.pushReplacementNamed(context, AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Selecao de Endereco'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AppTextField(
              hint: 'Buscar endereco e numero',
              icon: Icons.search,
            ),
            const SizedBox(height: 16),
            Container(
              height: 180,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: kBorder),
                gradient: const LinearGradient(
                  colors: [Color(0xFFE2F2E7), Color(0xFFD6EEE0)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Stack(
                children: [
                  const Center(
                    child: CircleAvatar(
                      radius: 28,
                      backgroundColor: kGreen,
                      child: Icon(
                        Icons.location_on,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ),
                  Positioned(
                    right: 16,
                    bottom: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Text(
                        'Toque para expandir',
                        style: TextStyle(fontSize: 12, color: kTextMuted),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _goHome(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: kGreen,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                ),
                icon: const Icon(Icons.my_location),
                label: const Text(
                  'Usar minha localizacao atual',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Enderecos salvos',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            AddressCard(
              title: 'Casa',
              subtitle: 'Rua das Flores, 123 - Centro',
              icon: Icons.home,
              selected: false,
              onTap: () => _goHome(context),
            ),
            const SizedBox(height: 12),
            AddressCard(
              title: 'Trabalho',
              subtitle: 'Av. Paulista, 1000 - Bela Vista',
              icon: Icons.work,
              selected: true,
              onTap: () => _goHome(context),
            ),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: kBorder),
              ),
              child: ListTile(
                leading: const Icon(Icons.add_location_alt, color: kTextMuted),
                title: const Text('Adicionar novo endereco'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _goHome(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
