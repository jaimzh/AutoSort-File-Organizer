import 'package:autosort/services/api_service.dart';
import 'package:autosort/theme.dart';
import 'package:flutter/widgets.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false;
  bool get isDarkMode => _isDarkMode;

  // ThemeProvider() {
  //   // initialize colors when app starts
  //   AppColors.loadTheme(isDark: _isDarkMode);
  // }

  ThemeProvider() {
    _initializeTheme();
  }

  Future<void> _initializeTheme() async {
    final serverMode = await ApiService.getDarkMode();

    if (serverMode != null) {
      _isDarkMode = serverMode;
    }

    // 3. Apply theme colors
    AppColors.loadTheme(isDark: _isDarkMode);
    notifyListeners();
  }

  Future<void> toggleTheme() async {
    // 1. Toggle locally
    _isDarkMode = !_isDarkMode;
    AppColors.loadTheme(isDark: _isDarkMode);
    notifyListeners();

    // 2. Save to backend
    await ApiService.updateDarkMode(_isDarkMode);
  }
}
