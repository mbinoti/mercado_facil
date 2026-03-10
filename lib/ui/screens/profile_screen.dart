import 'package:app_mercadofacil/model/user_profile.dart';
import 'package:app_mercadofacil/repository/local_fake_profile_repository.dart';
import 'package:app_mercadofacil/ui/platform/platform_ui.dart';
import 'package:app_mercadofacil/viewmodel/app_shell_viewmodel.dart';
import 'package:app_mercadofacil/viewmodel/cart_viewmodel.dart';
import 'package:app_mercadofacil/viewmodel/orders_viewmodel.dart';
import 'package:app_mercadofacil/viewmodel/profile_viewmodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Tela de perfil com dados pessoais, endereco, preferencias e atalhos.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) =>
          ProfileViewModel(repository: LocalFakeProfileRepository())..load(),
      child: const _ProfileScreenView(),
    );
  }
}

class _ProfileScreenView extends StatelessWidget {
  const _ProfileScreenView();

  @override
  Widget build(BuildContext context) {
    final isCupertino = isCupertinoContext(context);
    final body = DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            _profileBackgroundColor,
            _profileBackgroundColor,
            _profileBackgroundColor.withValues(alpha: 0.94),
          ],
        ),
      ),
      child: SafeArea(
        child: Consumer<ProfileViewModel>(
          builder: (context, viewModel, child) {
            final profile = viewModel.profile;
            final isInitialLoad =
                (viewModel.state == ProfileViewState.initial ||
                    viewModel.state == ProfileViewState.loading) &&
                profile == null;

            if (isInitialLoad) {
              return const _ProfileLoadingState();
            }

            if (viewModel.state == ProfileViewState.error && profile == null) {
              return _ProfileMessageState(
                icon: platformIcon(
                  context,
                  material: Icons.person_off_outlined,
                  cupertino: CupertinoIcons.person_crop_circle_badge_exclam,
                ),
                title: 'Nao foi possivel carregar o perfil.',
                description:
                    viewModel.errorMessage ??
                    'Tente novamente em instantes para recuperar seus dados.',
                actionLabel: 'Tentar novamente',
                onPressed: viewModel.retry,
              );
            }

            if (viewModel.state == ProfileViewState.empty || profile == null) {
              return _ProfileMessageState(
                icon: platformIcon(
                  context,
                  material: Icons.person_search_outlined,
                  cupertino: CupertinoIcons.person_crop_circle_badge_xmark,
                ),
                title: 'Nenhum perfil encontrado.',
                description:
                    'Crie ou recarregue seus dados para liberar endereco, preferencias e pagamento padrao.',
                actionLabel: 'Recarregar',
                onPressed: viewModel.retry,
              );
            }

            return _ProfileContent(profile: profile);
          },
        ),
      ),
    );

    if (isCupertino) {
      return CupertinoPageScaffold(
        backgroundColor: _profileBackgroundColor,
        child: Material(color: Colors.transparent, child: body),
      );
    }

    return Scaffold(backgroundColor: _profileBackgroundColor, body: body);
  }
}

class _ProfileContent extends StatelessWidget {
  const _ProfileContent({required this.profile});

  final UserProfile profile;

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ProfileViewModel>();

    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 980),
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          children: [
            const _ProfileHeader(),
            const SizedBox(height: 16),
            if (viewModel.isSaving) ...[
              const ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(999)),
                child: LinearProgressIndicator(minHeight: 4),
              ),
              const SizedBox(height: 16),
            ],
            if (viewModel.errorMessage != null &&
                viewModel.state == ProfileViewState.success) ...[
              _ProfileInlineError(message: viewModel.errorMessage!),
              const SizedBox(height: 16),
            ],
            _ProfileHeroCard(profile: profile),
            const SizedBox(height: 16),
            _ProfileQuickActionsCard(),
            const SizedBox(height: 16),
            _ProfileContactSection(profile: profile),
            const SizedBox(height: 16),
            _ProfileAddressSection(profile: profile),
            const SizedBox(height: 16),
            _ProfilePaymentMethodsSection(profile: profile),
            const SizedBox(height: 16),
            _ProfilePreferencesSection(profile: profile),
          ],
        ),
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Perfil',
          style: textTheme.headlineMedium?.copyWith(
            fontSize: 30,
            fontWeight: FontWeight.w900,
            color: const Color(0xFF111A30),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Gerencie seus dados, endereco principal, metodo de pagamento padrao e preferencias operacionais.',
          style: textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: const Color(0xFF6F7784),
          ),
        ),
      ],
    );
  }
}

