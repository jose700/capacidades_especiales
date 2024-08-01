import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<bool> sesionGuard(BuildContext context) async {
  // Suponiendo que estás usando SharedPreferences para obtener tokens
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final tokens = prefs.getString('tokens');

  if (tokens != null && tokens.isNotEmpty) {
    return true; // Si existen tokens, permite el acceso
  } else {
    Navigator.pushReplacementNamed(context,
        '/home'); // Si no existen tokens, redirige a la pantalla de inicio
    return false;
  }
}
