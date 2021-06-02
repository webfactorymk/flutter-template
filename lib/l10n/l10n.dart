import 'package:flutter/material.dart';

class L10n {
  static final all = [
    const Locale('en'),
    const Locale('mk'),
  ];

  static Locale getLocale(String code) {
    switch (code) {
      case 'en':
        return all[0];
      case 'mk':
        return all[1];
      default:
        return all[0];
    }
  }
}
