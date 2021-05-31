import 'dart:core';

import 'package:flutter/material.dart';

class ColorPalette {
  static const Color accent = const Color(0xFF2ED3C6);

  static const Color primaryDark = const Color(0xFF0D141C);
  static const Color primary = const Color(0xFF13326D);
  static const Color primaryLight = const Color(0x8C0D141C);
  static const Color primaryDisabled = const Color(0x3313326D);

  static const Color backgroundLightGreen = const Color(0xFFE2F0F1);
  static const Color backgroundLightGray = const Color(0xFFF5F5F5);
  static const Color backgroundGray = const Color(0xFFD8D8D8);

  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static const Color textGray = const Color(0xFF8E9094);

  ColorPalette._();
}

Color colorFromHex(String code) {
  String colorString = code.replaceAll(new RegExp('#'), '');
  return new Color(int.parse(colorString, radix: 16) + 0xFF000000);
}
