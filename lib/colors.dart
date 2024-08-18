import 'package:flutter/material.dart';

const Color primaryColor = Color(0xFF454587);

const Color backgroundColor = Color(0xFFFFFFFF);

ThemeData applicationTheme() {
  return ThemeData(
    primaryColor: primaryColor,
    scaffoldBackgroundColor: backgroundColor,
    appBarTheme: AppBarTheme(
      backgroundColor: primaryColor,
      elevation: 0
    )
  );
}