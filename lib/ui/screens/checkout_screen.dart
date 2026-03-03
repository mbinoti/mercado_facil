import 'package:app_mercadofacil/model/cart_item.dart';
import 'package:app_mercadofacil/model/order.dart';
import 'package:app_mercadofacil/ui/platform/platform_ui.dart';
import 'package:app_mercadofacil/viewmodel/app_shell_viewmodel.dart';
import 'package:app_mercadofacil/viewmodel/cart_viewmodel.dart';
import 'package:app_mercadofacil/viewmodel/orders_viewmodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Etapa de checkout usada para escolher entrega e pagamento antes de fechar o pedido.
class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key, required this.items});

  final List<CartItem> items;

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

const List<int> _creditInstallmentOptions = [1, 2, 3, 4, 5, 6];

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _recipientController;
  late final TextEditingController _addressController;
  late final TextEditingController _neighborhoodController;
  late final TextEditingController _referenceController;

  OrderFulfillmentType _fulfillmentType = OrderFulfillmentType.expressDelivery;
  OrderPaymentMethod _paymentMethod = OrderPaymentMethod.pix;
  int _creditInstallments = 1;

  @override
  void initState() {
    super.initState();
    _recipientController = TextEditingController(text: 'Marcos');
    _addressController = TextEditingController(text: 'Rua das Acacias, 245');
    _neighborhoodController = TextEditingController(text: 'Centro');
    _referenceController = TextEditingController();
  }

  @override
  void dispose() {
    _recipientController.dispose();
    _addressController.dispose();
    _neighborhoodController.dispose();
    _referenceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isCupertino = isCupertinoContext(context);
    final subtotalCents = widget.items.fold<int>(
      0,
      (sum, item) => sum + item.totalPriceCents,
    );
    final totalCents = subtotalCents + _fulfillmentType.feeCents;
    final body = Material(
      color: Colors.transparent,
      child: Form(
        key: _formKey,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= 980;
            final content = ListView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
              children: [
                const _CheckoutIntro(),
                const SizedBox(height: 16),
                _CheckoutSection(
                  title: 'Como voce quer receber',
                  child: _CheckoutChoiceGroup<OrderFulfillmentType>(
                    options: OrderFulfillmentType.values,
                    selected: _fulfillmentType,
                    onSelected: (value) {
                      setState(() {
                        _fulfillmentType = value;
                      });
                    },
                    titleBuilder: (option) => option.label,
                    descriptionBuilder: (option) =>
                        '${option.description} • ${option.etaLabel}',
                    trailingBuilder: (option) => option.feeLabel,
                    iconBuilder: (option, context) => platformIcon(
                      context,
                      material: option.materialIcon,
                      cupertino: option.cupertinoIcon,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                _CheckoutSection(
                  title: _fulfillmentType == OrderFulfillmentType.storePickup
                      ? 'Quem vai retirar'
                      : 'Endereco de entrega',
                  child: _AddressFormFields(
                    recipientController: _recipientController,
                    addressController: _addressController,
                    neighborhoodController: _neighborhoodController,
                    referenceController: _referenceController,
                    isPickup:
                        _fulfillmentType == OrderFulfillmentType.storePickup,
                  ),
                ),
                const SizedBox(height: 16),
                _CheckoutSection(
                  title: 'Forma de pagamento',
                  child: Column(
                    children: [
                      _CheckoutChoiceGroup<OrderPaymentMethod>(
                        options: OrderPaymentMethod.values,
                        selected: _paymentMethod,
                        onSelected: (value) {
                          setState(() {
                            _paymentMethod = value;
                          });
                        },
                        titleBuilder: (option) => option.label,
                        descriptionBuilder: (option) => option.description,
                        iconBuilder: (option, context) => platformIcon(
                          context,
                          material: option.materialIcon,
                          cupertino: option.cupertinoIcon,
                        ),
                      ),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 180),
                        child: _paymentMethod == OrderPaymentMethod.creditCard
                            ? Padding(
                                padding: const EdgeInsets.only(top: 12),
                                child: _CreditInstallmentsSelector(
                                  totalCents: totalCents,
                                  selectedInstallments: _creditInstallments,
                                  onSelected: (value) {
                                    setState(() {
                                      _creditInstallments = value;
                                    });
                                  },
                                ),
                              )
                            : const SizedBox.shrink(),
                      ),
                    ],
                  ),
                ),
              ],
            );

            if (isWide) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 7, child: content),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 4,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 12, 16, 24),
                      child: _CheckoutSummaryCard(
                        items: widget.items,
                        fulfillmentType: _fulfillmentType,
                        paymentMethod: _paymentMethod,
                        creditInstallments: _creditInstallments,
                        onConfirm: _confirmCheckout,
                      ),
                    ),
                  ),
                ],
              );
            }

            return Column(
              children: [
                Expanded(child: content),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: _CheckoutSummaryCard(
                    items: widget.items,
                    fulfillmentType: _fulfillmentType,
                    paymentMethod: _paymentMethod,
                    creditInstallments: _creditInstallments,
                    onConfirm: _confirmCheckout,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );

    if (isCupertino) {
      return CupertinoPageScaffold(
        backgroundColor: const Color(0xFFF4F2EC),
        navigationBar: CupertinoNavigationBar(
          backgroundColor: const Color(0xFFF4F2EC).withValues(alpha: 0.94),
          border: null,
          middle: const Text('Checkout'),
        ),
        child: SafeArea(top: false, child: body),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF4F2EC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF4F2EC),
        title: const Text('Checkout'),
      ),
      body: body,
    );
  }

  void _confirmCheckout() {
    final form = _formKey.currentState;
    if (form == null || !form.validate()) {
      return;
    }

    final checkout = OrderCheckoutDetails(
      recipientName: _recipientController.text.trim(),
      fulfillmentType: _fulfillmentType,
      paymentMethod: _paymentMethod,
      creditInstallments: _paymentMethod == OrderPaymentMethod.creditCard
          ? _creditInstallments
          : 1,
      addressLine: _fulfillmentType == OrderFulfillmentType.storePickup
          ? ''
          : _addressController.text.trim(),
      neighborhood: _fulfillmentType == OrderFulfillmentType.storePickup
          ? ''
          : _neighborhoodController.text.trim(),
      reference: _referenceController.text.trim(),
    );

    final navigator = Navigator.of(context);
    context.read<OrdersViewModel>().placeOrder(
      widget.items,
      checkout: checkout,
    );
    context.read<CartViewModel>().clear();
    context.read<AppShellViewModel>().goTo(AppShellTab.orders);
    navigator.popUntil((route) => route.isFirst);
  }
}

