import 'package:app_mercadofacil/model/cart_item.dart';
import 'package:app_mercadofacil/model/order.dart';
import 'package:app_mercadofacil/ui/platform/platform_ui.dart';
import 'package:app_mercadofacil/ui/screens/product_details_screen.dart';
import 'package:app_mercadofacil/ui/widgets/product_visual.dart';
import 'package:app_mercadofacil/viewmodel/app_shell_viewmodel.dart';
import 'package:app_mercadofacil/viewmodel/cart_viewmodel.dart';
import 'package:app_mercadofacil/viewmodel/orders_viewmodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Tela de historico de pedidos efetivados pelo usuario.
class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isCupertino = isCupertinoContext(context);
    final body = Consumer<OrdersViewModel>(
      builder: (context, orders, child) {
        if (orders.isEmpty) {
          return const _EmptyOrdersState();
        }

        return LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= 980;

            if (isWide) {
              return Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 320,
                      child: _OrdersOverviewCard(viewModel: orders),
                    ),
                    const SizedBox(width: 20),
                    Expanded(child: _OrdersList(orders: orders.orders)),
                  ],
                ),
              );
            }

            return Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              child: Column(
                children: [
                  _OrdersOverviewCard(viewModel: orders),
                  const SizedBox(height: 16),
                  Expanded(child: _OrdersList(orders: orders.orders)),
                ],
              ),
            );
          },
        );
      },
    );

    if (isCupertino) {
      return CupertinoPageScaffold(
        backgroundColor: const Color(0xFFF2F0F7),
        navigationBar: CupertinoNavigationBar(
          backgroundColor: const Color(0xFFF2F0F7).withValues(alpha: 0.94),
          border: null,
          middle: const Text('Pedidos'),
        ),
        child: SafeArea(top: false, child: body),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF2F0F7),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF2F0F7),
        title: const Text('Pedidos'),
      ),
      body: body,
    );
  }
}

