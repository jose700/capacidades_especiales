import 'dart:async';
import 'package:capacidades_especiales/app/models/estudiantes/student_model.dart';
import 'package:capacidades_especiales/app/screens/tutor/charts/todas_materias_aprobadas_screen.dart';
import 'package:capacidades_especiales/app/screens/tutor/charts/todas_materias_reprobadas.screen.dart';
import 'package:capacidades_especiales/app/services/estudiante/service_estudiantes.dart';
import 'package:flutter/material.dart';
import 'package:capacidades_especiales/app/models/tutor/login_model.dart';
import 'package:capacidades_especiales/app/widgets/search/no_results_widgets.dart';
import 'package:capacidades_especiales/app/services/seguimientos-academicos/materia/materia_aprobada_service.dart';
import 'package:capacidades_especiales/app/services/seguimientos-academicos/materia/materia_reprobada_service.dart';
import 'package:capacidades_especiales/app/models/seguimientos-academicos/materias/approved_assignatura_model.dart';

class PieChartSample1 extends StatefulWidget {
  final String usuario;
  final Sesion sesion;

  const PieChartSample1({Key? key, required this.usuario, required this.sesion})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => PieChartSample1State();
}

class PieChartSample1State extends State<PieChartSample1> {
  late Future<List<MateriaAprobada>> futureMateriasAprobadas;
  late Future<List<MateriaAprobada>> futureMateriasReprobadas;
  final ServicioEstudiante servicioEstudiante = ServicioEstudiante();
  List<MateriaAprobada> aprobadas = [];
  List<MateriaAprobada> reprobadas = [];
  late Future<List<Estudiante>> estudiantes;
  String? selectedStudent;

  @override
  void initState() {
    super.initState();
    futureMateriasAprobadas = _fetchMateriasAprobadas();
    futureMateriasReprobadas = _fetchMateriasReprobadas();
  }

  Future<List<MateriaAprobada>> _fetchMateriasAprobadas() async {
    try {
      final fetchedMateriasAprobadas = await MateriaAprobadaService()
          .obtenerMateriasAprobadasTutor(widget.usuario, widget.sesion.token);
      print('Materias Aprobadas: $fetchedMateriasAprobadas'); // Debugging
      return fetchedMateriasAprobadas;
    } catch (e) {
      print('Error al obtener las materias aprobadas: $e');
      return [];
    }
  }

  Future<List<MateriaAprobada>> _fetchMateriasReprobadas() async {
    try {
      final fetchedMateriasReprobadas = await MateriaReprobadaService()
          .obtenerMateriasReprobadasTutor(widget.usuario, widget.sesion.token);
      print('Materias Reprobadas: $fetchedMateriasReprobadas'); // Debugging
      return fetchedMateriasReprobadas;
    } catch (e) {
      print('Error al obtener las materias reprobadas: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: Future.wait([futureMateriasAprobadas, futureMateriasReprobadas]),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData ||
            snapshot.data!.any((data) => data.isEmpty)) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [NoTDataWidget()],
            ),
          );
        } else {
          final List<MateriaAprobada> fetchedAprobadas =
              snapshot.data![0] as List<MateriaAprobada>;
          final List<MateriaAprobada> fetchedReprobadas =
              snapshot.data![1] as List<MateriaAprobada>;

          aprobadas = fetchedAprobadas;
          reprobadas = fetchedReprobadas;

          print('Aprobadas: $aprobadas'); // Debugging
          print('Reprobadas: $reprobadas'); // Debugging

          return Scaffold(
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  const SizedBox(height: 40),
                  if (aprobadas.isNotEmpty)
                    Column(
                      children: [
                        Text(
                          'Materias Aprobadas',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 23),
                        GraficoMateriasAprobadas(aprobadas),
                        const SizedBox(height: 40),
                      ],
                    )
                  else
                    Center(child: Text('No hay materias aprobadas.')),
                  if (reprobadas.isNotEmpty)
                    Column(
                      children: [
                        Text(
                          'Materias Reprobadas',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 25),
                        GraficoMateriasReprobadas(reprobadas),
                        const SizedBox(height: 20),
                      ],
                    )
                  else
                    Center(child: Text('No hay materias reprobadas.')),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
