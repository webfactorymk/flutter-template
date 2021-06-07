import 'package:flutter/material.dart';
import 'package:flutter_template/resources/localization/l10n.dart';

class LocalizationNotifier extends ChangeNotifier {
  late Locale _locale;
  Locale get locale => _locale;

  LocalizationNotifier(String storedLanguageCode) {
    _locale = L10n.getLocale(storedLanguageCode);
  }

  void setLocale(String languageCode) {
    _locale = L10n.getLocale(languageCode);
    notifyListeners();
  }

  void clearLocale() {
    _locale = L10n.getLocale('en');
    notifyListeners();
  }
}
