import 'package:app_mercadofacil/viewmodel/cart_viewmodel.dart';
import 'package:app_mercadofacil/ui/platform/platform_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Botao reutilizavel de acesso ao carrinho com badge de quantidade total.
class CartButton extends StatelessWidget {
  const CartButton({
    super.key,
    required this.onPressed,
    this.backgroundColor = Colors.white,
    this.foregroundColor = const Color(0xFF111A30),
    this.size = 54,
    this.showBadge = true,
  });

  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color foregroundColor;
  final double size;
  final bool showBadge;

  @override
  Widget build(BuildContext context) {
    return Selector<CartViewModel, int>(
      selector: (_, cart) => cart.totalItems,
      builder: (context, totalItems, child) {
        final isCupertino = isCupertinoContext(context);

        return Stack(
          clipBehavior: Clip.none,
          children: [
            if (isCupertino)
              CupertinoButton(
                padding: EdgeInsets.zero,
                minimumSize: Size.square(size),
                onPressed: onPressed,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x12000000),
                        blurRadius: 12,
                        offset: Offset(0, 6),
                      ),
                    ],
                  ),
                  child: SizedBox(
                    width: size,
                    height: size,
                    child: Icon(
                      CupertinoIcons.bag,
                      color: foregroundColor,
                      size: size * 0.42,
                    ),
                  ),
                ),
              )
            else
              Material(
                color: backgroundColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                elevation: 1,
                child: InkWell(
                  borderRadius: BorderRadius.circular(18),
                  onTap: onPressed,
                  child: SizedBox(
                    width: size,
                    height: size,
                    child: Icon(
                      Icons.shopping_bag_outlined,
                      color: foregroundColor,
                    ),
                  ),
                ),
              ),
            if (showBadge && totalItems > 0)
              Positioned(
                top: -6,
                right: -6,
                child: DecoratedBox(
                  decoration: const BoxDecoration(
                    color: Color(0xFF2F8B37),
                    shape: BoxShape.circle,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(7),
                    child: Text(
                      totalItems > 99 ? '99+' : '$totalItems',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
