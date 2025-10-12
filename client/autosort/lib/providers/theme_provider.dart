import 'package:flutter/widgets.dart';

class ThemeProvider extends ChangeNotifier{
  bool _isDarkMode = false;
  bool get isDarkMode => _isDarkMode;

  void toggleTheme(){
    _isDarkMode = !isDarkMode;
    notifyListeners();
  }
}