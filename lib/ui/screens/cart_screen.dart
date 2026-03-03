import 'package:app_mercadofacil/model/cart_item.dart';
import 'package:app_mercadofacil/ui/platform/platform_ui.dart';
import 'package:app_mercadofacil/ui/screens/checkout_screen.dart';
import 'package:app_mercadofacil/ui/screens/product_details_screen.dart';
import 'package:app_mercadofacil/ui/widgets/product_visual.dart';
import 'package:app_mercadofacil/ui/widgets/quantity_stepper.dart';
import 'package:app_mercadofacil/viewmodel/app_shell_viewmodel.dart';
import 'package:app_mercadofacil/viewmodel/cart_viewmodel.dart';
import 'package:app_mercadofacil/viewmodel/orders_viewmodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Tela do carrinho com listagem, ajuste de quantidade e subtotal.
class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isCupertino = isCupertinoContext(context);
    final body = Consumer<CartViewModel>(
      builder: (context, cart, child) {
        if (cart.isEmpty) {
          return const _EmptyCartState();
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
                    Expanded(child: _CartItemsList(items: cart.items)),
                    const SizedBox(width: 20),
                    SizedBox(width: 320, child: _CartSummaryCard(cart: cart)),
                  ],
                ),
              );
            }

            return Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              child: Column(
                children: [
                  Expanded(child: _CartItemsList(items: cart.items)),
                  const SizedBox(height: 16),
                  _CartSummaryCard(cart: cart),
                ],
              ),
            );
          },
        );
      },
    );

    if (isCupertino) {
      return CupertinoPageScaffold(
        backgroundColor: const Color(0xFFF4F2EC),
        navigationBar: CupertinoNavigationBar(
          backgroundColor: const Color(0xFFF4F2EC).withValues(alpha: 0.94),
          border: null,
          middle: const Text('Carrinho'),
          trailing: Consumer<CartViewModel>(
            builder: (context, cart, child) {
              if (cart.isEmpty) {
                return const SizedBox.shrink();
              }

              return CupertinoButton(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                onPressed: () => context.read<CartViewModel>().clear(),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      CupertinoIcons.trash,
                      size: 16,
                      color: Color(0xFF2F8B37),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Limpar',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: const Color(0xFF2F8B37),
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        child: SafeArea(top: false, child: body),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF4F2EC),
      appBar: AppBar(
        title: const Text('Carrinho'),
        actions: [
          Consumer<CartViewModel>(
            builder: (context, cart, child) {
              if (cart.isEmpty) {
                return const SizedBox.shrink();
              }

              return TextButton.icon(
                onPressed: () => context.read<CartViewModel>().clear(),
                icon: const Icon(Icons.delete_sweep_outlined),
                label: const Text('Limpar'),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: body,
    );
  }
}

/// Estado vazio do carrinho.
class _EmptyCartState extends StatelessWidget {
  const _EmptyCartState();

  @override
  Widget build(BuildContext context) {
    final isCupertino = isCupertinoContext(context);
    final textTheme = Theme.of(context).textTheme;
    final emptyCartIcon = platformIcon(
      context,
      material: Icons.shopping_bag_outlined,
      cupertino: CupertinoIcons.bag,
    );
    final backButton = isCupertino
        ? CupertinoButton.filled(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            onPressed: () => _returnToShopping(context),
            child: Text(
              'Voltar para compras',
              style: textTheme.bodyMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w900,
              ),
            ),
          )
        : FilledButton(
            onPressed: () => _returnToShopping(context),
            child: const Text('Voltar para compras'),
          );

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 110,
                height: 110,
                decoration: const BoxDecoration(
                  color: Color(0xFFEAF4E6),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  emptyCartIcon,
                  size: 54,
                  color: const Color(0xFF2F8B37),
                ),
              ),
              const SizedBox(height: 18),
              Text(
                'Seu carrinho esta vazio.',
                style: textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: const Color(0xFF111A30),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Adicione produtos na home ou pela pagina de detalhes para acompanhar subtotal e quantidades aqui.',
                style: textTheme.bodyMedium?.copyWith(
                  height: 1.5,
                  color: const Color(0xFF6F7784),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 18),
              backButton,
            ],
          ),
        ),
      ),
    );
  }
}

/// Lista rolavel de itens adicionados ao carrinho.
class _CartItemsList extends StatelessWidget {
  const _CartItemsList({required this.items});

  final List<CartItem> items;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: items.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        return _CartItemCard(item: items[index]);
      },
    );
  }
}

/// Card individual de item do carrinho.
class _CartItemCard extends StatelessWidget {
  const _CartItemCard({required this.item});

  final CartItem item;