class _ProfileHeroCard extends StatelessWidget {
  const _ProfileHeroCard({required this.profile});

  final UserProfile profile;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Consumer2<OrdersViewModel, CartViewModel>(
      builder: (context, orders, cart, child) {
        return DecoratedBox(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF1A4D66), Color(0xFF4E8FA8)],
            ),
            borderRadius: BorderRadius.circular(30),
            boxShadow: const [
              BoxShadow(
                color: Color(0x16000000),
                blurRadius: 24,
                offset: Offset(0, 12),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.16),
                        shape: BoxShape.circle,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(18),
                        child: Text(
                          profile.initials,
                          style: textTheme.headlineSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            profile.fullName,
                            style: textTheme.headlineSmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '${profile.membershipLabel} • ${profile.preferredDeliveryWindowLabel}',
                            style: textTheme.bodyMedium?.copyWith(
                              color: Colors.white.withValues(alpha: 0.82),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            profile.defaultAddress.summary,
                            style: textTheme.bodyMedium?.copyWith(
                              color: Colors.white.withValues(alpha: 0.82),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    _ProfileMetricChip(
                      label: 'Pedidos',
                      value: '${orders.totalOrders}',
                    ),
                    _ProfileMetricChip(
                      label: 'Total gasto',
                      value: orders.totalSpent,
                    ),
                    _ProfileMetricChip(
                      label: 'Carrinho',
                      value: cart.totalItems == 0
                          ? 'vazio'
                          : '${cart.totalItems} item(ns)',
                    ),
                    _ProfileMetricChip(
                      label: 'Economia do mes',
                      value: _formatPrice(profile.savedThisMonthCents),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ProfileMetricChip extends StatelessWidget {
  const _ProfileMetricChip({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: textTheme.bodySmall?.copyWith(
                color: Colors.white.withValues(alpha: 0.76),
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: textTheme.bodyMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileQuickActionsCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _ProfileSectionCard(
      title: 'Atalhos rapidos',
      subtitle: 'Acesse pedidos, carrinho ou retorne ao catalogo.',
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: [
          _ProfileActionButton(
            label: 'Catalogo',
            icon: platformIcon(
              context,
              material: Icons.storefront_rounded,
              cupertino: CupertinoIcons.house,
            ),
            onPressed: () =>
                context.read<AppShellViewModel>().goTo(AppShellTab.home),
          ),
          _ProfileActionButton(
            label: 'Carrinho',
            icon: platformIcon(
              context,
              material: Icons.shopping_cart_outlined,
              cupertino: CupertinoIcons.cart,
            ),
            onPressed: () =>
                context.read<AppShellViewModel>().goTo(AppShellTab.cart),
          ),
          _ProfileActionButton(
            label: 'Pedidos',
            icon: platformIcon(
              context,
              material: Icons.receipt_long_rounded,
              cupertino: CupertinoIcons.cube_box,
            ),
            onPressed: () =>
                context.read<AppShellViewModel>().goTo(AppShellTab.orders),
          ),
        ],
      ),
    );
  }
}

class _ProfileActionButton extends StatelessWidget {
  const _ProfileActionButton({
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final child = DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xFFEAF3F7),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: const Color(0xFF1A4D66), size: 18),
            const SizedBox(width: 8),
            Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: const Color(0xFF1A4D66),
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );

    if (isCupertinoContext(context)) {
      return CupertinoButton(
        padding: EdgeInsets.zero,
        minimumSize: Size.zero,
        onPressed: onPressed,
        child: child,
      );
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onPressed,
        child: child,
      ),
    );
  }
}

class _ProfileContactSection extends StatefulWidget {
  const _ProfileContactSection({required this.profile});

  final UserProfile profile;

  @override
  State<_ProfileContactSection> createState() => _ProfileContactSectionState();
}

class _ProfileContactSectionState extends State<_ProfileContactSection> {
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.profile.fullName);
    _emailController = TextEditingController(text: widget.profile.email);
    _phoneController = TextEditingController(text: widget.profile.phone);
  }

  @override
  void didUpdateWidget(covariant _ProfileContactSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_isEditing) {
      return;
    }

    _nameController.text = widget.profile.fullName;
    _emailController.text = widget.profile.email;
    _phoneController.text = widget.profile.phone;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isSaving = context.watch<ProfileViewModel>().isSaving;

    return _ProfileSectionCard(
      title: 'Dados pessoais',
      subtitle: 'Nome, email e telefone usados nas comunicacoes do pedido.',
      trailing: _SectionEditButton(
        editing: _isEditing,
        onPressed: isSaving
            ? null
            : () {
                setState(() {
                  _isEditing = !_isEditing;
                });
              },
      ),
      child: AnimatedCrossFade(
        duration: const Duration(milliseconds: 180),
        crossFadeState: _isEditing
            ? CrossFadeState.showSecond
            : CrossFadeState.showFirst,
        firstChild: Column(
          children: [
            _ProfileInfoRow(label: 'Nome', value: widget.profile.fullName),
            const SizedBox(height: 12),
            _ProfileInfoRow(label: 'Email', value: widget.profile.email),
            const SizedBox(height: 12),
            _ProfileInfoRow(label: 'Telefone', value: widget.profile.phone),
          ],
        ),
        secondChild: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Nome completo'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(labelText: 'Telefone'),
            ),
            const SizedBox(height: 16),
            _InlineEditorActions(
              isBusy: isSaving,
              onCancel: () {
                setState(() {
                  _isEditing = false;
                  _nameController.text = widget.profile.fullName;
                  _emailController.text = widget.profile.email;
                  _phoneController.text = widget.profile.phone;
                });
              },
              onSave: _save,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _save() async {
    final fullName = _nameController.text.trim();
    final email = _emailController.text.trim();
    final phone = _phoneController.text.trim();

    if (fullName.isEmpty || email.isEmpty || phone.isEmpty) {
      await showPlatformFeedback(
        context,
        'Preencha nome, email e telefone para salvar.',
      );
      return;
    }

    final success = await context.read<ProfileViewModel>().updatePersonalInfo(
      fullName: fullName,
      email: email,
      phone: phone,
    );
    if (!mounted) {
      return;
    }

    if (success) {
      setState(() {
        _isEditing = false;
      });
      await showPlatformFeedback(context, 'Dados pessoais atualizados.');
    }
  }
}

class _ProfileAddressSection extends StatefulWidget {
  const _ProfileAddressSection({required this.profile});

  final UserProfile profile;

  @override
  State<_ProfileAddressSection> createState() => _ProfileAddressSectionState();
}

class _ProfileAddressSectionState extends State<_ProfileAddressSection> {
  late final TextEditingController _labelController;
  late final TextEditingController _streetController;
  late final TextEditingController _neighborhoodController;
  late final TextEditingController _cityController;
  late final TextEditingController _referenceController;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _labelController = TextEditingController(
      text: widget.profile.defaultAddress.label,
    );
    _streetController = TextEditingController(
      text: widget.profile.defaultAddress.street,
    );
    _neighborhoodController = TextEditingController(
      text: widget.profile.defaultAddress.neighborhood,
    );
    _cityController = TextEditingController(
      text: widget.profile.defaultAddress.city,
    );
    _referenceController = TextEditingController(
      text: widget.profile.defaultAddress.reference,
    );
  }

  @override
  void didUpdateWidget(covariant _ProfileAddressSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_isEditing) {
      return;
    }

    _labelController.text = widget.profile.defaultAddress.label;
    _streetController.text = widget.profile.defaultAddress.street;
    _neighborhoodController.text = widget.profile.defaultAddress.neighborhood;
    _cityController.text = widget.profile.defaultAddress.city;
    _referenceController.text = widget.profile.defaultAddress.reference;
  }

  @override
  void dispose() {
    _labelController.dispose();
    _streetController.dispose();
    _neighborhoodController.dispose();
    _cityController.dispose();
    _referenceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isSaving = context.watch<ProfileViewModel>().isSaving;

    return _ProfileSectionCard(
      title: 'Endereco padrao',
      subtitle: 'Usado como base no checkout e no acompanhamento do pedido.',
      trailing: _SectionEditButton(
        editing: _isEditing,
        onPressed: isSaving
            ? null
            : () {
                setState(() {
                  _isEditing = !_isEditing;
                });
              },
      ),
      child: AnimatedCrossFade(
        duration: const Duration(milliseconds: 180),
        crossFadeState: _isEditing
            ? CrossFadeState.showSecond
            : CrossFadeState.showFirst,
        firstChild: Column(
          children: [
            _ProfileInfoRow(
              label: 'Etiqueta',
              value: widget.profile.defaultAddress.label,
            ),
            const SizedBox(height: 12),
            _ProfileInfoRow(
              label: 'Endereco',
              value: widget.profile.defaultAddress.street,
            ),
            const SizedBox(height: 12),
            _ProfileInfoRow(
              label: 'Bairro',
              value: widget.profile.defaultAddress.neighborhood,
            ),
            const SizedBox(height: 12),
            _ProfileInfoRow(
              label: 'Cidade',
              value: widget.profile.defaultAddress.city,
            ),
            const SizedBox(height: 12),
            _ProfileInfoRow(
              label: 'Referencia',
              value: widget.profile.defaultAddress.reference.isEmpty
                  ? 'Sem referencia complementar'
                  : widget.profile.defaultAddress.reference,
            ),
          ],
        ),
        secondChild: Column(
          children: [
            TextField(
              controller: _labelController,
              decoration: const InputDecoration(labelText: 'Etiqueta'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _streetController,
              decoration: const InputDecoration(labelText: 'Endereco'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _neighborhoodController,
              decoration: const InputDecoration(labelText: 'Bairro'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _cityController,
              decoration: const InputDecoration(labelText: 'Cidade'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _referenceController,
              decoration: const InputDecoration(labelText: 'Referencia'),
            ),
            const SizedBox(height: 16),
            _InlineEditorActions(
              isBusy: isSaving,
              onCancel: () {
                setState(() {
                  _isEditing = false;
                  _labelController.text = widget.profile.defaultAddress.label;
                  _streetController.text = widget.profile.defaultAddress.street;
                  _neighborhoodController.text =
                      widget.profile.defaultAddress.neighborhood;
                  _cityController.text = widget.profile.defaultAddress.city;
                  _referenceController.text =
                      widget.profile.defaultAddress.reference;
                });
              },
              onSave: _save,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _save() async {
    final label = _labelController.text.trim();
    final street = _streetController.text.trim();
    final neighborhood = _neighborhoodController.text.trim();
    final city = _cityController.text.trim();

    if (label.isEmpty ||
        street.isEmpty ||
        neighborhood.isEmpty ||
        city.isEmpty) {
      await showPlatformFeedback(
        context,
        'Preencha etiqueta, endereco, bairro e cidade para salvar.',
      );
      return;
    }

    final success = await context.read<ProfileViewModel>().updateAddress(
      ProfileAddress(
        label: label,
        street: street,
        neighborhood: neighborhood,
        city: city,
        reference: _referenceController.text.trim(),
      ),
    );
    if (!mounted) {
      return;
    }

    if (success) {
      setState(() {
        _isEditing = false;
      });
      await showPlatformFeedback(context, 'Endereco padrao atualizado.');
    }
  }
}

class _ProfilePaymentMethodsSection extends StatelessWidget {
  const _ProfilePaymentMethodsSection({required this.profile});

  final UserProfile profile;

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ProfileViewModel>();

    return _ProfileSectionCard(
      title: 'Pagamento padrao',
      subtitle:
          'Escolha qual metodo aparece selecionado por padrao no checkout.',
      child: Column(
        children: [
          for (final method in profile.paymentMethods) ...[
            _PaymentMethodTile(
              method: method,
              enabled: !viewModel.isSaving,
              onPressed: () async {
                if (method.isDefault) {
                  return;
                }

                final success = await context
                    .read<ProfileViewModel>()
                    .setDefaultPaymentMethod(method.id);
                if (!context.mounted || !success) {
                  return;
                }

                await showPlatformFeedback(
                  context,
                  '${method.label} definido como pagamento padrao.',
                );
              },
            ),
            if (method != profile.paymentMethods.last)
              const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }
}

class _PaymentMethodTile extends StatelessWidget {
  const _PaymentMethodTile({
    required this.method,
    required this.enabled,
    required this.onPressed,
  });

  final ProfilePaymentMethod method;
  final bool enabled;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final accentColor = method.isDefault
        ? const Color(0xFF1A4D66)
        : const Color(0xFF6F7784);
    final content = AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOutCubic,
      decoration: BoxDecoration(
        color: method.isDefault
            ? const Color(0xFFEAF3F7)
            : const Color(0xFFF8F7F4),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: method.isDefault
              ? const Color(0xFF1A4D66)
              : const Color(0xFFE2E5E8),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                color: const Color(0xFF1A4D66).withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Icon(
                  platformIcon(
                    context,
                    material: method.type.materialIcon,
                    cupertino: method.type.cupertinoIcon,
                  ),
                  color: const Color(0xFF1A4D66),
                  size: 20,
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    method.label,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w900,
                      color: const Color(0xFF111A30),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    method.details,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: const Color(0xFF66707F),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Icon(
              method.isDefault
                  ? platformIcon(
                      context,
                      material: Icons.check_circle_rounded,
                      cupertino: CupertinoIcons.check_mark_circled_solid,
                    )
                  : platformIcon(
                      context,
                      material: Icons.radio_button_unchecked_rounded,
                      cupertino: CupertinoIcons.circle,
                    ),
              color: accentColor,
            ),
          ],
        ),
      ),
    );

    if (isCupertinoContext(context)) {
      return CupertinoButton(
        padding: EdgeInsets.zero,
        minimumSize: Size.zero,
        onPressed: enabled ? onPressed : null,
        child: content,
      );
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: enabled ? onPressed : null,
        child: content,
      ),
    );
  }
}

class _ProfilePreferencesSection extends StatelessWidget {
  const _ProfilePreferencesSection({required this.profile});

  final UserProfile profile;

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ProfileViewModel>();
    final preferences = profile.preferences;

    return _ProfileSectionCard(
      title: 'Preferencias',
      subtitle:
          'Defina como o app deve se comunicar e tratar a reposicao do pedido.',
      child: Column(
        children: [
          _PreferenceTile(
            title: 'Notificacoes de pedido',
            subtitle: 'Receber status de preparo, saida e entrega.',
            value: preferences.pushNotificationsEnabled,
            onChanged: viewModel.isSaving
                ? null
                : (value) {
                    context.read<ProfileViewModel>().updatePushNotifications(
                      value,
                    );
                  },
          ),
          const Divider(height: 20),
          _PreferenceTile(
            title: 'Ofertas e campanhas',
            subtitle: 'Receber comunicacoes de destaque e descontos.',
            value: preferences.marketingNotificationsEnabled,
            onChanged: viewModel.isSaving
                ? null
                : (value) {
                    context
                        .read<ProfileViewModel>()
                        .updateMarketingNotifications(value);
                  },
          ),
          const Divider(height: 20),
          _PreferenceTile(
            title: 'Aceitar substituicoes',
            subtitle: 'Permitir trocas semelhantes quando algum item faltar.',
            value: preferences.allowProductSubstitutions,
            onChanged: viewModel.isSaving
                ? null
                : (value) {
                    context.read<ProfileViewModel>().updateProductSubstitutions(
                      value,
                    );
                  },
          ),
        ],
      ),
    );
  }
}

class _PreferenceTile extends StatelessWidget {
  const _PreferenceTile({
    required this.title,
    required this.subtitle,
    required this.value,
    this.onChanged,
  });

  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    return SwitchListTile.adaptive(
      contentPadding: EdgeInsets.zero,
      value: value,
      onChanged: onChanged,
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w800,
          color: const Color(0xFF111A30),
        ),
      ),
      subtitle: Text(
        subtitle,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: const Color(0xFF66707F),
          height: 1.35,
        ),
      ),
    );
  }
}

class _ProfileSectionCard extends StatelessWidget {
  const _ProfileSectionCard({
    required this.title,
    required this.subtitle,
    required this.child,
    this.trailing,
  });

  final String title;
  final String subtitle;
  final Widget child;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(28),
        boxShadow: const [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 18,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w900,
                          color: const Color(0xFF111A30),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        subtitle,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: const Color(0xFF66707F),
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
                if (trailing != null) ...[const SizedBox(width: 12), trailing!],
              ],
            ),
            const SizedBox(height: 18),
            child,
          ],
        ),
      ),
    );
  }
}

