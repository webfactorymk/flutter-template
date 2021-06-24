import 'package:flutter/material.dart';
import '../colors/color_palette.dart';

extension on ThemeData {
  ThemeData setCommonThemeElements() => this.copyWith(
        visualDensity: VisualDensity.adaptivePlatformDensity,
      );
}

ThemeData themeLight() => ThemeData(
    brightness: Brightness.light,
    primaryColor: ColorPalette.primaryL,
    accentColor: ColorPalette.accentL,
    scaffoldBackgroundColor: ColorPalette.backgroundGray,
    cardColor: ColorPalette.white,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: TextButton.styleFrom(
        primary: ColorPalette.black,
        backgroundColor: ColorPalette.accentL,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        primary: ColorPalette.accentL,
      ),
    ),
    textTheme: TextTheme(
      subtitle1: TextStyle(
        fontWeight: FontWeight.bold,
        color: ColorPalette.textGray,
      ),
    )).setCommonThemeElements();

ThemeData themeDark() => ThemeData(
    brightness: Brightness.dark,
    primaryColor: ColorPalette.primaryD,
    accentColor: ColorPalette.accentD,
    scaffoldBackgroundColor: ColorPalette.primaryLightD,
    cardColor: ColorPalette.primaryDisabledD,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: TextButton.styleFrom(
        primary: ColorPalette.black,
        backgroundColor: ColorPalette.accentD,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        primary: ColorPalette.accentD,
      ),
    ),
    textTheme: TextTheme(
      subtitle1: TextStyle(
        fontWeight: FontWeight.bold,
        color: ColorPalette.white,
      ),
    )).setCommonThemeElements();
