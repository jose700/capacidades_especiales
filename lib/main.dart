import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:capacidades_especiales/app/utils/providers/theme/responsive_builder.dart';
import 'package:capacidades_especiales/app/utils/providers/theme/theme_builder.dart';
import 'package:capacidades_especiales/app/utils/providers/fuente_providers.dart';
import 'package:capacidades_especiales/app/utils/providers/theme/theme_provider.dart';
import 'package:capacidades_especiales/app/routes/rutas.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  final themeProvider = ThemeProvider();
  await themeProvider.loadTheme();

  final fontSelectionModel = FontSelectionModel();
  await fontSelectionModel.loadSelectedFont();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => themeProvider),
        ChangeNotifierProvider(create: (context) => fontSelectionModel),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    initialization();
  }

  void initialization() async {
    // Inicializa recursos necesarios mientras se muestra la pantalla de carga.
    print('ready in 3...');
    await Future.delayed(const Duration(seconds: 1));
    print('ready in 2...');
    await Future.delayed(const Duration(seconds: 2));
    print('ready in 1...');
    await Future.delayed(const Duration(seconds: 2));
    print('go!');
    FlutterNativeSplash.remove();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));

    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          theme: buildAppTheme(context, themeProvider),
          title: 'Capacidades Especiales',
          debugShowCheckedModeBanner: false,
          initialRoute: '/',
          routes: getRoutes(),
          scrollBehavior: ScrollConfiguration.of(context).copyWith(
            dragDevices: {
              PointerDeviceKind.touch,
              PointerDeviceKind.mouse,
            },
          ),
          builder: (context, child) {
            return ResponsiveBuilder(
              builder: (context, size, deviceType) {
                double textScale = 1.0;

                // Ajusta el factor de escala del texto basado en el tipo de dispositivo
                if (deviceType == DeviceType.mobile) {
                  textScale = 0.85;
                } else if (deviceType == DeviceType.tablet) {
                  textScale = 1.0;
                } else if (deviceType == DeviceType.desktop ||
                    deviceType == DeviceType.web) {
                  textScale = 1.2;
                }

                return MediaQuery(
                  data: MediaQuery.of(context).copyWith(
                    textScaler: TextScaler.linear(textScale),
                  ),
                  child: child!,
                );
              },
            );
          },
        );
      },
    );
  }
}