class _SectionEditButton extends StatelessWidget {
  const _SectionEditButton({required this.editing, this.onPressed});

  final bool editing;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final label = editing ? 'Fechar' : 'Editar';

    if (isCupertinoContext(context)) {
      return CupertinoButton(
        padding: EdgeInsets.zero,
        minimumSize: Size.zero,
        onPressed: onPressed,
        child: Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: const Color(0xFF1A4D66),
            fontWeight: FontWeight.w900,
          ),
        ),
      );
    }

    return TextButton(onPressed: onPressed, child: Text(label));
  }
}

class _InlineEditorActions extends StatelessWidget {
  const _InlineEditorActions({
    required this.isBusy,
    required this.onCancel,
    required this.onSave,
  });

  final bool isBusy;
  final VoidCallback onCancel;
  final Future<void> Function() onSave;

  @override
  Widget build(BuildContext context) {
    final saveButton = isCupertinoContext(context)
        ? CupertinoButton.filled(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            onPressed: isBusy ? null : onSave,
            child: Text(
              'Salvar',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w900,
              ),
            ),
          )
        : FilledButton(
            onPressed: isBusy ? null : onSave,
            child: const Text('Salvar'),
          );

    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: isBusy ? null : onCancel,
            child: const Text('Cancelar'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(child: saveButton),
      ],
    );
  }
}

