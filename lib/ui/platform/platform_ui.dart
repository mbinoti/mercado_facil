import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Indica se a experiencia da sessao deve usar componentes Cupertino.
bool get usesCupertinoWidgets {
  return !kIsWeb && defaultTargetPlatform == TargetPlatform.iOS;
}

/// Resolve a plataforma visual ativa a partir do contexto atual.
bool isCupertinoContext(BuildContext context) {
  final platform = Theme.of(context).platform;
  return !kIsWeb && platform == TargetPlatform.iOS;
}

/// Retorna o icone apropriado para a plataforma visual ativa.
IconData platformIcon(
  BuildContext context, {
  required IconData material,
  required IconData cupertino,
}) {
  return isCupertinoContext(context) ? cupertino : material;
}

/// Cria uma rota com transicao nativa para a plataforma atual.
PageRoute<T> platformPageRoute<T>({
  required WidgetBuilder builder,
  RouteSettings? settings,
  bool fullscreenDialog = false,
}) {
  if (usesCupertinoWidgets) {
    return CupertinoPageRoute<T>(
      builder: builder,
      settings: settings,
      fullscreenDialog: fullscreenDialog,
    );
  }

  return MaterialPageRoute<T>(
    builder: builder,
    settings: settings,
    fullscreenDialog: fullscreenDialog,
  );
}

/// Exibe um feedback breve na plataforma atual.
Future<void> showPlatformFeedback(BuildContext context, String message) async {
  if (!isCupertinoContext(context)) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
        ),
      );
    return;
  }

  final overlay = Overlay.maybeOf(context, rootOverlay: true);
  if (overlay == null) {
    return;
  }

  final entry = OverlayEntry(
    builder: (overlayContext) {
      final topInset = MediaQuery.paddingOf(overlayContext).top + 12;
      final textStyle =
          Theme.of(overlayContext).textTheme.bodyMedium?.copyWith(
                color: const Color(0xFF111A30),
                fontWeight: FontWeight.w800,
              ) ??
              const TextStyle(
                color: Color(0xFF111A30),
                fontSize: 14,
                fontWeight: FontWeight.w800,
              );

      return Positioned(
        top: topInset,
        left: 16,
        right: 16,
        child: IgnorePointer(
          child: CupertinoPopupSurface(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: DefaultTextStyle(
                style: textStyle,
                textAlign: TextAlign.center,
                child: Text(message),
              ),
            ),
          ),
        ),
      );
    },
  );

  overlay.insert(entry);
  await Future<void>.delayed(const Duration(milliseconds: 1400));
  entry.remove();
}
