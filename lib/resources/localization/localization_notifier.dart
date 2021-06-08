import 'package:flutter/material.dart';
import 'package:flutter_template/resources/localization/l10n.dart';
import 'package:flutter_template/util/preferences.dart';

class LocalizationNotifier extends ChangeNotifier {
  late Locale _locale;

  Locale get locale => _locale;

  LocalizationNotifier(String storedLanguageCode) {
    _locale = L10n.getLocale(storedLanguageCode);
  }

  Future<void> setLocale(String languageCode) async {
    _locale = L10n.getLocale(languageCode);
    await setCurrentLanguage(_locale.languageCode);
    notifyListeners();
  }

  Future<void> clearLocale() async {
    _locale = L10n.getLocale('en');
    await setCurrentLanguage(_locale.languageCode);
    notifyListeners();
  }
}
