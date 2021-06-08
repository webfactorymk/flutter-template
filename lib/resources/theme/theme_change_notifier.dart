import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_template/util/preferences.dart';

class ThemeChangeNotifier extends ChangeNotifier {
  bool _isDarkTheme;

  ThemeChangeNotifier.darkTheme() : _isDarkTheme = true;

  ThemeChangeNotifier.lightTheme() : _isDarkTheme = false;

  ThemeChangeNotifier.systemTheme(BuildContext context)
      : _isDarkTheme =
            MediaQuery.platformBrightnessOf(context) == Brightness.dark;

  ThemeChangeNotifier.fromThemeMode(BuildContext context, ThemeMode themeMode)
      : _isDarkTheme = themeMode == ThemeMode.dark ||
            (themeMode == ThemeMode.system &&
                MediaQuery.platformBrightnessOf(context) == Brightness.dark);

  bool get isDarkTheme => _isDarkTheme;

  ThemeMode get getThemeMode => isDarkTheme ? ThemeMode.dark : ThemeMode.light;

  void setDarkTheme() {
    _isDarkTheme = true;
    setIsDarkThemePreferred(_isDarkTheme);
    notifyListeners();
  }

  void setLightTheme() {
    _isDarkTheme = false;
    setIsDarkThemePreferred(_isDarkTheme);
    notifyListeners();
  }

  /// Toggles the current theme value. Returns `true` if dark is the new theme.
  bool toggleTheme() {
    _isDarkTheme = !_isDarkTheme;
    setIsDarkThemePreferred(_isDarkTheme);
    notifyListeners();
    return _isDarkTheme;
  }
}
