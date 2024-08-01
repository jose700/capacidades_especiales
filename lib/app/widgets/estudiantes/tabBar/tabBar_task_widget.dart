import 'package:capacidades_especiales/app/models/tutor/login_model.dart';
import 'package:capacidades_especiales/app/screens/estudiantes/game/my_tasks/my_asignatures_screen.dart';
import 'package:capacidades_especiales/app/screens/estudiantes/game/quizz/my_quizz_complet_screen.dart';
import 'package:capacidades_especiales/app/screens/estudiantes/game/quizz/my_quizz_no_complet_screen.dart';

import 'package:flutter/material.dart';

class TabBarTask extends StatelessWidget {
  final Sesion sesion;

  const TabBarTask({Key? key, required this.sesion}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Mis Asignaturas'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          bottom: TabBar(
            isScrollable: true, // Permitir el desplazamiento horizontal
            labelPadding: EdgeInsets.symmetric(horizontal: 10.0),
            tabs: [
              Tab(
                child: Row(
                  children: [
                    Icon(Icons.list_alt), // Icono para la primera pestaña
                    SizedBox(width: 5), // Espacio entre el icono y el texto
                    Text('Lista de asignaturas'),
                  ],
                ),
              ),
              Tab(
                child: Row(
                  children: [
                    Icon(Icons
                        .check_box_outlined), // Icono para la segunda pestaña
                    SizedBox(width: 5), // Espacio entre el icono y el texto
                    Text('Cuestionarios completados'),
                  ],
                ),
              ),
              Tab(
                child: Row(
                  children: [
                    Icon(Icons.cancel), // Icono para la segunda pestaña
                    SizedBox(width: 5), // Espacio entre el icono y el texto
                    Text('Cuestionarios no completados'),
                  ],
                ),
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          physics:
              NeverScrollableScrollPhysics(), // Evitar el desplazamiento vertical
          child: SizedBox(
            height: MediaQuery.of(context).size.height -
                kToolbarHeight -
                kBottomNavigationBarHeight -
                MediaQuery.of(context).padding.top,
            child: TabBarView(
              children: [
                MateriasEstudianteScreen(
                  sesion: sesion,
                ),
                MyQuizzEstudianteScreen(
                  sesion: sesion,
                ),
                MyQuizzNoCompleteEstudianteScreen(
                  sesion: sesion,
                ),
                // Placeholder para la tercera pestaña
              ],
            ),
          ),
        ),
      ),
    );
  }
}
