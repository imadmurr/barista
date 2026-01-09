import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get darkTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorSchemeSeed: const Color(0xFF46C2CB),
    fontFamily: 'Roboto',
    scaffoldBackgroundColor: const Color(0xFF050816),
  );
}
