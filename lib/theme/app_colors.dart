import 'package:flutter/material.dart';
import '../models/expense.dart';

class AppColors {
  AppColors._();

  // Light
  static const lightBackground = Color(0xFFF2F5F3);
  static const lightSurface = Color(0xFFFFFFFF);
  static const lightInk = Color(0xFF10241F);
  static const lightInkMuted = Color(0xFF5A6B65);

  // Dark
  static const darkBackground = Color(0xFF0B1512);
  static const darkSurface = Color(0xFF14211D);
  static const darkInk = Color(0xFFEAF2EF);
  static const darkInkMuted = Color(0xFF8FA39C);

  // Shared accents
  static const pulseCoral = Color(0xFFFF6B4A);
  static const pulseCoralDark = Color(0xFFFF7A5C);
  static const deepTeal = Color(0xFF0E7C66);
  static const deepTealDark = Color(0xFF2DBF9E);
  static const danger = Color(0xFFE5484D);
  static const dangerDark = Color(0xFFF2777C);

  static Color categoryColor(ExpenseCategory category) {
    switch (category) {
      case ExpenseCategory.food:
        return deepTeal;
      case ExpenseCategory.transport:
        return const Color(0xFF3D6FE0);
      case ExpenseCategory.bills:
        return pulseCoral;
      case ExpenseCategory.other:
        return const Color(0xFF8B8FA3);
    }
  }
}
