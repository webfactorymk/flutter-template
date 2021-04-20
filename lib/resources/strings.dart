import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_template/resources/string_key.dart';

class Strings {
  final Locale locale;
  final Map<String, dynamic> _localizedValues;
  final Map<String, dynamic> _fallbackValues;

  Strings(this.locale, Map<String, dynamic> localizedValues,
      {Map<String, dynamic> fallbackValues = const {}})
      : _localizedValues = Map.unmodifiable(localizedValues),
        _fallbackValues = Map.unmodifiable(fallbackValues);

  static String localizedString(BuildContext context, StringKey key) {
    return Strings.of(context)!.get(key);
  }

  static String enumName(String enumToString) => enumToString.split(".").last;

  /// Helper method for accessing localizations using an InheritedWidget "of" syntax
  static Strings? of(BuildContext context) {
    return Localizations.of<Strings>(context, Strings);
  }

  static Future<Strings> load(Locale locale, {Locale? fallbackLocale}) async {
    String jsonContent = await rootBundle
        .loadString("assets/locale/i18n_${locale.languageCode}.json");
    Map<String, dynamic> localizedValues = json.decode(jsonContent);
    Map<String, dynamic>? fallbackValues;
    if (fallbackLocale != null) {
      jsonContent = await rootBundle
          .loadString("assets/locale/i18n_${fallbackLocale.languageCode}.json");
      fallbackValues = json.decode(jsonContent);
    }
    return Strings(locale, localizedValues, fallbackValues: fallbackValues ?? {});
  }

  /// Use this method from every widget that needs a localized text
  /// [keyValue] should represent a key that correlates to a string value
  String get(StringKey keyValue) {
    final key = keyValue.toString().split('.').last;
    return _localizedValues[key] ??
        _fallbackValues[key] ??
        new Exception('** $key not found');
  }

  get currentLanguage => locale.languageCode;
}

/// A factory for a set of localized string resources
/// to be loaded by a Localizations widget.
class LocalizedStringsDelegate extends LocalizationsDelegate<Strings> {
  final List<String> supportedLanguageCodes;
  final Locale? fallbackLocale;

  const LocalizedStringsDelegate(this.supportedLanguageCodes,
      {this.fallbackLocale});

  @override
  bool isSupported(Locale locale) =>
      supportedLanguageCodes.contains(locale.languageCode);

  @override
  Future<Strings> load(Locale locale) {
    // todo add locale in memory storage
    // serviceLocator.get<LanguageRequestInterceptor>().languageCode =
    //     locale.languageCode;
    return Strings.load(locale, fallbackLocale: fallbackLocale);
  }

  @override
  bool shouldReload(LocalizedStringsDelegate old) => false;
}
