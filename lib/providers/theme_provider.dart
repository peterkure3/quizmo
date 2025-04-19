import 'package:flutter/material.dart';
import '../services/theme_service.dart';

class ThemeProvider extends ChangeNotifier {
  final ThemeService _themeService;
  bool get isDarkMode => _themeService.isDarkMode;

  ThemeProvider(this._themeService);

  void toggleTheme() {
    _themeService.toggleTheme();
    notifyListeners();
  }
}
