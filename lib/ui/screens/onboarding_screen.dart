import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Experiencia de onboarding exibida na primeira abertura do aplicativo.
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({required this.onFinish, super.key});

  final Future<void> Function() onFinish;

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  static const _pages = [
    _OnboardingPageData(
      eyebrow: 'Compra inteligente',
      title: 'Seu mercado da semana em poucos toques',
      description:
          'Organize a compra, descubra atalhos por categoria e mantenha o ritmo da casa sem perder tempo.',
      accentColor: Color(0xFF0CB05A),
      surfaceColor: Color(0xFFF3FAEF),
      bullets: [
        'Atalhos por categoria',
        'Carrinho sempre acessivel',
        'Catalogo com destaque do dia',
      ],
    ),
    _OnboardingPageData(
      eyebrow: 'Entrega flexivel',
      title: 'Escolha retirada, expressa ou compra planejada',
      description:
          'Monte seu pedido no seu tempo e adapte a entrega para hoje, para a semana ou para a retirada rapida.',
      accentColor: Color(0xFF2F8B37),
      surfaceColor: Color(0xFFEEF8E9),
      bullets: [
        'Retirada sem fila',
        'Entrega expressa',
        'Fluxo simples no checkout',
      ],
    ),
    _OnboardingPageData(
      eyebrow: 'Mais recorrencia',
      title: 'Volte ao que funciona e acompanhe o que vale a pena',
      description:
          'Recompra os itens favoritos, acompanhe promocoes ativas e mantenha uma experiencia mais previsivel.',
      accentColor: Color(0xFFCE7B1D),
      surfaceColor: Color(0xFFFFF5E7),
      bullets: [
        'Promocoes em destaque',
        'Pedidos para repetir compra',
        'Fluxo claro do inicio ao fim',
      ],
    ),
  ];

  late final PageController _pageController;
  late final ValueNotifier<int> _pageIndexNotifier;
  bool _isSubmitting = false;

  int get _lastPageIndex => _pages.length - 1;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _pageIndexNotifier = ValueNotifier<int>(0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _pageIndexNotifier.dispose();
    super.dispose();
  }

  Future<void> _handlePrimaryAction() async {
    final currentPage = _pageIndexNotifier.value;
    if (currentPage < _lastPageIndex) {
      await _pageController.nextPage(
        duration: const Duration(milliseconds: 320),
        curve: Curves.easeOutCubic,
      );
      return;
    }

    if (_isSubmitting) {
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      await widget.onFinish();
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  Future<void> _handleSkip() async {
    if (_isSubmitting) {
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      await widget.onFinish();
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFF9F5EC), Color(0xFFF1F7ED), Color(0xFFE4F2DE)],
        ),
      ),
      child: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final horizontalPadding = constraints.maxWidth >= 900 ? 40.0 : 20.0;
            final maxContentWidth = constraints.maxWidth >= 1200
                ? 1120.0
                : 720.0;
            final bottomSpacing = mediaQuery.padding.bottom > 0 ? 12.0 : 20.0;

            return Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxContentWidth),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    horizontalPadding,
                    16,
                    horizontalPadding,
                    bottomSpacing,
                  ),
                  child: Column(
                    children: [
                      _OnboardingHeader(
                        onSkip: _handleSkip,
                        isSubmitting: _isSubmitting,
                      ),
                      const SizedBox(height: 20),
                      Expanded(
                        child: PageView.builder(
                          controller: _pageController,
                          itemCount: _pages.length,
                          onPageChanged: (page) {
                            _pageIndexNotifier.value = page;
                          },
                          itemBuilder: (context, index) {
                            final page = _pages[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: _OnboardingCard(
                                page: page,
                                pageIndex: index,
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                      ValueListenableBuilder<int>(
                        valueListenable: _pageIndexNotifier,
                        builder: (context, currentPage, child) {
                          return _OnboardingFooter(
                            currentPage: currentPage,
                            totalPages: _pages.length,
                            isSubmitting: _isSubmitting,
                            onPrimaryAction: _handlePrimaryAction,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _OnboardingHeader extends StatelessWidget {
  const _OnboardingHeader({required this.onSkip, required this.isSubmitting});

  final Future<void> Function() onSkip;
  final bool isSubmitting;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.88),
            borderRadius: BorderRadius.circular(999),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  CupertinoIcons.bag_fill,
                  size: 18,
                  color: const Color(0xFF0CB05A),
                ),
                const SizedBox(width: 10),
                Text(
                  'Mercado Facil',
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFF173321),
                  ),
                ),
              ],
            ),
          ),
        ),
        const Spacer(),
        TextButton(
          onPressed: isSubmitting ? null : onSkip,
          child: const Text('Pular'),
        ),
      ],
    );
  }
}

