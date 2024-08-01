import 'package:capacidades_especiales/app/models/tutor/login_model.dart';

import 'package:capacidades_especiales/app/screens/estudiantes/game/my_tasks/tasks_students/list_tasks_students_screen.dart';
import 'package:flutter/material.dart';

class TareasScreen extends StatelessWidget {
  final String usuario;
  final int idTutor;
  final Sesion sesion;
  const TareasScreen(
      {Key? key,
      required this.usuario,
      required this.idTutor,
      required this.sesion})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 1,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Tareas'),
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
                    Icon(Icons.list_alt_sharp), // Icono para la primera pestaña
                    SizedBox(width: 5), // Espacio entre el icono y el texto
                    Text('Lista de tareas'),
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
                TareasEstudiantesScreen(usuarioTutor: usuario, sesion: sesion),

                // Placeholder para la tercera pestaña
              ],
            ),
          ),
        ),
      ),
    );
  }
}
