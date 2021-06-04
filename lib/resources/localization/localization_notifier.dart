import 'package:flutter/material.dart';
import 'package:flutter_template/resources/localization/l10n.dart';

class LocalizationNotifier extends ChangeNotifier {
  Locale _locale = L10n.getLocale('en');

  Locale get locale => _locale;

  void setLocale(Locale locale) {
    _locale = locale;
    notifyListeners();
  }

  void clearLocale() {
    _locale = L10n.getLocale('en');
    notifyListeners();
  }
}
