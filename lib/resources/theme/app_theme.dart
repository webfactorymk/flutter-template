import 'package:flutter/material.dart';
import '../colors/color_palette.dart';

extension on ThemeData {
  ThemeData setCommonThemeElements() => this.copyWith(
        visualDensity: VisualDensity.adaptivePlatformDensity,
      );
}

ThemeData themeLight() => ThemeData(
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
    )).setCommonThemeElements();

ThemeData themeDark() => ThemeData.dark().setCommonThemeElements();