class _ProfileInfoRow extends StatelessWidget {
  const _ProfileInfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 92,
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: const Color(0xFF66707F),
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            value,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: const Color(0xFF111A30),
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    );
  }
}

class _ProfileInlineError extends StatelessWidget {
  const _ProfileInlineError({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xFFFDEDEC),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF2C4BF)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Icon(
              platformIcon(
                context,
                material: Icons.error_outline_rounded,
                cupertino: CupertinoIcons.exclamationmark_circle,
              ),
              color: const Color(0xFFB24035),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: const Color(0xFF7C2B24),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileLoadingState extends StatelessWidget {
  const _ProfileLoadingState();

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator.adaptive());
  }
}

class _ProfileMessageState extends StatelessWidget {
  const _ProfileMessageState({
    required this.icon,
    required this.title,
    required this.description,
    required this.actionLabel,
    required this.onPressed,
  });

  final IconData icon;
  final String title;
  final String description;
  final String actionLabel;
  final Future<void> Function() onPressed;

  @override
  Widget build(BuildContext context) {
    final action = isCupertinoContext(context)
        ? CupertinoButton.filled(
            onPressed: onPressed,
            child: Text(
              actionLabel,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w900,
              ),
            ),
          )
        : FilledButton(onPressed: onPressed, child: Text(actionLabel));

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.96),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Padding(
              padding: const EdgeInsets.all(28),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, size: 44, color: const Color(0xFF1A4D66)),
                  const SizedBox(height: 16),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w900,
                      color: const Color(0xFF111A30),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    description,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: const Color(0xFF66707F),
                      height: 1.45,
                    ),
                  ),
                  const SizedBox(height: 20),
                  action,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

const Color _profileBackgroundColor = Color(0xFFEEF4F7);

String _formatPrice(int cents) {
  final reais = cents ~/ 100;
  final centavos = (cents % 100).toString().padLeft(2, '0');
  return 'R\$ $reais,$centavos';
}
