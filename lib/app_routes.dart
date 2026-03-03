/// Catalogo de rotas nomeadas previstas para o aplicativo.
///
/// No estado atual do projeto, essas constantes ainda nao estao ligadas ao
/// `MaterialApp`, mas servem como ponto unico para padronizar caminhos de
/// navegacao e evitar strings espalhadas pela base.
class AppRoutes {
  static const index = '/';
  static const onboarding = '/onboarding';
  static const login = '/login';
  static const address = '/address';
  static const home = '/home';
  static const search = '/search';
  static const categories = '/categories';
  static const product = '/product';
  static const cart = '/cart';
  static const checkout = '/checkout';
  static const confirmed = '/confirmed';
}
