import 'package:flutter/material.dart';

class AppColors {
  static const Color primaryColor = Color(0xFF1E3A5F); // Azul oscuro
  static const Color secondaryColor = Color(0xFFFFC107); // Amarillo dorado
  static const Color accentColor = Color(0xFF17A2B8); // Verde azulado
  static const Color backgroundColor = Color(0xFFFFFFFF); // Blanco
  static const Color textColor = Color(0xFF6C757D); // Gris
}

ThemeData getTheme() => ThemeData(
      useMaterial3: true,
      // Colores principales
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: AppColors.primaryColor,
        onPrimary: AppColors.backgroundColor, // Texto sobre primary
        secondary: AppColors.secondaryColor,
        onSecondary: AppColors.backgroundColor, // Texto sobre secondary
        background: AppColors.backgroundColor,
        onBackground: AppColors.textColor, // Texto sobre background
        surface: AppColors.backgroundColor,
        onSurface: AppColors.textColor, // Texto sobre superficie
        error: Colors.red,
        onError: AppColors.backgroundColor, // Texto sobre error
      ),
      scaffoldBackgroundColor: AppColors.backgroundColor,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.primaryColor,
        foregroundColor: AppColors.backgroundColor, // Texto en la AppBar
        titleTextStyle: TextStyle(
          color: AppColors.backgroundColor,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: IconThemeData(color: AppColors.backgroundColor),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          color: AppColors.primaryColor,
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
        bodyLarge: TextStyle(
          color: AppColors.textColor,
          fontSize: 16,
        ),
        bodyMedium: TextStyle(
          color: AppColors.textColor,
          fontSize: 14,
        ),
        labelLarge: TextStyle(
          color: AppColors.backgroundColor,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.secondaryColor,
          foregroundColor: AppColors.backgroundColor,
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.accentColor,
        foregroundColor: AppColors.backgroundColor,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.backgroundColor,
        border: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.primaryColor),
          borderRadius: BorderRadius.circular(8.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.primaryColor, width: 2.0),
          borderRadius: BorderRadius.circular(8.0),
        ),
        labelStyle: TextStyle(color: AppColors.textColor),
      ),
    );
