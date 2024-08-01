import 'package:flutter/material.dart';
import 'package:capacidades_especiales/app/utils/providers/functions/text_style.dart';
import 'package:capacidades_especiales/app/utils/providers/theme/theme_provider.dart';

double responsiveTextSize(BuildContext context, double baseSize) {
  double screenWidth = MediaQuery.of(context).size.width;

  // Ajustar el tamaño base según el tipo de dispositivo
  if (screenWidth >= 1200) {
    // Desktop
    return baseSize *
        (screenWidth /
            1200.0); // Ajusta el divisor según el diseño base para escritorio
  } else if (screenWidth >= 800) {
    // Tablet
    return baseSize *
        (screenWidth /
            800.0); // Ajusta el divisor según el diseño base para tabletas
  } else {
    // Mobile
    return baseSize * (screenWidth / 375.0); // Diseño base para móviles
  }
}

ThemeData buildAppTheme(BuildContext context, ThemeProvider themeProvider) {
  double baseTextSize = 16.0; // Tamaño base del texto.
  final textStyle =
      selectedTextStyle(context, themeProvider.iconColor).copyWith(
    fontSize: responsiveTextSize(context, baseTextSize),
  );

  final textTheme = TextTheme(
    bodyLarge: textStyle,
    bodyMedium: textStyle.copyWith(
        fontSize: responsiveTextSize(context, baseTextSize - 2)),
    bodySmall: textStyle.copyWith(
        fontSize: responsiveTextSize(context, baseTextSize - 4)),
  );

  return themeProvider.themeData.copyWith(
    textTheme: textTheme,
    dataTableTheme: DataTableThemeData(
      headingTextStyle:
          textTheme.bodyLarge?.copyWith(color: themeProvider.iconColor),
      dataTextStyle:
          textTheme.bodyMedium?.copyWith(color: themeProvider.iconColor),
    ),
    tabBarTheme: TabBarTheme(
      labelStyle: textTheme.bodyLarge,
      unselectedLabelStyle: textTheme.bodyLarge,
    ),
    appBarTheme: AppBarTheme(
      actionsIconTheme: themeProvider.themeData.iconTheme,
      backgroundColor: themeProvider.themeData.scaffoldBackgroundColor,
      titleTextStyle: textTheme.bodyLarge,
      iconTheme: IconThemeData(
        color: themeProvider.iconColor,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      hintStyle: textTheme.bodyLarge,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      fillColor: themeProvider.inputBackgroundOpacityColor,
      filled: true,
    ),
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
    hintColor: Colors.transparent,
    hoverColor: Colors.transparent,
    dialogTheme: DialogTheme(
      backgroundColor: themeProvider.themeData.cardColor,
      titleTextStyle: textTheme.bodyLarge,
      contentTextStyle: textTheme.bodyMedium,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all<Color>(
            themeProvider.themeData.primaryColorDark),
        foregroundColor: WidgetStateProperty.all<Color>(
            themeProvider.themeData.primaryColorLight),
        textStyle: WidgetStateProperty.all<TextStyle>(textTheme.bodySmall!),
        padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
          const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
        ),
        shape: WidgetStateProperty.all<OutlinedBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
      ),
    ),
    cardTheme: CardTheme(
      color: themeProvider.themeData.cardColor,
      elevation: 4.0, // Ajustar elevación según sea necesario
      margin: EdgeInsets.all(responsiveTextSize(
          context, 8.0)), // Ajustar márgenes según sea necesario
    ),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: themeProvider.iconColor,
      selectionColor: themeProvider.textSpanColor.withOpacity(0.3),
      selectionHandleColor: themeProvider.textSpanColor,
    ),
  );
}