class _EmptyOrdersState extends StatelessWidget {
  const _EmptyOrdersState();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final isCupertino = isCupertinoContext(context);
    final action = isCupertino
        ? CupertinoButton.filled(
            borderRadius: BorderRadius.circular(18),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            onPressed: () =>
                context.read<AppShellViewModel>().goTo(AppShellTab.home),
            child: Text(
              'Explorar produtos',
              style: textTheme.bodyMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w900,
              ),
            ),
          )
        : FilledButton(
            onPressed: () =>
                context.read<AppShellViewModel>().goTo(AppShellTab.home),
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFF5C5A76),
              foregroundColor: Colors.white,
            ),
            child: const Text('Explorar produtos'),
          );

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 460),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.88),
              borderRadius: BorderRadius.circular(30),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x12000000),
                  blurRadius: 22,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(28),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: const Color(0xFF5C5A76).withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(20),
                      child: Icon(
                        Icons.inventory_2_outlined,
                        size: 40,
                        color: Color(0xFF5C5A76),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    'Nenhum pedido fechado ainda.',
                    textAlign: TextAlign.center,
                    style: textTheme.headlineMedium?.copyWith(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      color: const Color(0xFF111A30),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Quando voce passar pelo checkout e confirmar o pagamento, os pedidos aparecem aqui com entrega, pagamento e resumo completo.',
                    textAlign: TextAlign.center,
                    style: textTheme.bodyMedium?.copyWith(
                      height: 1.5,
                      color: const Color(0xFF66707F),
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

class _OrdersOverviewCard extends StatelessWidget {
  const _OrdersOverviewCard({required this.viewModel});

  final OrdersViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final latest = viewModel.latestOrder;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xFF171A2B),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Painel de pedidos',
              style: textTheme.titleLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Acompanhe o historico das compras efetivadas a partir do carrinho.',
              style: textTheme.bodyMedium?.copyWith(
                color: const Color(0xFFD0D6E3),
                height: 1.5,
              ),
            ),
            const SizedBox(height: 20),
            _OverviewRow(
              label: 'Pedidos fechados',
              value: '${viewModel.totalOrders}',
            ),
            const SizedBox(height: 10),
            _OverviewRow(label: 'Total pago', value: viewModel.totalSpent),
            if (latest != null) ...[
              const SizedBox(height: 10),
              _OverviewRow(label: 'Ultimo pedido', value: latest.code),
              const SizedBox(height: 18),
              DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        latest.placedAtLabel,
                        style: textTheme.bodySmall?.copyWith(
                          color: const Color(0xFFD0D6E3),
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${latest.checkout.fulfillmentType.label} • ${latest.checkout.paymentLabel}',
                        style: textTheme.bodyMedium?.copyWith(
                          color: Colors.white,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _OverviewRow extends StatelessWidget {
  const _OverviewRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: const Color(0xFFD0D6E3),
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

class _OrdersList extends StatelessWidget {
  const _OrdersList({required this.orders});

  final List<Order> orders;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: orders.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        return _OrderCard(order: orders[index]);
      },
    );
  }
}

class _OrderCard extends StatelessWidget {
  const _OrderCard({required this.order});

  final Order order;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final statusColor = order.status.accentColor;
    final statusIcon = platformIcon(
      context,
      material: order.status.materialIcon,
      cupertino: order.status.cupertinoIcon,
    );

    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 12,
              runSpacing: 12,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order.code,
                      style: textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w900,
                        color: const Color(0xFF111A30),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      order.placedAtLabel,
                      style: textTheme.bodyMedium?.copyWith(
                        color: const Color(0xFF6F7784),
                      ),
                    ),
                  ],
                ),
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(
                      color: statusColor.withValues(alpha: 0.24),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 7,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(statusIcon, size: 16, color: statusColor),
                        const SizedBox(width: 6),
                        Text(
                          order.status.label,
                          style: textTheme.bodySmall?.copyWith(
                            color: statusColor,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              order.status.description,
              style: textTheme.bodyMedium?.copyWith(
                color: const Color(0xFF66707F),
                height: 1.5,
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                _OrderInfoChip(
                  icon: platformIcon(
                    context,
                    material: order.checkout.fulfillmentType.materialIcon,
                    cupertino: order.checkout.fulfillmentType.cupertinoIcon,
                  ),
                  label: order.checkout.fulfillmentType.label,
                ),
                _OrderInfoChip(
                  icon: platformIcon(
                    context,
                    material: order.checkout.paymentMethod.materialIcon,
                    cupertino: order.checkout.paymentMethod.cupertinoIcon,
                  ),
                  label: order.checkout.paymentMethod.label,
                ),
              ],
            ),
            const SizedBox(height: 16),
            _OrderDetailBlock(
              title: 'Recebimento',
              lines: [
                order.checkout.destinationLabel,
                'Responsavel: ${order.checkout.recipientName}',
                'Referencia: ${order.checkout.referenceLabel}',
              ],
            ),
            const SizedBox(height: 12),
            _OrderDetailBlock(
              title: 'Pagamento',
              lines: [
                order.checkout.paymentMethod.label,
                if (order.checkout.usesCreditCardInstallments)
                  'Parcelamento: ${order.checkout.installmentPlanLabel}',
                order.checkout.paymentMethod.description,
              ],
            ),
            const SizedBox(height: 16),
            for (final item in order.items) ...[
              _OrderItemRow(item: item),
              if (item != order.items.last) const SizedBox(height: 12),
            ],
            const SizedBox(height: 16),
            Container(height: 1, color: const Color(0xFFE8E6EF)),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _OrderMetric(
                    label: 'Itens',
                    value: '${order.totalItems}',
                  ),
                ),
                Expanded(
                  child: _OrderMetric(label: 'Subtotal', value: order.subtotal),
                ),
                Expanded(
                  child: _OrderMetric(
                    label: 'Entrega',
                    value: order.checkout.deliveryFee,
                  ),
                ),
                Expanded(
                  child: _OrderMetric(
                    label: 'Total pago',
                    value: order.total,
                    emphasize: true,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _RepeatOrderButton(order: order),
          ],
        ),
      ),
    );
  }
}