class _CreditInstallmentsSelector extends StatelessWidget {
  const _CreditInstallmentsSelector({
    required this.totalCents,
    required this.selectedInstallments,
    required this.onSelected,
  });

  final int totalCents;
  final int selectedInstallments;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xFFFAF9F5),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFE5E2D9)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Parcelamento',
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w900,
                color: const Color(0xFF111A30),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Escolha em quantas parcelas sem juros voce quer pagar o total de ${_formatPriceCents(totalCents)}.',
              style: textTheme.bodyMedium?.copyWith(
                color: const Color(0xFF66707F),
                height: 1.45,
              ),
            ),
            const SizedBox(height: 14),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                for (final installments in _creditInstallmentOptions)
                  _InstallmentOptionCard(
                    selected: installments == selectedInstallments,
                    installments: installments,
                    onTap: () => onSelected(installments),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _InstallmentOptionCard extends StatelessWidget {
  const _InstallmentOptionCard({
    required this.selected,
    required this.installments,
    required this.onTap,
  });

  final bool selected;
  final int installments;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final borderColor = selected
        ? const Color(0xFF2F8B37)
        : const Color(0xFFE5E2D9);
    final backgroundColor = selected ? const Color(0xFFF0F7EE) : Colors.white;

    return Material(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Container(
          constraints: const BoxConstraints(minWidth: 84),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: borderColor, width: selected ? 1.5 : 1),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${installments}x',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: const Color(0xFF111A30),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                installments == 1 ? 'A vista' : 'Sem juros',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: const Color(0xFF66707F),
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CheckoutIntro extends StatelessWidget {
  const _CheckoutIntro();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Fechar pedido',
              style: textTheme.headlineMedium?.copyWith(
                fontSize: 28,
                fontWeight: FontWeight.w900,
                color: const Color(0xFF111A30),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Antes de confirmar, escolha a modalidade de recebimento, informe o endereco ou retirada e defina como o pagamento sera feito.',
              style: textTheme.bodyMedium?.copyWith(
                height: 1.5,
                color: const Color(0xFF66707F),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CheckoutSection extends StatelessWidget {
  const _CheckoutSection({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
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
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }
}

class _CheckoutChoiceGroup<T> extends StatelessWidget {
  const _CheckoutChoiceGroup({
    required this.options,
    required this.selected,
    required this.onSelected,
    required this.titleBuilder,
    required this.descriptionBuilder,
    required this.iconBuilder,
    this.trailingBuilder,
  });

  final List<T> options;
  final T selected;
  final ValueChanged<T> onSelected;
  final String Function(T option) titleBuilder;
  final String Function(T option) descriptionBuilder;
  final IconData Function(T option, BuildContext context) iconBuilder;
  final String Function(T option)? trailingBuilder;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final option in options) ...[
          _ChoiceCard(
            selected: option == selected,
            icon: iconBuilder(option, context),
            title: titleBuilder(option),
            description: descriptionBuilder(option),
            trailing: trailingBuilder?.call(option),
            onTap: () => onSelected(option),
          ),
          if (option != options.last) const SizedBox(height: 12),
        ],
      ],
    );
  }
}

class _ChoiceCard extends StatelessWidget {
  const _ChoiceCard({
    required this.selected,
    required this.icon,
    required this.title,
    required this.description,
    required this.onTap,
    this.trailing,
  });

  final bool selected;
  final IconData icon;
  final String title;
  final String description;
  final VoidCallback onTap;
  final String? trailing;

  @override
  Widget build(BuildContext context) {
    final borderColor = selected
        ? const Color(0xFF2F8B37)
        : const Color(0xFFE5E2D9);
    final backgroundColor = selected
        ? const Color(0xFFF0F7EE)
        : const Color(0xFFFAF9F5);

    return Material(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(22),
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: borderColor, width: selected ? 1.5 : 1),
          ),
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: const Color(0xFF111A30)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w900,
                        color: const Color(0xFF111A30),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        height: 1.45,
                        color: const Color(0xFF66707F),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (trailing != null)
                    Text(
                      trailing!,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: const Color(0xFF2F8B37),
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  const SizedBox(height: 8),
                  Icon(
                    selected
                        ? Icons.check_circle_rounded
                        : Icons.radio_button_unchecked_rounded,
                    color: selected
                        ? const Color(0xFF2F8B37)
                        : const Color(0xFF9AA2AF),
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

class _AddressFormFields extends StatelessWidget {
  const _AddressFormFields({
    required this.recipientController,
    required this.addressController,
    required this.neighborhoodController,
    required this.referenceController,
    required this.isPickup,
  });

  final TextEditingController recipientController;
  final TextEditingController addressController;
  final TextEditingController neighborhoodController;
  final TextEditingController referenceController;
  final bool isPickup;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _CheckoutTextField(
          controller: recipientController,
          label: isPickup ? 'Nome de quem vai retirar' : 'Nome para entrega',
          hintText: 'Informe o nome do responsavel',
          validator: _requiredValidator,
        ),
        if (!isPickup) ...[
          const SizedBox(height: 12),
          _CheckoutTextField(
            controller: addressController,
            label: 'Endereco',
            hintText: 'Rua, numero e complemento principal',
            validator: _requiredValidator,
          ),
          const SizedBox(height: 12),
          _CheckoutTextField(
            controller: neighborhoodController,
            label: 'Bairro',
            hintText: 'Bairro ou regiao',
            validator: _requiredValidator,
          ),
        ] else ...[
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFFFAF9F5),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFE5E2D9)),
            ),
            padding: const EdgeInsets.all(16),
            child: Text(
              OrderFulfillmentType.storePickup.storeAddress,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: const Color(0xFF111A30),
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
        const SizedBox(height: 12),
        _CheckoutTextField(
          controller: referenceController,
          label: isPickup ? 'Observacoes' : 'Referencia',
          hintText: isPickup
              ? 'Ex.: retirar apos as 18h'
              : 'Ex.: portao lateral, apto 22',
          maxLines: 2,
        ),
      ],
    );
  }

  String? _requiredValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Campo obrigatorio';
    }

    return null;
  }
}

