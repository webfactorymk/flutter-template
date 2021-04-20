import 'package:flutter/material.dart';
import 'color_palette.dart';

class AppTheme {
  // TBD. This is a sample code
  static ThemeData light() => ThemeData(
      brightness: Brightness.light,
      primaryColor: ColorPalette.primary,
      accentColor: ColorPalette.accent,
      scaffoldBackgroundColor: ColorPalette.backgroundGray,
      cardColor: ColorPalette.white,
      textTheme: TextTheme(
        subtitle1: TextStyle(
          fontWeight: FontWeight.bold,
          color: ColorPalette.primaryLight,
        ),
      ));

  static ThemeData dark() => ThemeData.dark();

  AppTheme._();
}
