// lib/utils/theme.dart

import 'package:flutter/material.dart';

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: Colors.tealAccent,
  scaffoldBackgroundColor: Color(0xFF121212),
  appBarTheme: AppBarTheme(
    color: Color(0xFF1F1F1F),
  ),
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.tealAccent,
    brightness: Brightness.dark,
    primary: Colors.tealAccent,
    secondary: Colors.amberAccent, // Replaces accentColor
  ),
  textTheme: TextTheme(
    bodyLarge: TextStyle(color: Colors.white70),   // Replaces bodyText1
    bodyMedium: TextStyle(color: Colors.white60),  // Replaces bodyText2
  ),
);