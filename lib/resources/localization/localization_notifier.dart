import 'package:flutter/material.dart';
import 'package:flutter_template/di/service_locator.dart';
import 'package:flutter_template/feature/settings/preferences_helper.dart';
import 'package:flutter_template/resources/localization/l10n.dart';

class LocalizationNotifier extends ChangeNotifier {
  late Locale _locale;

  Locale get locale => _locale;

  LocalizationNotifier(String storedLanguageCode) {
    _locale = L10n.getLocale(storedLanguageCode);
  }

  Future<void> setLocale(String languageCode) async {
    _locale = L10n.getLocale(languageCode);
    await serviceLocator
        .get<PreferencesHelper>()
        .setPreferredLanguage(_locale.languageCode);
    notifyListeners();
  }

  Future<void> clearLocale() async {
    _locale = L10n.getLocale('en');
    await serviceLocator
        .get<PreferencesHelper>()
        .setPreferredLanguage(_locale.languageCode);
    notifyListeners();
  }
}