class _OnboardingCard extends StatelessWidget {
  const _OnboardingCard({required this.page, required this.pageIndex});

  final _OnboardingPageData page;
  final int pageIndex;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.82),
        borderRadius: BorderRadius.circular(36),
        boxShadow: const [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 32,
            offset: Offset(0, 20),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= 760;
            final visual = _OnboardingVisual(page: page, pageIndex: pageIndex);
            final copy = _OnboardingCopy(page: page);

            if (isWide) {
              return Row(
                children: [
                  Expanded(flex: 6, child: visual),
                  const SizedBox(width: 22),
                  Expanded(
                    flex: 5,
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      child: copy,
                    ),
                  ),
                ],
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(flex: 11, child: visual),
                const SizedBox(height: 18),
                Expanded(
                  flex: 9,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${pageIndex + 1}/3',
                          style: textTheme.labelLarge?.copyWith(
                            color: page.accentColor,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 10),
                        copy,
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _OnboardingVisual extends StatelessWidget {
  const _OnboardingVisual({required this.page, required this.pageIndex});

  final _OnboardingPageData page;
  final int pageIndex;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [page.surfaceColor, Colors.white],
        ),
        borderRadius: BorderRadius.circular(30),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (pageIndex == 0)
              Image.asset(
                'assets/images/onboarding_hero.jpg',
                fit: BoxFit.cover,
              )
            else
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      page.accentColor.withValues(alpha: 0.16),
                      page.surfaceColor,
                    ],
                  ),
                ),
              ),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.white.withValues(alpha: pageIndex == 0 ? 0.0 : 0.24),
                    const Color(
                      0xFF102014,
                    ).withValues(alpha: pageIndex == 0 ? 0.58 : 0.08),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _VisualBadge(label: page.eyebrow, color: page.accentColor),
                  const Spacer(),
                  if (pageIndex == 0)
                    _FirstPageHighlights(accentColor: page.accentColor)
                  else if (pageIndex == 1)
                    _DeliveryVisual(accentColor: page.accentColor)
                  else
                    _RecurringVisual(accentColor: page.accentColor),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingCopy extends StatelessWidget {
  const _OnboardingCopy({required this.page});

  final _OnboardingPageData page;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          page.eyebrow.toUpperCase(),
          style: textTheme.labelLarge?.copyWith(
            color: page.accentColor,
            fontWeight: FontWeight.w900,
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          page.title,
          style: textTheme.headlineMedium?.copyWith(
            fontSize: 34,
            height: 1.02,
            fontWeight: FontWeight.w900,
            color: const Color(0xFF162016),
          ),
        ),
        const SizedBox(height: 14),
        Text(
          page.description,
          style: textTheme.bodyLarge?.copyWith(
            fontSize: 16,
            height: 1.35,
            color: const Color(0xFF566454),
          ),
        ),
        const SizedBox(height: 20),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            for (final bullet in page.bullets)
              _FeaturePill(label: bullet, color: page.accentColor),
          ],
        ),
      ],
    );
  }
}

class _OnboardingFooter extends StatelessWidget {
  const _OnboardingFooter({
    required this.currentPage,
    required this.totalPages,
    required this.isSubmitting,
    required this.onPrimaryAction,
  });

  final int currentPage;
  final int totalPages;
  final bool isSubmitting;
  final Future<void> Function() onPrimaryAction;

