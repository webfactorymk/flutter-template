import 'dart:ui';
import 'package:flutter/material.dart';

const EN = const Locale('en');
const MK = const Locale('mk');

class L10n {
  static Locale getLocale(String code) {
    switch (code) {
      case 'mk':
        return MK;
      case 'en':
      default:
        return EN;
    }
  }
}
