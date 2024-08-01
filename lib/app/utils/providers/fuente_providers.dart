import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FontSelectionModel extends ChangeNotifier {
  String _selectedFont = 'assets/fonts/Muli-Bold.ttf'; // Fuente predeterminada

  String get selectedFont => _selectedFont;

  Future<void> setSelectedFont(String font) async {
    _selectedFont = font;
    notifyListeners();

    // Guardar la fuente seleccionada en shared preferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedFont', font);
  }

  Future<void> loadSelectedFont() async {
    // Cargar la fuente seleccionada desde shared preferences
    final prefs = await SharedPreferences.getInstance();
    final selectedFont = prefs.getString('selectedFont');
    if (selectedFont != null) {
      _selectedFont = selectedFont;
      notifyListeners();
    }
  }
}
