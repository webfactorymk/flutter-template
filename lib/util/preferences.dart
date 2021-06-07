import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:single_item_shared_prefs/single_item_shared_prefs.dart';

const String preferredLocalizationKey = 'preferred-language';

void saveCurrentLanguage(String currentLanguage) async {
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

  return storedLanguageCode == null ? systemLocale.languageCode : storedLanguageCode;
}
