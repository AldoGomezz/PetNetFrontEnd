import 'package:flutter/material.dart';
import 'colors_custom.dart';

class AppTheme {
  ThemeData getLightTheme() => ThemeData(
        // useMaterial3: true,
        //primaryColor: ColorsCustom.primary,
        brightness: Brightness.light,
        scaffoldBackgroundColor: ColorsCustom.lightBackground,
        colorScheme: const ColorScheme.light(
          primary: ColorsCustom.primary,
          secondary: ColorsCustom.secondary,
          tertiary: ColorsCustom.tertiary,
        ),
        appBarTheme: const AppBarTheme(
          color: ColorsCustom.primary,
          foregroundColor: Colors.white,
        ),
      );

  /* ThemeData getDarkTheme() => ThemeData(
        // useMaterial3: true,
        //primaryColor: ColorsCustom.primary,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: ColorsCustom.darkBackground,
        colorScheme: const ColorScheme.dark(
          primary: ColorsCustom.darkPrimary,
          //secondary: ColorsCustom.secondary,
        ),
        appBarTheme: const AppBarTheme(
          color: ColorsCustom.darkPrimary,
          foregroundColor: Colors.white,
        ),
        snackBarTheme: const SnackBarThemeData(
          backgroundColor: Colors.black87,
          contentTextStyle: TextStyle(color: Colors.white),
        ),
      ); */

  static Brightness currentSystemBrightness(BuildContext context) =>
      MediaQuery.platformBrightnessOf(context);
}

// Servirá para obtener los colores por tema
extension ThemeExtras on ThemeData {
  Color get textColor => brightness == Brightness.light
      ? ColorsCustom.lightText
      : ColorsCustom.darkText;

  Color get subTextBoxColor =>
      brightness == Brightness.light ? Colors.black54 : Colors.white70;

  Color get textReadOnlyColor =>
      brightness == Brightness.light ? Colors.grey[600]! : Colors.grey[500]!;

  Color get tbReadOnlyColor =>
      brightness == Brightness.light ? Colors.grey[200]! : Colors.grey[800]!;

  Color get errorAlertColor => brightness == Brightness.light
      ? Colors.red[100]!
      : Colors.redAccent[200]!;

  Color get textboxColor => brightness == Brightness.light
      ? ColorsCustom.lightLoginBox
      : ColorsCustom.darkLoginBox;
}
