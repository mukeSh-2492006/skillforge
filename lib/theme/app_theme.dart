import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary theme
  static const Color primary = Color(0xFF2563EB);
  static const Color background = Color(0xFFF8FAFC);
  static const Color navy = Color(0xFF1E293B);

  // Text and slate colors
  static const Color slate = Color(0xFF334155);
  static const Color slateDark = Color(0xFF475569);
  static const Color slateMedium = Color(0xFF64748B);
  static const Color slateLight = Color(0xFFE2E8F0);
  static const Color slateVeryLight = Color(0xFFF1F5F9);

  // Blue and indigo
  static const Color blue = Color(0xFF2196F3);
  static const Color blue50 = Color(0xFFEFF6FF);
  static const Color blue100 = Color(0xFFDBEAFE);
  static const Color indigo = Color(0xFF3F51B5);
  static const Color indigo50 = Color(0xFFEEF2FF);
  static const Color indigo100 = Color(0xFFE0E7FF);
  static const Color indigo400 = Color(0xFF818CF8);
  static const Color indigo500 = Color(0xFF6366F1);
  static const Color indigo600 = Color(0xFF4F46E5);
  static const Color indigo900 = Color(0xFF312E81);
  static const Color indigo200 = Color(0xFFA5B4FC);

  // Other background colors
  static const Color greenBackground = Color(0xFFDCFCE7);
  static const Color skyBackground = Color(0xFFE0F2FE);
  static const Color purpleBackground = Color(0xFFF3E8FF);
  static const Color amberBackground = Color(0xFFFEF3C7);
  static const Color orangeBackground = Color(0xFFFFEDD5);

  // Material colors
  static const Color amber = Color(0xFFFFC107);
  static const Color amberDark = Color(0xFFFF8F00);
  static const Color orange = Color(0xFFFF9800);
  static const Color orangeDark = Color(0xFFEF6C00);
  static const Color brown = Color(0xFF795548);
  static const Color cyan = Color(0xFF00BCD4);
  static const Color deepOrange = Color(0xFFFF5722);
  static const Color deepPurple = Color(0xFF673AB7);
  static const Color green = Color(0xFF4CAF50);
  static const Color grey = Color(0xFF9E9E9E);
  static const Color greyLight = Color(0xFFBDBDBD);
  static const Color greyMedium = Color(0xFF757575);
  static const Color greyDark = Color(0xFF616161);
  static const Color lightBlueDark = Color(0xFF0277BD);
  static const Color purple = Color(0xFF9C27B0);
  static const Color red = Color(0xFFF44336);
  static const Color redAccent = Color(0xFFFF5252);
  static const Color teal = Color(0xFF009688);

  // Basic colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color black87 = Color(0xDD000000);
  static const Color transparent = Color(0x00000000);
}

class AppTheme {
  AppTheme._();

  static final ThemeData lightTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.light,
    ),
    useMaterial3: true,
    scaffoldBackgroundColor: AppColors.background,
  );
}