  @override
  Widget build(BuildContext context) {
    final isLastPage = currentPage == totalPages - 1;
    final textTheme = Theme.of(context).textTheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.88),
        borderRadius: BorderRadius.circular(30),
        boxShadow: const [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 24,
            offset: Offset(0, 14),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Etapa ${currentPage + 1} de $totalPages',
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFF20311E),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    for (var index = 0; index < totalPages; index++)
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 220),
                        curve: Curves.easeOutCubic,
                        margin: EdgeInsets.only(
                          right: index == totalPages - 1 ? 0 : 8,
                        ),
                        height: 8,
                        width: currentPage == index ? 28 : 8,
                        decoration: BoxDecoration(
                          color: currentPage == index
                              ? const Color(0xFF0CB05A)
                              : const Color(0xFFD3D9CE),
                          borderRadius: BorderRadius.circular(999),
                        ),
                      ),
                  ],
                ),
              ],
            ),
            const Spacer(),
            FilledButton.icon(
              key: const Key('onboarding_primary_button'),
              onPressed: isSubmitting ? null : onPrimaryAction,
              icon: isSubmitting
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.2,
                        color: Colors.white,
                      ),
                    )
                  : Icon(
                      isLastPage
                          ? Icons.arrow_forward_rounded
                          : Icons.north_east_rounded,
                    ),
              label: Text(isLastPage ? 'Entrar agora' : 'Continuar'),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 22,
                  vertical: 18,
                ),
                textStyle: textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FeaturePill extends StatelessWidget {
  const _FeaturePill({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
        child: Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: const Color(0xFF243723),
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}

class _VisualBadge extends StatelessWidget {
  const _VisualBadge({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: color,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }
}

class _FirstPageHighlights extends StatelessWidget {
  const _FirstPageHighlights({required this.accentColor});

  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    final cardStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(
      color: Colors.white,
      fontWeight: FontWeight.w900,
    );

    return Row(
      children: [
        Expanded(
          child: _VisualStatCard(
            title: '1 toque',
            subtitle: 'para acessar categorias',
            accentColor: accentColor,
            textColor: cardStyle?.color ?? Colors.white,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _VisualStatCard(
            title: '24h',
            subtitle: 'de promocoes destacadas',
            accentColor: const Color(0xFFCE7B1D),
            textColor: cardStyle?.color ?? Colors.white,
          ),
        ),
      ],
    );
  }
}

class _DeliveryVisual extends StatelessWidget {
  const _DeliveryVisual({required this.accentColor});

  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        _VisualTimelineTile(
          icon: CupertinoIcons.house_fill,
          title: 'Entrega expressa',
          subtitle: 'Janela sugerida para hoje',
          accentColor: accentColor,
        ),
        const SizedBox(height: 12),
        _VisualTimelineTile(
          icon: CupertinoIcons.bag_fill_badge_plus,
          title: 'Retirada agil',
          subtitle: 'Pedido pronto sem fila',
          accentColor: const Color(0xFF0CB05A),
        ),
      ],
    );
  }
}

class _RecurringVisual extends StatelessWidget {
  const _RecurringVisual({required this.accentColor});

  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Row(
          children: [
            Expanded(
              child: _VisualStatCard(
                title: 'Favoritos',
                subtitle: 'retorno rapido para o carrinho',
                accentColor: accentColor,
                textColor: const Color(0xFF233223),
                lightSurface: true,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _VisualStatCard(
                title: 'Historico',
                subtitle: 'repetir pedidos mais rapido',
                accentColor: const Color(0xFF2F8B37),
                textColor: const Color(0xFF233223),
                lightSurface: true,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _VisualTimelineTile(
          icon: CupertinoIcons.sparkles,
          title: 'Ofertas destacadas',
          subtitle: 'Produtos com melhor timing no dia',
          accentColor: accentColor,
        ),
      ],
    );
  }
}

class _VisualStatCard extends StatelessWidget {
  const _VisualStatCard({
    required this.title,
    required this.subtitle,
    required this.accentColor,
    required this.textColor,
    this.lightSurface = false,
  });

  final String title;
  final String subtitle;
  final Color accentColor;
  final Color textColor;
  final bool lightSurface;

  @override
  Widget build(BuildContext context) {
    final backgroundColor = lightSurface
        ? Colors.white.withValues(alpha: 0.84)
        : const Color(0xFF17211C).withValues(alpha: 0.72);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                color: accentColor.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: lightSurface ? accentColor : Colors.white,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: textColor,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _VisualTimelineTile extends StatelessWidget {
  const _VisualTimelineTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.accentColor,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.84),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
        child: Row(
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                color: accentColor.withValues(alpha: 0.16),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Icon(icon, color: accentColor),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: const Color(0xFF1F2F1E),
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: const Color(0xFF61715F),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingPageData {
  const _OnboardingPageData({
    required this.eyebrow,
    required this.title,
    required this.description,
    required this.accentColor,
    required this.surfaceColor,
    required this.bullets,
  });

  final String eyebrow;
  final String title;
  final String description;
  final Color accentColor;
  final Color surfaceColor;
  final List<String> bullets;
}
