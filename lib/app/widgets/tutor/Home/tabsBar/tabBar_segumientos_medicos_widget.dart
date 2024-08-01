import 'package:capacidades_especiales/app/models/tutor/login_model.dart';
import 'package:flutter/material.dart';
import 'package:capacidades_especiales/app/screens/seguimientos-medicos/nocumplidos/list_tratamientos_nocumplidos_screen.dart';
import 'package:capacidades_especiales/app/screens/seguimientos-medicos/cumplidos/list_tratamientos_cumplidos_screen.dart';
import 'package:capacidades_especiales/app/screens/seguimientos-medicos/tratamientos/list_tratamientos_screen.dart';

class SeguimientosMedicos extends StatelessWidget {
  final String usuario;
  final int idTutor;
  final Sesion sesion;
  const SeguimientosMedicos(
      {Key? key,
      required this.usuario,
      required this.idTutor,
      required this.sesion})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Seguimientos médicos'),
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
                    Text('Lista de tratamientos de los estudiantes'),
                  ],
                ),
              ),
              Tab(
                child: Row(
                  children: [
                    Icon(Icons
                        .check_circle_outline), // Icono para la segunda pestaña
                    SizedBox(width: 5), // Espacio entre el icono y el texto
                    Text('Tratamientos cumplidos'),
                  ],
                ),
              ),
              Tab(
                child: Row(
                  children: [
                    Icon(
                        Icons.cancel_outlined), // Icono para la tercera pestaña
                    SizedBox(width: 5), // Espacio entre el icono y el texto
                    Text('Tratamientos no cumplidos'),
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
                ListaTratamientosScreen(usuario: usuario, sesion: sesion),
                ListaTratamientosCumplidosScreen(
                    usuario: usuario, sesion: sesion),
                ListaTratamientosNoCumplidosScreen(
                    sesion: sesion,
                    usuario: usuario), // Placeholder para la tercera pestaña
              ],
            ),
          ),
        ),
      ),
    );
  }
}
