import 'package:flutter/material.dart';

class AppProvider extends ChangeNotifier {
  bool _isDarkMode = true;
  Locale _locale = const Locale('en');

  bool get isDarkMode => _isDarkMode;
  Locale get locale => _locale;
  bool get isArabic => _locale.languageCode == 'ar';

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  void setLocale(Locale locale) {
    _locale = locale;
    notifyListeners();
  }

  void toggleLanguage() {
    _locale = _locale.languageCode == 'en' 
        ? const Locale('ar') 
        : const Locale('en');
    notifyListeners();
  }
}

// Theme data for light and dark modes
class AppThemes {
  // Brand Colors - Turquoise Green
  static const Color turquoise = Color(0xFF40E0D0);
  static const Color turquoiseLight = Color(0xFF5FEFE0);
  static const Color turquoiseDark = Color(0xFF2BC4B5);

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xFF000000),
    colorScheme: const ColorScheme.dark(
      primary: turquoise,
      secondary: Color(0xFF00C4D9),
      surface: Color(0xFF0D0D0D),
      surfaceContainerHighest: Color(0xFF1A1A1A),
      onPrimary: Colors.black,
      onSecondary: Colors.black,
      onSurface: Colors.white,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
    ),
  );

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: const Color(0xFFF8FAFB),
    colorScheme: const ColorScheme.light(
      primary: turquoise,
      secondary: Color(0xFF00C4D9),
      surface: Colors.white,
      surfaceContainerHighest: Color(0xFFF0F4F5),
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: Color(0xFF1A1A1A),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
    ),
  );
}
