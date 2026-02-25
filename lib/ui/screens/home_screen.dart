import 'package:flutter/material.dart';

import '../../app_routes.dart';
import '../../model/hive/fake_hive_repository.dart';
import '../../model/hive/hive_models.dart';
import '../theme/app_theme.dart';
import '../widgets/app_bottom_nav.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _goToSearch(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.search);
  }

  void _goToCategories(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.categories);
  }

  void _goToProduct(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.product);
  }

  void _goToAddress(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.address);
  }

  Future<void> _addToCart(BuildContext context, String productId) async {
    final added = await FakeHiveRepository.addProductToCartById(productId);
    if (!context.mounted) {
      return;
    }
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        content: Text(
          added
              ? 'Produto adicionado ao carrinho'
              : 'Nao foi possivel adicionar o produto',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: FakeHiveRepository.homeDataListenable(),
      builder: (context, child) {
        final enderecoSelecionado = FakeHiveRepository.getSelectedAddress();
        final weeklyOffers = FakeHiveRepository.getHomeOffers()
            .map(_weeklyOfferFromHive)
            .toList(growable: false);
        final homeCategories = FakeHiveRepository.getHomeCategories()
            .take(5)
            .map(_homeCategoryFromHive)
            .toList(growable: false);
        final homeProducts = FakeHiveRepository.getHomeProducts()
            .map(_homeProductFromHive)
            .toList(growable: false);

        return Scaffold(
          backgroundColor: const Color(0xFFF0F2F0),
          bottomNavigationBar: const AppBottomNav(currentIndex: 0),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(14, 10, 14, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _DeliveryHeader(
                    onAddressTap: () => _goToAddress(context),
                    addressLine:
                        '${enderecoSelecionado.logradouro}, ${enderecoSelecionado.numero}',
                  ),
                  const SizedBox(height: 12),
                  _SearchShortcut(onTap: () => _goToSearch(context)),
                  const SizedBox(height: 18),
                  _SectionTitleRow(
                    title: 'Ofertas da Semana',
                    action: 'Ver tudo',
                    onTap: () => _goToCategories(context),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 170,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: weeklyOffers.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(width: 12),
                      itemBuilder: (context, index) {
                        final offer = weeklyOffers[index];
                        return _WeeklyOfferCard(
                          data: offer,
                          onTap: () => _goToCategories(context),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        for (final category in homeCategories)
                          Padding(
                            padding: const EdgeInsets.only(right: 16),
                            child: _CategoryShortcut(
                              data: category,
                              onTap: () => _goToCategories(context),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Text(
                        'Ofertas do dia',
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 31,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 9,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFDCDD),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Text(
                          'EXPIRA EM 12H',
                          style: TextStyle(
                            fontSize: 10,
                            color: Color(0xFFE32C33),
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: homeProducts.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 0.61,
                        ),
                    itemBuilder: (context, index) {
                      return _HomeProductCard(
                        data: homeProducts[index],
                        onTap: () => _goToProduct(context),
                        onAdd: () => _addToCart(context, homeProducts[index].id),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _DeliveryHeader extends StatelessWidget {
  final VoidCallback onAddressTap;
  final String addressLine;

  const _DeliveryHeader({
    required this.onAddressTap,
    required this.addressLine,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.location_on, size: 18, color: kGreen),
        const SizedBox(width: 6),
        Expanded(
          child: GestureDetector(
            onTap: onAddressTap,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Entregar em:',
                  style: TextStyle(
                    color: kTextMuted,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 1),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      addressLine,
                      style: TextStyle(
                        color: Color(0xFF171717),
                        fontWeight: FontWeight.w800,
                        fontSize: 24,
                      ),
                    ),
                    const SizedBox(width: 3),
                    const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: 20,
                      color: Color(0xFF8B8F8D),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const _NotificationButton(),
      ],
    );
  }
}

class _NotificationButton extends StatelessWidget {
  const _NotificationButton();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: const Stack(
        clipBehavior: Clip.none,
        children: [
          Center(
            child: Icon(
              Icons.notifications_none_rounded,
              color: Color(0xFF2F3432),
            ),
          ),
          Positioned(
            right: 10,
            top: 9,
            child: CircleAvatar(radius: 4, backgroundColor: Color(0xFFE5383B)),
          ),
        ],
      ),
    );
  }
}

class _SearchShortcut extends StatelessWidget {
  final VoidCallback onTap;

  const _SearchShortcut({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 46,
        decoration: BoxDecoration(
          color: const Color(0xFFF6F7F6),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: const Color(0xFFE3E6E4)),
        ),
        child: const Row(
          children: [
            SizedBox(width: 14),
            Icon(Icons.search, color: Color(0xFFA8AEAB)),
            SizedBox(width: 8),
            Text(
              'Busque produtos ou marcas',
              style: TextStyle(
                color: Color(0xFFA1A7A3),
                fontWeight: FontWeight.w600,
                fontSize: 17,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionTitleRow extends StatelessWidget {
  final String title;
  final String action;
  final VoidCallback onTap;

  const _SectionTitleRow({
    required this.title,
    required this.action,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 34),
        ),
        GestureDetector(
          onTap: onTap,
          child: Text(
            action,
            style: const TextStyle(
              color: kGreenDark,
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }
}

class _WeeklyOfferCard extends StatelessWidget {
  final _WeeklyOfferData data;
  final VoidCallback onTap;

  const _WeeklyOfferCard({required this.data, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: data.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: data.colors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isCompact = constraints.maxWidth < 210;
              final titleFontSize = isCompact ? 26.0 : 34.0;
              final tagFontSize = isCompact ? 9.0 : 10.0;
              final subtitleFontSize = isCompact ? 10.5 : 12.0;
              final verticalPadding = isCompact ? 8.0 : 10.0;

              return Stack(
                children: [
                  Positioned(
                    right: -14,
                    bottom: -8,
                    child: _OfferDecor(
                      accent: data.decorAccent,
                      scale: isCompact ? 0.86 : 1,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                      10,
                      verticalPadding,
                      10,
                      isCompact ? 8 : 9,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: isCompact ? 7 : 8,
                            vertical: isCompact ? 3 : 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF08F96E),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            data.tag,
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w800,
                              fontSize: tagFontSize,
                            ),
                          ),
                        ),
                        SizedBox(height: isCompact ? 6 : 8),
                        Text(
                          data.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: titleFontSize,
                            height: isCompact ? 1 : 1.05,
                          ),
                        ),
                        const Spacer(),
                        SizedBox(height: isCompact ? 2 : 3),
                        Text(
                          data.subtitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: const Color(0xFFEAF2EA),
                            fontWeight: FontWeight.w600,
                            fontSize: subtitleFontSize,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _OfferDecor extends StatelessWidget {
  final Color accent;
  final double scale;

  const _OfferDecor({required this.accent, this.scale = 1});

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: scale,
      alignment: Alignment.bottomRight,
      child: SizedBox(
        width: 104,
        height: 104,
        child: Stack(
          children: [
            Positioned(
              right: 10,
              top: 10,
              child: CircleAvatar(
                radius: 19,
                backgroundColor: accent.withValues(alpha: 0.85),
              ),
            ),
            Positioned(
              left: 16,
              bottom: 6,
              child: CircleAvatar(
                radius: 21,
                backgroundColor: accent.withValues(alpha: 0.65),
              ),
            ),
            Positioned(
              right: 22,
              bottom: 18,
              child: Transform.rotate(
                angle: 0.35,
                child: Container(
                  width: 44,
                  height: 14,
                  decoration: BoxDecoration(
                    color: accent,
                    borderRadius: BorderRadius.circular(10),
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

class _CategoryShortcut extends StatelessWidget {
  final _HomeCategoryData data;
  final VoidCallback onTap;

  const _CategoryShortcut({required this.data, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 54,
        child: Column(
          children: [
            Container(
              width: 52,
              height: 44,
              decoration: BoxDecoration(
                color: data.background,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(data.icon, color: data.iconColor, size: 24),
            ),
            const SizedBox(height: 6),
            Text(
              data.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Color(0xFF59615E),
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeProductCard extends StatelessWidget {
  final _HomeProductData data;
  final VoidCallback onTap;
  final VoidCallback onAdd;

  const _HomeProductCard({
    required this.data,
    required this.onTap,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(9, 9, 9, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Container(
                    height: 116,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: LinearGradient(
                        colors: data.imageGradient,
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Center(
                      child: Icon(
                        data.imageIcon,
                        color: data.imageIconColor,
                        size: 54,
                      ),
                    ),
                  ),
                  if (data.badge != null)
                    Positioned(
                      left: 7,
                      top: 7,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0EF167),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          data.badge!,
                          style: const TextStyle(
                            color: Color(0xFF01401A),
                            fontWeight: FontWeight.w800,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                data.category,
                style: const TextStyle(
                  color: Color(0xFFA2A8A5),
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                data.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Color(0xFF121715),
                  fontWeight: FontWeight.w800,
                  fontSize: 18,
                  height: 1.02,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                data.subtitle,
                style: const TextStyle(
                  color: Color(0xFFA3A9A6),
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              if (data.oldPrice != null)
                Text(
                  data.oldPrice!,
                  style: const TextStyle(
                    color: Color(0xFFB8BDBA),
                    decoration: TextDecoration.lineThrough,
                    fontWeight: FontWeight.w700,
                    fontSize: 11,
                  ),
                ),
              const SizedBox(height: 2),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      data.price,
                      style: TextStyle(
                        color: data.priceColor,
                        fontWeight: FontWeight.w900,
                        fontSize: 30,
                        height: 1,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: data.soldOut ? null : onAdd,
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: data.soldOut ? const Color(0xFFB7BEBA) : kGreen,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.add,
                        size: 20,
                        color: Color(0xFF0F3520),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WeeklyOfferData {
  final String tag;
  final String title;
  final String subtitle;
  final List<Color> colors;
  final Color decorAccent;
  final double width;

  const _WeeklyOfferData({
    required this.tag,
    required this.title,
    required this.subtitle,
    required this.colors,
    required this.decorAccent,
    required this.width,
  });
}

class _HomeCategoryData {
  final String label;
  final IconData icon;
  final Color background;
  final Color iconColor;

  const _HomeCategoryData({
    required this.label,
    required this.icon,
    required this.background,
    required this.iconColor,
  });
}

class _HomeProductData {
  final String id;
  final String category;
  final String name;
  final String subtitle;
  final String price;
  final String? oldPrice;
  final String? badge;
  final Color priceColor;
  final List<Color> imageGradient;
  final IconData imageIcon;
  final Color imageIconColor;
  final bool soldOut;

  const _HomeProductData({
    required this.id,
    required this.category,
    required this.name,
    required this.subtitle,
    required this.price,
    this.oldPrice,
    this.badge,
    required this.priceColor,
    required this.imageGradient,
    required this.imageIcon,
    required this.imageIconColor,
    required this.soldOut,
  });
}

_WeeklyOfferData _weeklyOfferFromHive(OfertaHive offer) {
  final decorAccent = switch (offer.id) {
    'offer_002' => const Color(0xFFC58A4A),
    _ => const Color(0xFFF97316),
  };
  return _WeeklyOfferData(
    tag: offer.tag,
    title: offer.titulo,
    subtitle: offer.subtitulo,
    colors: <Color>[Color(offer.corInicioHex), Color(offer.corFimHex)],
    decorAccent: decorAccent,
    width: offer.larguraCard,
  );
}

_HomeCategoryData _homeCategoryFromHive(CategoriaHive category) {
  switch (category.id) {
    case 'cat_hortifruti':
      return const _HomeCategoryData(
        label: 'Hortifruti',
        icon: Icons.eco_rounded,
        background: Color(0xFFDDF5E8),
        iconColor: Color(0xFF238E4F),
      );
    case 'cat_carnes':
      return const _HomeCategoryData(
        label: 'Carnes',
        icon: Icons.restaurant_rounded,
        background: Color(0xFFFCE0E6),
        iconColor: Color(0xFFD4435F),
      );
    case 'cat_padaria':
      return const _HomeCategoryData(
        label: 'Padaria',
        icon: Icons.breakfast_dining_rounded,
        background: Color(0xFFFEEDC8),
        iconColor: Color(0xFFCE8E1E),
      );
    case 'cat_bebidas':
      return const _HomeCategoryData(
        label: 'Bebidas',
        icon: Icons.local_bar_rounded,
        background: Color(0xFFDDE8FF),
        iconColor: Color(0xFF2E5CC7),
      );
    case 'cat_laticinios':
      return const _HomeCategoryData(
        label: 'Latic.',
        icon: Icons.local_drink_rounded,
        background: Color(0xFFFFE7D8),
        iconColor: Color(0xFFDB7323),
      );
    default:
      return _HomeCategoryData(
        label: category.nome,
        icon: Icons.category_rounded,
        background: const Color(0xFFE9ECEA),
        iconColor: const Color(0xFF6C746F),
      );
  }
}

_HomeProductData _homeProductFromHive(ProdutoHive product) {
  switch (product.id) {
    case 'prd_banana_prata':
      return _HomeProductData(
        id: product.id,
        category: _nomeCategoria(product.categoriaId),
        name: product.nome,
        subtitle: product.subtitulo,
        price: formatMoedaCents(product.precoCents),
        oldPrice: product.precoAntigoCents == null
            ? null
            : formatMoedaCents(product.precoAntigoCents!),
        badge: product.badge,
        priceColor: const Color(0xFF21B15A),
        imageGradient: const <Color>[Color(0xFFF8E26D), Color(0xFFF1C94D)],
        imageIcon: Icons.energy_savings_leaf_rounded,
        imageIconColor: const Color(0xFF9D7B1A),
        soldOut: product.esgotado,
      );
    case 'prd_arroz_tio_joao_5kg':
      return _HomeProductData(
        id: product.id,
        category: _nomeCategoria(product.categoriaId),
        name: product.nome,
        subtitle: product.subtitulo,
        price: formatMoedaCents(product.precoCents),
        oldPrice: product.precoAntigoCents == null
            ? null
            : formatMoedaCents(product.precoAntigoCents!),
        badge: product.badge,
        priceColor: const Color(0xFF21B15A),
        imageGradient: const <Color>[Color(0xFF3F434A), Color(0xFF121418)],
        imageIcon: Icons.inventory_2_rounded,
        imageIconColor: const Color(0xFFE6DFC7),
        soldOut: product.esgotado,
      );
    case 'prd_leite_integral_1l':
      return _HomeProductData(
        id: product.id,
        category: _nomeCategoria(product.categoriaId),
        name: product.nome,
        subtitle: product.subtitulo,
        price: formatMoedaCents(product.precoCents),
        oldPrice: product.precoAntigoCents == null
            ? null
            : formatMoedaCents(product.precoAntigoCents!),
        badge: product.badge,
        priceColor: const Color(0xFF21B15A),
        imageGradient: const <Color>[Color(0xFFF7E8DF), Color(0xFFE6CEBE)],
        imageIcon: Icons.local_drink_rounded,
        imageIconColor: const Color(0xFFF4FAFF),
        soldOut: product.esgotado,
      );
    case 'prd_coca_zero_2l':
      return _HomeProductData(
        id: product.id,
        category: _nomeCategoria(product.categoriaId),
        name: product.nome,
        subtitle: product.subtitulo,
        price: formatMoedaCents(product.precoCents),
        oldPrice: product.precoAntigoCents == null
            ? null
            : formatMoedaCents(product.precoAntigoCents!),
        badge: product.badge,
        priceColor: const Color(0xFF131716),
        imageGradient: const <Color>[Color(0xFFF6EDCF), Color(0xFF0A0F1B)],
        imageIcon: Icons.local_bar_rounded,
        imageIconColor: const Color(0xFF5D3020),
        soldOut: product.esgotado,
      );
    default:
      return _HomeProductData(
        id: product.id,
        category: _nomeCategoria(product.categoriaId),
        name: product.nome,
        subtitle: product.subtitulo,
        price: formatMoedaCents(product.precoCents),
        oldPrice: product.precoAntigoCents == null
            ? null
            : formatMoedaCents(product.precoAntigoCents!),
        badge: product.badge,
        priceColor: const Color(0xFF21B15A),
        imageGradient: const <Color>[Color(0xFFE5E7EB), Color(0xFFD1D5DB)],
        imageIcon: Icons.shopping_bag_rounded,
        imageIconColor: const Color(0xFF6B7280),
        soldOut: product.esgotado,
      );
  }
}

String _nomeCategoria(String categoriaId) {
  const nomes = <String, String>{
    'cat_hortifruti': 'Hortifruti',
    'cat_carnes': 'Carnes',
    'cat_padaria': 'Padaria',
    'cat_bebidas': 'Bebidas',
    'cat_laticinios': 'Laticinios',
    'cat_mercearia': 'Mercearia',
  };
  return nomes[categoriaId] ?? 'Categoria';
}
