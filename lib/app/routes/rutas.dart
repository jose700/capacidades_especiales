import 'dart:convert';

import 'package:capacidades_especiales/app/models/estudiantes/playing/palabras/words_model.dart';
import 'package:capacidades_especiales/app/screens/estudiantes/game/Rompe_Cabezas/page/select_image_rompecabezas_screen.dart';
import 'package:capacidades_especiales/app/screens/estudiantes/game/abecedario/abecedario_screen.dart';
import 'package:capacidades_especiales/app/screens/estudiantes/game/animals/pages/animals_screen.dart';
import 'package:capacidades_especiales/app/screens/estudiantes/game/days/days_screen.dart';
import 'package:capacidades_especiales/app/screens/estudiantes/game/fruits/fruits_screen.dart';
import 'package:capacidades_especiales/app/screens/estudiantes/game/memory/category_memory.dart';
import 'package:capacidades_especiales/app/screens/estudiantes/game/months/months_screen.dart';
import 'package:capacidades_especiales/app/screens/estudiantes/game/numbers/numbers_screen.dart';
import 'package:capacidades_especiales/app/screens/estudiantes/game/painter/painter_screen.dart';
import 'package:capacidades_especiales/app/screens/estudiantes/game/my_tasks/my_asignatures_screen.dart';
import 'package:capacidades_especiales/app/screens/estudiantes/game/palabras/list_words_screen.dart';
import 'package:capacidades_especiales/app/screens/estudiantes/page/login_students_screen.dart';
import 'package:capacidades_especiales/app/widgets/tutor/Home/home.dart';
import 'package:capacidades_especiales/app/models/tutor/login_model.dart';
import 'package:capacidades_especiales/app/widgets/representantes/home_representante/representante_home.dart';
import 'package:flutter/material.dart';
import 'package:capacidades_especiales/app/screens/tutor/login_screen.dart';
import 'package:capacidades_especiales/app/screens/tutor/register_screen.dart';
import 'package:flutter/services.dart';

Sesion? sesion;

Future<List<WordItem>> loadWords() async {
  final String response =
      await rootBundle.loadString('assets/json/words_data.json');
  final List<dynamic> data = json.decode(response);
  return data.map((json) => WordItem.fromJson(json)).toList();
}

Map<String, WidgetBuilder> getRoutes() {
  return {
    '/': (context) => const LoginScreen(),
    '/login': (context) => const LoginScreen(),
    '/register': (context) => const RegisterScreen(),
    '/students': (context) => const LoginStudentScreen(),
    '/home': (context) =>
        HomeScreen(sesion: sesion!), // Asegúrate de pasar sesion aquí
    '/representante': (context) => RepresentanteScreen(sesion: sesion!),
    '/abecedario': (context) => AlphabetScreen(),
    '/pintar': (context) => PainterScreen(),
    '/numeros': (context) => NumbersScreen(),
    '/frutas': (context) => FruitsScreen(),
    '/dias_semana': (context) => DaysScreen(),
    '/palabras': (context) => WordListScreen(wordsFuture: loadWords()),
    '/memory': (context) => CategorySelectionScreen(),
    '/meses_año': (context) => MonthsScreen(),
    '/mis_tareas': (context) => MateriasEstudianteScreen(sesion: sesion!),
    '/animals': (context) => AnimalScreen(),
    '/rompecabezas': (context) => RompeCabezasScreen(),
    '/detalle': (context) => RompeCabezasScreen(),
  };
}
