import 'package:flutter/material.dart';

class AppTheme {
  static final Color _primaryColor = Color.fromRGBO(221, 25, 11, 1.0);
  static final Color _lightBgColor = Colors.white;
  static final Color _darkBgColor = Colors.grey[300]!;

  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    colorScheme: ColorScheme.light(
      primary: _primaryColor,
      surface: _lightBgColor,
    ),
    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: Colors.black, fontSize: 16),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(
      primary: _primaryColor,
      surface: _darkBgColor,
    ),
    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: Colors.white, fontSize: 16),
    ),
  );
}
