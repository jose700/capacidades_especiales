import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  SharedPreferences? _prefs;

  ThemeMode get themeMode => _themeMode;

  Future<void> loadTheme() async {
    _prefs = await SharedPreferences.getInstance();
    int themeIndex = _prefs?.getInt('theme') ?? 0;
    log("Loaded theme index: $themeIndex");
    _themeMode = ThemeMode.values[themeIndex];
    notifyListeners();
  }

  set themeMode(ThemeMode mode) {
    _themeMode = mode;
    _prefs?.setInt('theme', _themeMode.index);
    notifyListeners();
  }

  Color get _platformDependentColor {
    final Brightness platformBrightness =
        WidgetsBinding.instance.window.platformBrightness;
    final isDarkMode = platformBrightness == Brightness.dark;
    return isDarkMode ? Colors.white : Colors.black;
  }

  Color get iconColor => _themeMode == ThemeMode.light
      ? Colors.black
      : _themeMode == ThemeMode.dark
          ? Colors.white
          : _platformDependentColor;

  Color get tabBarTextColor => _themeMode == ThemeMode.light
      ? Colors.black
      : _themeMode == ThemeMode.dark
          ? Colors.white
          : _platformDependentColor;

  Color get itemColor => _themeMode == ThemeMode.light
      ? Colors.black
      : _themeMode == ThemeMode.dark
          ? Colors.white
          : _platformDependentColor;

  ThemeData get themeData {
    final baseTheme = _themeMode == ThemeMode.light
        ? ThemeData.light()
        : _themeMode == ThemeMode.dark
            ? ThemeData.dark()
            : (WidgetsBinding.instance.window.platformBrightness ==
                    Brightness.dark
                ? ThemeData.dark()
                : ThemeData.light());
    return baseTheme.copyWith(
      scaffoldBackgroundColor: _themeMode == ThemeMode.light
          ? Colors.white
          : _themeMode == ThemeMode.dark
              ? const Color(0xFF222126)
              : (WidgetsBinding.instance.window.platformBrightness ==
                      Brightness.dark
                  ? const Color(0xFF222126)
                  : Colors.white),
      primaryColor: _themeMode == ThemeMode.light
          ? const Color(0xFF222126)
          : _themeMode == ThemeMode.dark
              ? const Color(0xFFFFFFFF)
              : (WidgetsBinding.instance.window.platformBrightness ==
                      Brightness.dark
                  ? const Color(0xFFFFFFFF)
                  : const Color(0xFF222126)),
      appBarTheme: AppBarTheme(
        backgroundColor: _themeMode == ThemeMode.light
            ? Colors.white
            : _themeMode == ThemeMode.dark
                ? const Color.fromARGB(255, 40, 44, 52)
                : (WidgetsBinding.instance.window.platformBrightness ==
                        Brightness.dark
                    ? const Color.fromARGB(255, 40, 44, 52)
                    : Colors.white),
        titleTextStyle: TextStyle(
          color: _themeMode == ThemeMode.light
              ? Colors.black
              : _themeMode == ThemeMode.dark
                  ? Colors.white
                  : (WidgetsBinding.instance.window.platformBrightness ==
                          Brightness.dark
                      ? Colors.white
                      : Colors.black),
        ),
        iconTheme: IconThemeData(color: iconColor),
      ),
      tabBarTheme: TabBarTheme(labelColor: tabBarTextColor),
    );
  }

  Color _getColorWithOpacity(double opacity) {
    final color = _themeMode == ThemeMode.light
        ? Colors.white
        : _themeMode == ThemeMode.dark
            ? Colors.black
            : (WidgetsBinding.instance.window.platformBrightness ==
                    Brightness.dark
                ? Colors.black
                : Colors.white);
    return color.withOpacity(opacity);
  }

  Color get backgroundOpacityColor => _getColorWithOpacity(0.5);

  Color get tbackgroundOpacityColor => _getColorWithOpacity(0.9);

  Color get inputBackgroundOpacityColor => _themeMode == ThemeMode.light
      ? Colors.grey.withOpacity(0.3)
      : _themeMode == ThemeMode.dark
          ? Colors.black.withOpacity(0.3)
          : (WidgetsBinding.instance.window.platformBrightness ==
                  Brightness.dark
              ? Colors.black.withOpacity(0.3)
              : Colors.grey.withOpacity(0.3));

  Color get elevatedButtonColor => _themeMode == ThemeMode.light
      ? Colors.grey.withOpacity(0.5)
      : _themeMode == ThemeMode.dark
          ? Colors.black.withOpacity(0.5)
          : (WidgetsBinding.instance.window.platformBrightness ==
                  Brightness.dark
              ? Colors.black.withOpacity(0.5)
              : Colors.grey.withOpacity(0.5));

  Color get bottomNavigationBarLandscapeLayout => _getColorWithOpacity(0.4);

  // Nuevo método para obtener el color de los TextSpan
  Color get textSpanColor => _themeMode == ThemeMode.light
      ? Colors.black
      : _themeMode == ThemeMode.dark
          ? Colors.white
          : _platformDependentColor;
}
