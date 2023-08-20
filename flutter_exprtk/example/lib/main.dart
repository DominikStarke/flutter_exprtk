import 'package:exprtk_example/calculator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_exprtk/flutter_exprtk.dart';

Future<String> loadAsset(BuildContext context) async {
  final data = await rootBundle
      .loadString('packages/flutter_exprtk_web/assets/flutter_exprtk.js');
  return data;
}

void main() {
  init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  ThemeData configureTheme (ThemeData theme) {
    return theme.copyWith(
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(theme.colorScheme.secondary),
          foregroundColor: MaterialStateProperty.all(theme.colorScheme.onSecondary),
          textStyle: MaterialStateProperty.all(TextStyle(
            fontSize: 24
          ))
        )
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = Colors.teal;

    final ThemeData darkTheme = ThemeData.from(
      colorScheme: ColorScheme.fromSeed(
        seedColor: themeColor,
        brightness: Brightness.dark
      )
    );

    final lightTheme = ThemeData.from(
      colorScheme: ColorScheme.fromSeed(
        seedColor: themeColor,
        brightness: Brightness.light
      )
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'exprtk calculator',
      theme: configureTheme(lightTheme),
      darkTheme: configureTheme(darkTheme),
      home: SafeArea(
        child: Material(
          child: Calculator(),
        ),
      ),
    );
  }
}
