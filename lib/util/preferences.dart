import 'package:flutter/material.dart';
import 'package:flutter_template/resources/theme/theme_change_notifier.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:single_item_shared_prefs/single_item_shared_prefs.dart';

const String preferredLocalizationKey = 'preferred-language';
const String preferredThemeMode = 'preferred-theme-mode';

void setCurrentLanguage(String currentLanguage) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  SharedPrefsStorage<String> storage = SharedPrefsStorage<String>.primitive(
      itemKey: preferredLocalizationKey, sharedPreferences: prefs);
  storage.save(currentLanguage);
}

Future<String> getStoredLanguage() async {
  final systemLocale = WidgetsBinding.instance!.window.locales.first;
  SharedPreferences prefs = await SharedPreferences.getInstance();
  SharedPrefsStorage<String> storage = SharedPrefsStorage.primitive(
      itemKey: preferredLocalizationKey, sharedPreferences: prefs);
  final storedLanguageCode = await storage.get();

  return storedLanguageCode == null
      ? systemLocale.languageCode
      : storedLanguageCode;
}

void setIsDarkThemePreferred(bool isDarkThemePreferred) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  SharedPrefsStorage<bool> storage = SharedPrefsStorage<bool>.primitive(
      itemKey: preferredThemeMode, sharedPreferences: prefs);
  storage.save(isDarkThemePreferred);
}

Future<ThemeChangeNotifier> getPreferredTheme() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  SharedPrefsStorage<bool> storage = SharedPrefsStorage<bool>.primitive(
      itemKey: preferredThemeMode, sharedPreferences: prefs);
  final bool? storedThemeMode = await storage.get();

  if (storedThemeMode == null) return ThemeChangeNotifier.lightTheme();
  return storedThemeMode == true
      ? ThemeChangeNotifier.darkTheme()
      : ThemeChangeNotifier.lightTheme();
}
