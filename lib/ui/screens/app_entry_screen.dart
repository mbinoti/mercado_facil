import 'package:app_mercadofacil/ui/platform/platform_ui.dart';
import 'package:app_mercadofacil/ui/screens/app_shell_screen.dart';
import 'package:app_mercadofacil/ui/screens/onboarding_screen.dart';
import 'package:app_mercadofacil/viewmodel/app_launch_viewmodel.dart';
import 'package:app_mercadofacil/viewmodel/view_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Porta de entrada do aplicativo, alternando entre loading, onboarding e app.
class AppEntryScreen extends StatelessWidget {
  const AppEntryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Selector<
      AppLaunchViewModel,
      ({ViewState state, bool showOnboarding})
    >(
      selector: (_, viewModel) => (
        state: viewModel.state,
        showOnboarding: viewModel.shouldShowOnboarding,
      ),
      builder: (context, snapshot, child) {
        switch (snapshot.state) {
          case ViewState.initial:
          case ViewState.loading:
            return const _LaunchLoadingScreen();
          case ViewState.error:
            return const _LaunchErrorScreen();
          case ViewState.empty:
          case ViewState.success:
            if (snapshot.showOnboarding) {
              return OnboardingScreen(
                onFinish: () =>
                    context.read<AppLaunchViewModel>().completeOnboarding(),
              );
            }

            return const AppShellScreen();
        }
      },
    );
  }
}

class _LaunchLoadingScreen extends StatelessWidget {
  const _LaunchLoadingScreen();

  @override
  Widget build(BuildContext context) {
    final body = DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFF6F4EC), Color(0xFFEAF4E4), Color(0xFFD6EFCF)],
        ),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 340),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.9),
              borderRadius: BorderRadius.circular(32),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x16000000),
                  blurRadius: 28,
                  offset: Offset(0, 18),
                ),
              ],
            ),
            child: const Padding(
              padding: EdgeInsets.fromLTRB(28, 28, 28, 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _BrandStamp(),
                  SizedBox(height: 18),
                  CircularProgressIndicator(strokeWidth: 3.2),
                  SizedBox(height: 18),
                  Text(
                    'Preparando seu mercado do dia',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    if (isCupertinoContext(context)) {
      return CupertinoPageScaffold(child: body);
    }

    return Scaffold(body: body);
  }
}

class _LaunchErrorScreen extends StatelessWidget {
  const _LaunchErrorScreen();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final message = context.select<AppLaunchViewModel, String?>(
      (viewModel) => viewModel.errorMessage,
    );

    final body = DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFF8F3EB), Color(0xFFF1F6EB)],
        ),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(32),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x12000000),
                    blurRadius: 26,
                    offset: Offset(0, 18),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const _BrandStamp(),
                    const SizedBox(height: 18),
                    Icon(
                      platformIcon(
                        context,
                        material: Icons.wifi_tethering_error_rounded,
                        cupertino: CupertinoIcons.exclamationmark_triangle_fill,
                      ),
                      size: 42,
                      color: const Color(0xFFB05A0C),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Falha ao abrir o app',
                      style: textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      message ?? 'Tente novamente em instantes.',
                      textAlign: TextAlign.center,
                      style: textTheme.bodyMedium?.copyWith(
                        color: const Color(0xFF687264),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: () =>
                            context.read<AppLaunchViewModel>().retry(),
                        child: const Text('Tentar novamente'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );

    if (isCupertinoContext(context)) {
      return CupertinoPageScaffold(child: body);
    }

    return Scaffold(body: body);
  }
}

class _BrandStamp extends StatelessWidget {
  const _BrandStamp();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xFF0CB05A).withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.shopping_basket_rounded, color: Color(0xFF0CB05A)),
            const SizedBox(width: 10),
            Text(
              'Mercado Facil',
              style: textTheme.titleMedium?.copyWith(
                color: const Color(0xFF15522E),
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
