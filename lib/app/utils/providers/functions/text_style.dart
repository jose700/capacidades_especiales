import 'package:capacidades_especiales/app/utils/providers/fuente_providers.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

TextStyle selectedTextStyle(BuildContext context, Color textColor) {
  final selectedFont = Provider.of<FontSelectionModel>(context).selectedFont;

  // Intenta obtener la fuente de Google Fonts
  try {
    return GoogleFonts.getFont(selectedFont,
        textStyle: TextStyle(color: textColor));
  } catch (_) {
    // Si la fuente no está disponible en Google Fonts, utiliza una fuente desde los activos (assets)
    return TextStyle(
      fontFamily:
          'multi', // Reemplaza 'TuFuenteDesdeAssets' con el nombre real de tu fuente desde assets
      color: textColor,
      // Puedes configurar otras propiedades de estilo aquí, como el tamaño de la fuente y el peso, según tus necesidades.
    );
  }
}
