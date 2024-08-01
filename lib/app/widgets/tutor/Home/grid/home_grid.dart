import 'package:capacidades_especiales/app/models/tutor/login_model.dart';
import 'package:capacidades_especiales/app/screens/tutor/quizz/crud/list_quizz_screen.dart';
import 'package:capacidades_especiales/app/screens/estudiantes/page/list_estudiantes_screen.dart';
import 'package:capacidades_especiales/app/widgets/tutor/Home/grid/AnimatedGridItem.dart';
import 'package:capacidades_especiales/app/widgets/tutor/Home/tabsBar/tabBar_segumientos_academicos_widget.dart';
import 'package:capacidades_especiales/app/widgets/tutor/Home/tabsBar/tabBar_segumientos_medicos_widget.dart';
import 'package:capacidades_especiales/app/screens/representantes/list_representantes_screen.dart';
import 'package:capacidades_especiales/app/widgets/tutor/Home/tabsBar/tabBar_tareas_widget.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decode/jwt_decode.dart';

class HomeGrid extends StatelessWidget {
  final String usuario;
  final Sesion sesion;
  final String token;

  const HomeGrid({
    Key? key,
    required this.usuario,
    required this.sesion,
    required this.token,
  }) : super(key: key);

  Future<int> obtenerIdTutorDesdeToken(String token) async {
    Map<String, dynamic> payload = Jwt.parseJwt(token);
    int? idTutor = payload['idtutor'];
    return idTutor ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<int>(
      future: obtenerIdTutorDesdeToken(token),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return const Center(child: Text('Error al cargar datos'));
        }

        int idTutor = snapshot.data ?? 0;
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.blue,
                  child: Text(
                    sesion.usuario!.isNotEmpty
                        ? sesion.usuario![0].toUpperCase()
                        : '',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Bienvenido: $usuario ${sesion.apellidos ?? ''}',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 2.0,
                    mainAxisSpacing: 2.0,
                    padding: const EdgeInsets.all(2.0),
                    children: [
                      _buildGridItem(
                        context,
                        'Estudiantes con capacidad especial',
                        Icons.accessibility_new,
                        Colors.red, // Color diferente para este ícono
                        idTutor,
                      ),
                      _buildGridItem(
                        context,
                        'Representantes Estudiantes',
                        Icons.group,
                        Colors.green, // Color diferente para este ícono
                        idTutor,
                      ),
                      _buildGridItem(
                        context,
                        'Seguimientos Médicos',
                        Icons.health_and_safety,
                        Colors.orange, // Color diferente para este ícono
                        idTutor,
                      ),
                      _buildGridItem(
                        context,
                        'Seguimientos Académicos',
                        Icons.school,
                        Colors.purple, // Color diferente para este ícono
                        idTutor,
                      ),
                      _buildGridItem(
                        context,
                        'Tareas',
                        Icons.task,
                        Colors.teal, // Color diferente para este ícono
                        idTutor,
                      ),
                      _buildGridItem(
                        context,
                        'Test',
                        Icons.quiz,
                        Colors.blueAccent, // Color diferente para este ícono
                        idTutor,
                      ),
                    ],
                  ),
                ),
                Text(
                  'Trabajo de Titulación © Todos los derechos reservados',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.justify,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _navigateToScreen(BuildContext context, String itemName, int idTutor) {
    if (itemName == 'Estudiantes con capacidad especial') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ListaEstudiantesScreen(
            sesion: sesion,
            usuario: usuario,
            idTutor: idTutor,
          ),
        ),
      );
    } else if (itemName == 'Representantes Estudiantes') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ListaRepresentantesScreen(
            sesion: sesion,
            usuario: usuario,
          ),
        ),
      );
    } else if (itemName == 'Seguimientos Médicos') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SeguimientosMedicos(
            sesion: sesion,
            usuario: usuario,
            idTutor: idTutor,
          ),
        ),
      );
    } else if (itemName == 'Seguimientos Académicos') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SeguimientosAcademicos(
            sesion: sesion,
            usuario: usuario,
            idTutor: idTutor,
          ),
        ),
      );
    } else if (itemName == 'Tareas') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TareasScreen(
            sesion: sesion,
            usuario: usuario,
            idTutor: idTutor,
          ),
        ),
      );
    } else if (itemName == 'Test') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => QuizScreen(
            sesion: sesion,
            idTutor: idTutor,
          ),
        ),
      );
    }
  }

  Widget _buildGridItem(BuildContext context, String itemName,
      IconData iconData, Color iconColor, int idTutor) {
    return AnimatedGridItem(
      onTap: () => _navigateToScreen(context, itemName, idTutor),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 4,
        margin: const EdgeInsets.all(8),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(
                iconData,
                size: 80,
                color: iconColor, // Utiliza el color pasado como parámetro
              ),
              SizedBox(height: 8),
              Flexible(
                child: Center(
                  child: Text(
                    itemName,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.visible, // Muestra todo el texto
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
