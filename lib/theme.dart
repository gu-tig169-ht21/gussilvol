import 'package:flutter/material.dart';

class MasterTheme {
  ThemeData get darkTheme {
    return ThemeData(
        primaryColor: Colors.purple,
        fontFamily: 'TimesNewRoman',
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.purple,
        ),
        buttonTheme: const ButtonThemeData(
          buttonColor: Colors.purple,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.purple,
        ));
  }
}
