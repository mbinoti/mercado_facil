import 'package:flutter/foundation.dart';

/// Abas principais exibidas na navegacao inferior do aplicativo.
enum AppShellTab { home, categories, cart, orders, profile }

/// Estado global da shell principal com a aba atualmente selecionada.
class AppShellViewModel extends ChangeNotifier {
  AppShellTab _currentTab = AppShellTab.home;

  AppShellTab get currentTab => _currentTab;

  int get currentIndex => AppShellTab.values.indexOf(_currentTab);

  void goTo(AppShellTab tab) {
    if (_currentTab == tab) {
      return;
    }

    _currentTab = tab;
    notifyListeners();
  }

  void goToIndex(int index) {
    if (index < 0 || index >= AppShellTab.values.length) {
      return;
    }

    goTo(AppShellTab.values[index]);
  }
}