class _RepeatOrderButton extends StatelessWidget {
  const _RepeatOrderButton({required this.order});

  final Order order;

  @override
  Widget build(BuildContext context) {
    final label = order.totalItems == 1
        ? 'Comprar novamente 1 item'
        : 'Comprar novamente ${order.totalItems} itens';

    if (isCupertinoContext(context)) {
      return SizedBox(
        width: double.infinity,
        child: CupertinoButton.filled(
          borderRadius: BorderRadius.circular(18),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          onPressed: () => _repeatOrder(context, order),
          child: Text(
            label,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      );
    }

    return SizedBox(
      width: double.infinity,
      child: FilledButton.icon(
        onPressed: () => _repeatOrder(context, order),
        style: FilledButton.styleFrom(
          backgroundColor: const Color(0xFF2F8B37),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          textStyle: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900),
        ),
        icon: const Icon(Icons.replay_rounded),
        label: Text(label),
      ),
    );
  }
}

class _OrderInfoChip extends StatelessWidget {
  const _OrderInfoChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xFFF4F3F8),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: const Color(0xFF5C5A76)),
            const SizedBox(width: 6),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: const Color(0xFF5C5A76),
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OrderDetailBlock extends StatelessWidget {
  const _OrderDetailBlock({required this.title, required this.lines});

  final String title;
  final List<String> lines;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xFFF8F7FB),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: textTheme.bodySmall?.copyWith(
                color: const Color(0xFF7C8491),
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 8),
            for (final line in lines) ...[
              Text(
                line,
                style: textTheme.bodyMedium?.copyWith(
                  color: const Color(0xFF111A30),
                  height: 1.45,
                ),
              ),
              if (line != lines.last) const SizedBox(height: 4),
            ],
          ],
        ),
      ),
    );
  }
}

class _OrderMetric extends StatelessWidget {
  const _OrderMetric({
    required this.label,
    required this.value,
    this.emphasize = false,
  });

  final String label;
  final String value;
  final bool emphasize;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: const Color(0xFF7C8491),
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: emphasize
                ? const Color(0xFF2F8B37)
                : const Color(0xFF111A30),
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}

class _OrderItemRow extends StatelessWidget {
  const _OrderItemRow({required this.item});

  final CartItem item;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final cardBody = Row(
      children: [
        SizedBox(
          width: 64,
          height: 64,
          child: ProductVisual(
            product: item.product,
            borderRadius: 18,
            emojiSize: 40,
            padding: const EdgeInsets.all(8),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.product.name,
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: const Color(0xFF111A30),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${item.quantity}x • ${item.product.details}',
                style: textTheme.bodyMedium?.copyWith(
                  color: const Color(0xFF6F7784),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Text(
          item.totalPrice,
          style: textTheme.titleMedium?.copyWith(
            color: const Color(0xFF2F8B37),
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );

    if (isCupertinoContext(context)) {
      return CupertinoButton(
        padding: EdgeInsets.zero,
        minimumSize: Size.zero,
        onPressed: () {
          Navigator.of(context).push(
            platformPageRoute(
              builder: (_) => ProductDetailsScreen(product: item.product),
            ),
          );
        },
        child: cardBody,
      );
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () {
          Navigator.of(context).push(
            platformPageRoute(
              builder: (_) => ProductDetailsScreen(product: item.product),
            ),
          );
        },
        child: cardBody,
      ),
    );
  }
}

void _repeatOrder(BuildContext context, Order order) {
  context.read<CartViewModel>().addItems(
    order.items,
    noticeMessage: 'Pedido ${order.code} adicionado ao carrinho.',
  );
  context.read<AppShellViewModel>().goTo(AppShellTab.cart);
}
