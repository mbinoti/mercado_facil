import 'package:app_mercadofacil/ui/platform/platform_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Controle compacto para aumentar ou reduzir quantidade de itens.
class QuantityStepper extends StatelessWidget {
  const QuantityStepper({
    super.key,
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
    this.compact = false,
  });

  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final isCupertino = isCupertinoContext(context);
    final buttonSize = compact ? 34.0 : 42.0;
    final textStyle = compact
        ? Theme.of(context).textTheme.titleMedium
        : Theme.of(context).textTheme.titleLarge;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0xFFD6DBD3)),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: compact ? 6 : 8,
          vertical: compact ? 4 : 6,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _StepperAction(
              icon: isCupertino ? CupertinoIcons.minus : Icons.remove_rounded,
              size: buttonSize,
              useCupertino: isCupertino,
              onPressed: quantity > 0 ? onDecrement : null,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: compact ? 10 : 14),
              child: Text(
                '$quantity',
                style: textStyle?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: const Color(0xFF111A30),
                ),
              ),
            ),
            _StepperAction(
              icon: isCupertino ? CupertinoIcons.plus : Icons.add_rounded,
              size: buttonSize,
              useCupertino: isCupertino,
              onPressed: onIncrement,
            ),
          ],
        ),
      ),
    );
  }
}

class _StepperAction extends StatelessWidget {
  const _StepperAction({
    required this.icon,
    required this.size,
    required this.useCupertino,
    this.onPressed,
  });

  final IconData icon;
  final double size;
  final bool useCupertino;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final backgroundColor = onPressed == null
        ? const Color(0xFFF2F3EF)
        : const Color(0xFFEEF6EA);
    final foregroundColor = onPressed == null
        ? const Color(0xFF9CA39A)
        : const Color(0xFF2F8B37);

    if (useCupertino) {
      return CupertinoButton(
        padding: EdgeInsets.zero,
        minimumSize: Size.square(size),
        onPressed: onPressed,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(999),
          ),
          child: SizedBox(
            width: size,
            height: size,
            child: Icon(icon, color: foregroundColor, size: size * 0.46),
          ),
        ),
      );
    }

    return IconButton(
      visualDensity: VisualDensity.compact,
      onPressed: onPressed,
      style: IconButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
        minimumSize: Size.square(size),
        maximumSize: Size.square(size),
      ),
      icon: Icon(icon),
    );
  }
}
