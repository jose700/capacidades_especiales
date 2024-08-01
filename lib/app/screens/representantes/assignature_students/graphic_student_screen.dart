import 'package:capacidades_especiales/app/models/seguimientos-academicos/materias/approved_assignatura_model.dart';
import 'package:capacidades_especiales/app/screens/representantes/assignature_students/chart_asignaturas_aprobadas_screen.dart';
import 'package:capacidades_especiales/app/screens/representantes/assignature_students/chart_asignaturas_reprobadas_screen.dart';
import 'package:flutter/material.dart';
import 'package:capacidades_especiales/app/models/representantes/student_data_model.dart';
import 'package:capacidades_especiales/app/models/tutor/login_model.dart';
import 'package:capacidades_especiales/app/services/representante/service_representantes.dart';
import 'package:capacidades_especiales/app/utils/resources/app_colors.dart';

class GraphisScreenStudent extends StatefulWidget {
  final String usuarioRepresentante;
  final Sesion sesion;

  GraphisScreenStudent(this.usuarioRepresentante, this.sesion);

  @override
  _GraphisScreenStudentState createState() => _GraphisScreenStudentState();
}

class _GraphisScreenStudentState extends State<GraphisScreenStudent> {
  DatosEstudiante? _datosEstudiante;
  bool _isLoading = true;
  bool _showAprobadas = true;

  @override
  void initState() {
    super.initState();
    _cargarDatosEstudiante();
  }

  Future<void> _cargarDatosEstudiante() async {
    try {
      DatosEstudiante datosEstudiante = await ServicioRepresentante()
          .obtenerEstudiantePorUsuarioRepresentante(
              widget.usuarioRepresentante, widget.sesion.token);

      setState(() {
        _datosEstudiante = datosEstudiante;
        _isLoading = false;
      });
    } catch (e) {
      print('Error al cargar datos del estudiante: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Gráficos de asiganturas'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _datosEstudiante != null
              ? SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _showAprobadas = true;
                              });
                            },
                            child: Text('Materias Aprobadas'),
                          ),
                          SizedBox(width: 20),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _showAprobadas = false;
                              });
                            },
                            child: Text('Materias Reprobadas'),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      buildMateriasSection(
                          _datosEstudiante!.materias, _showAprobadas),
                    ],
                  ),
                )
              : Center(
                  child:
                      Text('No se pudieron cargar los datos del estudiante')),
    );
  }

  Widget buildMateriasSection(
      List<MateriaAprobada> materias, bool showAprobadas) {
    List<MateriaAprobada> filteredMaterias = showAprobadas
        ? materias.where((materia) => materia.aprobado ?? false).toList()
        : materias.where((materia) => !(materia.aprobado ?? false)).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (filteredMaterias.isNotEmpty)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                showAprobadas ? 'Materias Aprobadas:' : 'Materias Reprobadas:',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: showAprobadas
                      ? AppColors.contentColorGreen
                      : AppColors.contentColorRed,
                ),
              ),
              SizedBox(height: 10),
              SizedBox(height: 20),
              showAprobadas
                  ? GraficoCalificaciones(filteredMaterias)
                  : GraficoPromedioFinal(filteredMaterias),
            ],
          ),
      ],
    );
  }
}