  @override
  Widget build(BuildContext context) {
    final isCupertino = isCupertinoContext(context);
    final textTheme = Theme.of(context).textTheme;
    final cardBody = DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final visual = Hero(
            tag: 'product-${item.product.id}',
            child: SizedBox(
              width: 88,
              height: 88,
              child: ProductVisual(
                product: item.product,
                borderRadius: 22,
                emojiSize: 56,
                padding: const EdgeInsets.all(10),
              ),
            ),
          );

          final controls = Wrap(
            spacing: 10,
            runSpacing: 10,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              QuantityStepper(
                quantity: item.quantity,
                compact: true,
                onIncrement: () {
                  context.read<CartViewModel>().addProduct(item.product);
                },
                onDecrement: () {
                  context.read<CartViewModel>().removeSingleProduct(
                    item.product,
                  );
                },
              ),
              Text(
                'Unitario ${item.product.price}',
                style: textTheme.bodySmall?.copyWith(
                  color: const Color(0xFF6F7784),
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          );

          final trailing = Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (isCupertino)
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  onPressed: () {
                    context.read<CartViewModel>().removeProduct(item.product);
                  },
                  child: const Icon(
                    CupertinoIcons.xmark,
                    color: Color(0xFF111A30),
                  ),
                )
              else
                IconButton(
                  tooltip: 'Remover item',
                  onPressed: () {
                    context.read<CartViewModel>().removeProduct(item.product);
                  },
                  icon: const Icon(Icons.close_rounded),
                ),
              const SizedBox(height: 8),
              Text(
                item.totalPrice,
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: const Color(0xFF2F8B37),
                ),
              ),
            ],
          );

          if (constraints.maxWidth < 430) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      visual,
                      const SizedBox(width: 14),
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
                              item.product.details,
                              style: textTheme.bodyMedium?.copyWith(
                                color: const Color(0xFF6F7784),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      trailing,
                    ],
                  ),
                  const SizedBox(height: 14),
                  controls,
                ],
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                visual,
                const SizedBox(width: 14),
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
                        item.product.details,
                        style: textTheme.bodyMedium?.copyWith(
                          color: const Color(0xFF6F7784),
                        ),
                      ),
                      const SizedBox(height: 10),
                      controls,
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                trailing,
              ],
            ),
          );
        },
      ),
    );

    if (isCupertino) {
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
      color: Colors.white,
      borderRadius: BorderRadius.circular(28),
      child: InkWell(
        borderRadius: BorderRadius.circular(28),
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

void _returnToShopping(BuildContext context) {
  final navigator = Navigator.of(context);

  if (navigator.canPop()) {
    navigator.maybePop();
    return;
  }

  context.read<AppShellViewModel>().goTo(AppShellTab.home);
}

/// Resumo financeiro do carrinho.
class _CartSummaryCard extends StatelessWidget {
  const _CartSummaryCard({required this.cart});

  final CartViewModel cart;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xFF111A30),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Resumo do pedido',
              style: textTheme.titleLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 18),
            _SummaryRow(label: 'Itens', value: '${cart.totalItems}'),
            const SizedBox(height: 10),
            _SummaryRow(
              label: 'Subtotal',
              value: cart.subtotal,
              emphasize: true,
            ),
            const SizedBox(height: 10),
            _SummaryRow(
              label: 'Pedidos no historico',
              value: '${context.watch<OrdersViewModel>().totalOrders}',
            ),
            const SizedBox(height: 18),
            Text(
              'As quantidades podem ser ajustadas a qualquer momento aqui ou na pagina de detalhes do produto.',
              style: textTheme.bodyMedium?.copyWith(
                color: const Color(0xFFD0D6E3),
                height: 1.5,
              ),
            ),
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              child: _CheckoutButton(cart: cart),
            ),
          ],
        ),
      ),
    );
  }
}

class _CheckoutButton extends StatelessWidget {
  const _CheckoutButton({required this.cart});

  final CartViewModel cart;

  @override
  Widget build(BuildContext context) {
    final isCupertino = isCupertinoContext(context);

    if (isCupertino) {
      return CupertinoButton.filled(
        borderRadius: BorderRadius.circular(18),
        padding: const EdgeInsets.symmetric(vertical: 16),
        onPressed: () => _openCheckout(context, cart),
        child: Text(
          'Ir para pagamento',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w900,
          ),
        ),
      );
    }

    return FilledButton(
      onPressed: () => _openCheckout(context, cart),
      style: FilledButton.styleFrom(
        backgroundColor: const Color(0xFF2F8B37),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        textStyle: Theme.of(
          context,
        ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900),
      ),
      child: const Text('Ir para pagamento'),
    );
  }
}

void _openCheckout(BuildContext context, CartViewModel cart) {
  if (cart.isEmpty) {
    return;
  }

  Navigator.of(
    context,
  ).push(platformPageRoute(builder: (_) => CheckoutScreen(items: cart.items)));
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
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
