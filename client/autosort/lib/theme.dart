import 'package:autosort/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppColors {
  static late Color pageBackground;

  // initialize once
  static void loadTheme({required bool isDark}) {
    if (isDark) {
      pageBackground = const Color.fromARGB(255, 0, 0, 0); // dark background
    } else {
      pageBackground = const Color(0xFFFCFCFC); // light background
    }
  }

  static const Color primaryBackground = Color(0xFFF5F5F5); // Light gray
  static const Color secondaryBackground = Color(0xFFE0E0E0);
  // static const Color greyBackground = Color(0xFFE0E0E0);

  // text color
  
  static const Color primaryText = Color(0xFF212121); // Dark gray
  static const Color secondaryText = Color(0xFF757575);

  //card colors
  static const Color cardBackground = Colors.white;
  static const Color cardBorder = Color.fromARGB(67, 0, 0, 0);
  static const Color cardShadow = Color.fromARGB(28, 0, 0, 0);

  //semantic colors
  static const Color deleteBtn = Colors.red;
  static const Color deleteBtnHover = Color.fromARGB(255, 209, 43, 31);

  //chart colors
  static const List<Color> chartPalette = [
    Color(0xFF2563EB),
    Color.fromARGB(255, 234, 53, 53),
    Color(0xFF16A34A),
    Color(0xFFF59E0B),
    Color(0xFF9333EA),
    Color.fromARGB(255, 234, 113, 8),
  ];

  // Sub-text
  static const Color sidebarSelected = Color(
    0xFF212121,
  ); // Selected sidebar item
  static const Color sidebarUnselected = Colors.black;
  static const Color white = Colors.white;
  // New additions

  static const Color iconBackground = Color(0xFFE3E3E3);
  static const Color iconColor = Colors.black;
  static const Color buttonBackground = Colors.black;
  static const Color buttonText = Colors.white;
  static const Color buttonHover = Color.fromARGB(255, 20, 20, 20);
  static const Color divider = Color(0xFFBDBDBD);
}

//---------------------------------------------------------------
// class AppColors {
//   static const Color pageBackground = Color(0xFFFCFCFC);
//   static const Color primaryBackground = Color(0xFFF5F5F5); // Light gray
//   static const Color secondaryBackground = Color(0xFFE0E0E0);
//   // static const Color greyBackground = Color(0xFFE0E0E0);

//   // text color
//   static const Color primaryText = Color(0xFF212121); // Dark gray
//   static const Color secondaryText = Color(0xFF757575);

//   //card colors
//   static const Color cardBackground = Colors.white;
//   static const Color cardBorder = Color.fromARGB(67, 0, 0, 0);
//   static const Color cardShadow = Color.fromARGB(28, 0, 0, 0);

//   //semantic colors
//   static const Color deleteBtn = Colors.red;
//   static const Color deleteBtnHover = Color.fromARGB(255, 209, 43, 31);

//   //chart colors
//   static const List<Color> chartPalette = [
//     Color(0xFF2563EB),
//     Color.fromARGB(255, 234, 53, 53),
//     Color(0xFF16A34A),
//     Color(0xFFF59E0B),
//     Color(0xFF9333EA),
//     Color.fromARGB(255, 234, 113, 8),
//   ];

//   // Sub-text
//   static const Color sidebarSelected = Color(
//     0xFF212121,
//   ); // Selected sidebar item
//   static const Color sidebarUnselected = Colors.black;
//   static const Color white = Colors.white;
//   // New additions

//   static const Color iconBackground = Color(0xFFE3E3E3);
//   static const Color iconColor = Colors.black;
//   static const Color buttonBackground = Colors.black;
//   static const Color buttonText = Colors.white;
//   static const Color buttonHover = Color.fromARGB(255, 20, 20, 20);
//   static const Color divider = Color(0xFFBDBDBD);
// }

// Light theme
final ThemeData lightTheme = ThemeData(
  fontFamily: 'Inter',
  scaffoldBackgroundColor: AppColors.primaryBackground,
  brightness: Brightness.light,
  colorScheme: const ColorScheme.light(
    primary: AppColors.sidebarSelected,
    surface: AppColors.primaryBackground,
    onSurface: AppColors.primaryText,
  ),
  cardTheme: const CardThemeData(
    color: AppColors.white,
    surfaceTintColor: Colors.transparent, // Removes Material3 tint
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: AppColors.primaryText),
    bodyMedium: TextStyle(color: AppColors.primaryText),
  ),
);

// Dark theme
final ThemeData darkTheme = ThemeData(
  fontFamily: 'Inter',
  scaffoldBackgroundColor: Colors.black,
  brightness: Brightness.dark,
  colorScheme: const ColorScheme.dark(
    primary: AppColors.white,
    surface: Colors.black,
    onSurface: AppColors.white,
  ),
  cardTheme: const CardThemeData(
    color: Color(0xFF1E1E1E),
    surfaceTintColor: Colors.transparent,
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: AppColors.white),
    bodyMedium: TextStyle(color: AppColors.white),
  ),
);
