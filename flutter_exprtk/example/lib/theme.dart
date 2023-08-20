import 'package:flutter/material.dart';

extension ExtCalculatorTheme on ThemeData {
  ThemeData get operatorsButtonTheme => this.copyWith(
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(colorScheme.primary),
        foregroundColor: MaterialStateProperty.all(colorScheme.onPrimary),
        textStyle: MaterialStateProperty.all(TextStyle(
          fontSize: 24
        ))
      )
    )
  );

  ThemeData get specialButtonTheme => this.copyWith(
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(colorScheme.tertiary.withAlpha((255 * .75).round())),
        foregroundColor: MaterialStateProperty.all(colorScheme.onTertiary),
        textStyle: MaterialStateProperty.all(TextStyle(
          fontSize: 24
        ))
      )
    )
  );

  TextStyle get primaryTextInputStyle => TextStyle(
    fontSize: 20,
    color: colorScheme.onSurface
  );

  InputDecoration get primaryTextInputDecoration =>  InputDecoration(
    filled: true,
    fillColor: colorScheme.surface,
    border: InputBorder.none,
    contentPadding: EdgeInsets.all(20.0),
  );
}