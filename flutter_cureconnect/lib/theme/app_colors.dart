import 'package:flutter/material.dart';

class AppColors {
  // Base Colors
  static const Color background = Color(0xFF000000);
  static const Color card = Color(0xFF0D0D0D);
  static const Color cardBorder = Color(0xFF1F1F1F);
  static const Color secondary = Color(0xFF1A1A1A);
  
  // Primary Gradient
  static const Color primaryMint = Color(0xFF00D9A5);
  static const Color primaryCyan = Color(0xFF00C4D9);
  
  // Medical Blue
  static const Color medicalBlue = Color(0xFF007BFF);
  
  // Status Colors
  static const Color success = Color(0xFF22C55E);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  
  // Text Colors
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFA1A1AA);
  static const Color textMuted = Color(0xFF71717A);
  
  // Gradient
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryMint, primaryCyan],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
  
  static const LinearGradient sosGradient = LinearGradient(
    colors: [Color(0xFFEF4444), Color(0xFFDC2626)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
