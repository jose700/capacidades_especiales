import 'package:capacidades_especiales/app/models/tutor/login_model.dart';
import 'package:capacidades_especiales/app/screens/seguimientos-academicos/inscripciones-materias/list_inscripcion_asignaturas_screen.dart';
import 'package:capacidades_especiales/app/screens/seguimientos-academicos/materias/list_asignaturas_screen.dart';
import 'package:capacidades_especiales/app/screens/seguimientos-academicos/materias/materias_aprobadas/list_asignaturas_aprobadas_screen.dart';
import 'package:capacidades_especiales/app/screens/seguimientos-academicos/materias/materias_aprobadas/list_asignaturas_reprobadas_screen.dart';
import 'package:flutter/material.dart';

class SeguimientosAcademicos extends StatelessWidget {
  final String usuario;
  final int idTutor;
  final Sesion sesion;

  const SeguimientosAcademicos(
      {Key? key,
      required this.usuario,
      required this.idTutor,
      required this.sesion})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Seguimientos académicos'),
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
                        .people_outline_outlined), // Icono para la segunda pestaña
                    SizedBox(width: 5), // Espacio entre el icono y el texto
                    Text('Inscribir estudiantes'),
                  ],
                ),
              ),
              Tab(
                child: Row(
                  children: [
                    Icon(Icons
                        .check_circle_outline), // Icono para la segunda pestaña
                    SizedBox(width: 5), // Espacio entre el icono y el texto
                    Text('Asignaturas aprobadas'),
                  ],
                ),
              ),
              Tab(
                child: Row(
                  children: [
                    Icon(
                        Icons.cancel_outlined), // Icono para la tercera pestaña
                    SizedBox(width: 5), // Espacio entre el icono y el texto
                    Text('Asignaturas reprobadas'),
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
                ListaAsignaturasScreen(
                  usuario: usuario,
                  sesion: sesion,
                ),
                ListaInscripcionAsignaturasScreen(
                  usuario: usuario,
                  sesion: sesion,
                ),
                ListaAsignaturasAprobadasScreen(
                    sesion: sesion, usuario: usuario),
                ListaAsignaturasReprobadasScreen(
                  usuario: usuario,
                  sesion: sesion,
                ) // Placeholder para la tercera pestaña
              ],
            ),
          ),
        ),
      ),
    );
  }
}
