import 'package:flutter/material.dart';
import 'package:flutter_template/di/service_locator.dart';
import 'package:flutter_template/resources/theme/theme_change_notifier.dart';
import 'package:single_item_shared_prefs/single_item_shared_prefs.dart';

class Preferences {
  late final ThemeChangeNotifier themePreferred;
  late final String languagePreferred;

  /// Initializes fields if they are stored previously,
  /// call this method before using any fields from this class
  init() async {
    languagePreferred = await _getPreferredLanguage();
    themePreferred = await _getPreferredTheme();
  }

  Future<void> setPreferredLanguage(String currentLanguage) async {
    await serviceLocator
        .get<SharedPrefsStorage<String>>()
        .save(currentLanguage);
    languagePreferred = currentLanguage;
  }

  Future<void> setIsDarkThemePreferred(bool isDarkThemePreferred) async {
    await serviceLocator
        .get<SharedPrefsStorage<bool>>()
        .save(isDarkThemePreferred);
    themePreferred = isDarkThemePreferred == true
        ? ThemeChangeNotifier.darkTheme()
        : ThemeChangeNotifier.lightTheme();
  }

  Future<String> _getPreferredLanguage() async {
    final systemLocale = WidgetsBinding.instance!.window.locales.first;
    final storedLanguageCode =
        await serviceLocator.get<SharedPrefsStorage<String>>().get();

    return storedLanguageCode == null
        ? systemLocale.languageCode
        : storedLanguageCode;
  }

  Future<ThemeChangeNotifier> _getPreferredTheme() async {
    final bool? storedThemeMode =
        await serviceLocator.get<SharedPrefsStorage<bool>>().get();

    if (storedThemeMode == null) return ThemeChangeNotifier.lightTheme();
    return storedThemeMode == true
        ? ThemeChangeNotifier.darkTheme()
        : ThemeChangeNotifier.lightTheme();
  }
}
