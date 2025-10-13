import 'package:autosort/theme.dart';
import 'package:flutter/widgets.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false;
  bool get isDarkMode => _isDarkMode;

  ThemeProvider() {
    // initialize colors when app starts
    AppColors.loadTheme(isDark: _isDarkMode);
  }

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    AppColors.loadTheme(isDark: _isDarkMode);
    notifyListeners();
  }
}