import 'package:flutter/material.dart';



class PatientTheme {
  // ===== الألوان الأساسية =====
  static const Color primaryColor = Color(0xFFE91E63);      // وردي غامق (AppBar، أزرار رئيسية)
  static const Color primaryLight = Color(0xFFFFC1E3);      // وردي فاتح (خلفيات، كروت)

  static const Color backgroundColor = Color(0xFFFDE8F0);   // وردي خفيف جداً للخلفية العامة
  static const Color cardColor = Color(0xFFFFE0F2);         // خلفيات الكروت أو الحاويات
  static const Color textPrimary = Color(0xFF880E4F);       // لون الخط الرئيسي (غامق لسهولة القراءة)
  static const Color textSecondary = Color(0xFFAD1457);     // لون الخط الثانوي (العناوين الفرعية)
  static const Color textHint = Color(0xFFCE93D8);          // النصوص التوضيحية أو ال hints
  static const Color iconColor = Color(0xFFE91E63);         // أيقونات متناسقة مع اللون الرئيسي

  static const Color buttonColor = primaryColor;            // أزرار رئيسية
  static const Color buttonTextColor = Colors.white;        // نص الأزرار

  static const Color errorColor = Color(0xFFD50000);        // أخطاء أو تنبيهات

// ===== أمثلة على استخدام الألوان =====
// AppBar          -> primaryColor
// Background      -> backgroundColor
// Cards           -> cardColor
// Icons           -> iconColor
// Primary Text    -> textPrimary
// Secondary Text  -> textSecondary
// Hints / Labels  -> textHint
// Buttons         -> buttonColor + buttonTextColor
// Errors          -> errorColor
}
