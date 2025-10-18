import 'package:flutter/material.dart';

class AppTheme {
  // الثيم الفاتح للتطبيق
  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: Colors.teal,
      scaffoldBackgroundColor: Colors.grey.shade100,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.teal,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  // لو حبيت، ممكن تعمل darkTheme هنا بنفس الفكرة
  static ThemeData get darkTheme {
    return ThemeData.dark().copyWith(
      primaryColor: Colors.teal,
    );
  }
}
