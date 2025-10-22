import 'package:flutter/material.dart';

class AppColors {
  static late Color pageBackground;
  static late Color primaryText;
  static late Color secondaryText;
  static late Color pill;

  //card colors
  static late Color cardBackground;
  static late Color cardBorder;
  static late Color cardShadow;

  // background colors
  static late Color primaryBackground;
  static late Color secondaryBackground;

  // Buttons & icons
  static late Color iconBackground;
  static late Color iconColor;
  static late Color buttonBackground;
  static late Color buttonText;
  static late Color buttonHover;
  static late Color divider;
  // initialize once
  static void loadTheme({required bool isDark}) {
    if (isDark) {
      //  Dark Mode
      pageBackground = const Color.fromARGB(255, 0, 0, 0);
      primaryText = Colors.white;
      secondaryText = const Color(0xFFBDBDBD);

      //🔥alright so you might need to change the card background for this cuz rn it is kind of transparent
      cardBackground = const Color.fromARGB(0, 10, 10, 10); // dark card
      cardBorder = const Color.fromARGB(80, 255, 255, 255);
      cardShadow = const Color.fromARGB(59, 0, 0, 0);

      primaryBackground = const Color(0xFF121212);
      // dark gray background
      secondaryBackground = const Color.fromARGB(255, 30, 30, 30);

      iconBackground = const Color(0xFF2A2A2A);
      iconColor = Colors.white;
      buttonBackground = Colors.white;
      buttonText = Colors.black;
      buttonHover = const Color.fromARGB(255, 231, 231, 231);
      divider = const Color(0xFF424242);
      pill = const Color.fromARGB(255, 22, 22, 22);
    } else {
      //  Light Mode
      pageBackground = const Color(0xFFFCFCFC);
      primaryText = const Color(0xFF212121);
      secondaryText = const Color(0xFF757575);

      cardBackground = Colors.white;
      cardBorder = const Color.fromARGB(67, 0, 0, 0);
      cardShadow = const Color.fromARGB(28, 0, 0, 0);

      primaryBackground = const Color(0xFFF5F5F5);
      secondaryBackground = const Color(0xFFE0E0E0);

      iconBackground = const Color(0xFFE3E3E3);
      iconColor = Colors.black;
      buttonBackground = Colors.black;
      buttonText = Colors.white;
      buttonHover = const Color.fromARGB(255, 20, 20, 20);
      divider = const Color(0xFFBDBDBD);

      pill = Colors.grey.shade200;
    }
  }



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

  // static const Color iconBackground = Color(0xFFE3E3E3);
  // static const Color iconColor = Colors.black;
  // static const Color buttonBackground = Colors.black;
  // static const Color buttonText = Colors.white;
  // static const Color buttonHover = Color.fromARGB(255, 20, 20, 20);
  // static const Color divider = Color(0xFFBDBDBD);
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
  colorScheme: ColorScheme.light(
    primary: AppColors.sidebarSelected,
    surface: AppColors.primaryBackground,
    onSurface: AppColors.primaryText,
  ),
  cardTheme: const CardThemeData(
    color: AppColors.white,
    surfaceTintColor: Colors.transparent, // Removes Material3 tint
  ),
  textTheme: TextTheme(
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
