import 'dart:core';

import 'package:flutter/material.dart';

class ColorPalette {

  // Light Theme
  static const Color primaryL = const Color(0xFF6200EE);
  static const Color primaryDarkL = const Color(0xFF3700B3);
  static const Color primaryLightL = const Color(0xFF9E47FF);
  static const Color primaryDisabledL = const Color(0x336200EE);
  static const Color accentL = const Color(0xFF03DAC6);

  // Dark Theme
  static const Color primaryD = const Color(0xFF121212);
  static const Color primaryDarkD = const Color(0xFF000000);
  static const Color primaryLightD = const Color(0xFF383838);
  static const Color primaryDisabledD = const Color(0x33121212);
  static const Color accentD = const Color(0xFFbb86fc);

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
