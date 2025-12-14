import 'package:flutter/material.dart';

class AppTheme {
  // Cores Principais
  static const primaryColor = Color(0xFF0F172A); // Azul Quase Preto (Moderno)
  static const accentColor = Color(0xFF3B82F6);  // Azul Vibrante
  static const actionColor = Color(0xFFF59E0B);  // Laranja (Para botões de ação)
  static const backgroundColor = Color(0xFFF8FAFC); // Cinza muito claro (fundo)

  // TEMA CLARO (Light Mode)
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: backgroundColor,
    primaryColor: primaryColor,
    
    // Configuração da Barra Superior (AppBar)
    appBarTheme: const AppBarTheme(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        letterSpacing: 0.5,
      ),
    ),

    // Estilo dos Botões Principais
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: actionColor,
        foregroundColor: Colors.white,
        elevation: 4,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),

    // Estilo dos Ícones e Textos
    iconTheme: const IconThemeData(color: primaryColor),
    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: Color(0xFF334155), fontSize: 16),
      headlineMedium: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
    ),
  );
}