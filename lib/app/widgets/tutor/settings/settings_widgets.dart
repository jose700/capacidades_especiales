// settings_widgets.dart

import 'package:capacidades_especiales/app/utils/providers/fuente_providers.dart';
import 'package:capacidades_especiales/app/utils/providers/functions/fuente_dialog.dart';
import 'package:capacidades_especiales/app/widgets/tutor/Home/alert/logout_dialog_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:capacidades_especiales/app/utils/providers/theme/theme_provider.dart';
import 'package:package_info_plus/package_info_plus.dart';

Widget buildThemeSelection(BuildContext context) {
  return Consumer<ThemeProvider>(
    builder: (context, themeProvider, child) {
      return ExpansionTile(
        leading: const Icon(Icons.color_lens),
        title: const Text('Seleccionar tema:'),
        children: [
          buildThemeRadio(context, 'Por defecto del sistema', ThemeMode.system,
              themeProvider),
          buildThemeRadio(
              context, 'Tema Claro', ThemeMode.light, themeProvider),
          buildThemeRadio(
              context, 'Tema Oscuro', ThemeMode.dark, themeProvider),
        ],
      );
    },
  );
}

Widget buildFontSelection(BuildContext context) {
  final List<String> fontOptions = GoogleFonts.asMap().keys.toList();

  if (fontOptions.isEmpty) {
    return SizedBox(); // Si la lista está vacía, no se muestra nada
  } else {
    return ListTile(
      leading: const Icon(Icons.font_download),
      title: const Text('Seleccionar Tipo de Fuente'),
      subtitle: Consumer<FontSelectionModel>(
        builder: (context, fontSelection, child) {
          return Text(fontSelection.selectedFont);
        },
      ),
      onTap: () {
        showFontSelectionDialog(context);
      },
    );
  }
}

Widget buildInfo(BuildContext context, PackageInfo packageInfo) {
  return ExpansionTile(
    leading: const Icon(Icons.info),
    title: Text('Acerca de : ${packageInfo.appName}'),
    children: [
      infoTile('Versión', packageInfo.version),
    ],
  );
}

Future<void> _showLogoutDialog(BuildContext context) async {
  return showLogoutDialog(
      context, () => performLogout(context)); // Llama a la función del diálogo
}

Widget buildLogaut(BuildContext context) {
  return ListTile(
    leading: Icon(Icons
        .exit_to_app), // Icono de cerrar sesión en la misma posición que los demás
    title: Text(
      'Cerrar sesión',
      // Estilo opcional para el texto
    ),
    onTap: () {
      _showLogoutDialog(context);
    },
  );
}

Widget buildThemeRadio(
  BuildContext context,
  String text,
  ThemeMode mode,
  ThemeProvider themeProvider,
) {
  return ListTile(
    title: Row(
      children: [
        Radio(
          value: mode,
          groupValue: themeProvider.themeMode,
          onChanged: (value) {
            themeProvider.themeMode = value as ThemeMode;
          },
        ),
        Text(text),
      ],
    ),
    onTap: () {
      themeProvider.themeMode = mode;
    },
  );
}

Widget infoTile(String title, String subtitle) {
  return ListTile(
    title: Text(title),
    subtitle: Text(subtitle),
  );
}

void showFontSelectionDialog(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => FontSelectionScreen(
        fontOptions: GoogleFonts.asMap().keys.toList(),
        selectedFont: Provider.of<FontSelectionModel>(context).selectedFont,
        onFontSelected: (font) {
          Provider.of<FontSelectionModel>(context, listen: false)
              .setSelectedFont(font);
        },
      ),
    ),
  );
}