class _CheckoutTextField extends StatelessWidget {
  const _CheckoutTextField({
    required this.controller,
    required this.label,
    required this.hintText,
    this.maxLines = 1,
    this.validator,
  });

  final TextEditingController controller;
  final String label;
  final String hintText;
  final int maxLines;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: const Color(0xFF6F7784),
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          validator: validator,
          decoration: InputDecoration(
            hintText: hintText,
            filled: true,
            fillColor: const Color(0xFFFAF9F5),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: const BorderSide(color: Color(0xFFE5E2D9)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: const BorderSide(
                color: Color(0xFF2F8B37),
                width: 1.4,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: const BorderSide(color: Color(0xFFC94F4F)),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: const BorderSide(
                color: Color(0xFFC94F4F),
                width: 1.4,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _CheckoutSummaryCard extends StatelessWidget {
  const _CheckoutSummaryCard({
    required this.items,
    required this.fulfillmentType,
    required this.paymentMethod,
    required this.creditInstallments,
    required this.onConfirm,
  });

  final List<CartItem> items;
  final OrderFulfillmentType fulfillmentType;
  final OrderPaymentMethod paymentMethod;
  final int creditInstallments;
  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    final subtotalCents = items.fold<int>(
      0,
      (sum, item) => sum + item.totalPriceCents,
    );
    final totalCents = subtotalCents + fulfillmentType.feeCents;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xFF111A30),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Resumo final',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 16),
            _CheckoutSummaryRow(
              label: 'Itens',
              value: '${items.length} produtos',
            ),
            const SizedBox(height: 10),
            _CheckoutSummaryRow(
              label: 'Subtotal',
              value: _formatPriceCents(subtotalCents),
            ),
            const SizedBox(height: 10),
            _CheckoutSummaryRow(
              label: fulfillmentType.label,
              value: fulfillmentType.feeLabel,
            ),
            const SizedBox(height: 10),
            _CheckoutSummaryRow(label: 'Pagamento', value: paymentMethod.label),
            if (paymentMethod == OrderPaymentMethod.creditCard) ...[
              const SizedBox(height: 10),
              _CheckoutSummaryRow(
                label: 'Parcelamento',
                value: paymentMethod.installmentPlanLabel(creditInstallments),
              ),
            ],
            const SizedBox(height: 10),
            _CheckoutSummaryRow(
              label: 'Total',
              value: _formatPriceCents(totalCents),
              emphasize: true,
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: onConfirm,
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF2F8B37),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                ),
                child: const Text('Confirmar e fechar pedido'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CheckoutSummaryRow extends StatelessWidget {
  const _CheckoutSummaryRow({
    required this.label,
    required this.value,
    this.emphasize = false,
  });

  final String label;
  final String value;
  final bool emphasize;

  @override
  Widget build(BuildContext context) {
    final color = emphasize ? Colors.white : const Color(0xFFD0D6E3);

    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}

String _formatPriceCents(int cents) {
  final reais = cents ~/ 100;
  final centavos = (cents % 100).toString().padLeft(2, '0');
  return 'R\$ $reais,$centavos';
}
