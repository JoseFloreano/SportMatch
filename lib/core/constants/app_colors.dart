import 'package:flutter/material.dart';

abstract class AppColors {
  // Paleta principal SportMatch
  static const volt        = Color(0xFFC8FF00); // Verde eléctrico — acento principal
  static const voltDark    = Color(0xFF9DCA00); // Verde acento oscuro
  static const ink         = Color(0xFF0E1117); // Negro deportivo
  static const inkMid      = Color(0xFF2A2F3A);
  static const slate       = Color(0xFF4A5260);
  static const mist        = Color(0xFFEEF0F4); // Fondo de cards
  static const white       = Color(0xFFFFFFFF);
  static const teal        = Color(0xFF00B4A0); // Verificado
  static const tealLight   = Color(0xFFE0F7F5);
  static const red         = Color(0xFFE8393A); // Alertas / RX level
  static const redLight    = Color(0xFFFEF0F0);
  static const amber       = Color(0xFFF5A623); // Eventos patrocinados
  static const amberLight  = Color(0xFFFEF6E7);
  static const green       = Color(0xFF27AE60); // Beginner / éxito
  static const greenLight  = Color(0xFFE8F8EE);
  static const purple      = Color(0xFF7C3AED); // Modo solo mujeres
  static const purpleLight = Color(0xFFF0EAFF);
  static const border      = Color(0xFFDDE1E8);

  // Semánticos
  static const levelRx       = red;
  static const levelScaled   = amber;
  static const levelBeginner = green;
  static const eventColor    = amber;
  static const womenMode     = purple;
  static const verified      = teal;

  static ThemeData get lightTheme => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: ink,
          primary: ink,
          secondary: volt,
          surface: white,
          error: red,
        ),
        scaffoldBackgroundColor: mist,
      );
}
