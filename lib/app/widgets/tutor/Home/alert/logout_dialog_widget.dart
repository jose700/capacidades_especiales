import 'package:capacidades_especiales/app/utils/resources/app_colors.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

Future<void> showLogoutDialog(
    BuildContext context, VoidCallback logoutCallback) async {
  return showAdaptiveDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Cerrar sesión'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('¿Estás seguro de que deseas cerrar sesión?'),
            ],
          ),
        ),
        actions: <Widget>[
          ElevatedButton(
            child: Text('Cancelar'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.contentColorRed,
            ),
            child: Text('Cerrar sesión'),
            onPressed: () {
              logoutCallback(); // Llama a la función de logout proporcionada
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

void performLogout(BuildContext context) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove('token');
  Navigator.pushReplacementNamed(context, '/login');
}
