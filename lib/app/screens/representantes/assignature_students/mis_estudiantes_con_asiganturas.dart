import 'package:capacidades_especiales/app/models/tutor/login_model.dart';
import 'package:capacidades_especiales/app/services/representante/service_representantes.dart';
import 'package:capacidades_especiales/app/widgets/representantes/my_students/estudiante_asignaturas_widget.dart';
import 'package:capacidades_especiales/app/widgets/representantes/my_students/mi_estudiante_widget.dart';
import 'package:flutter/material.dart';
import 'package:capacidades_especiales/app/models/representantes/student_data_model.dart';
import 'package:flutter_flip_card/flipcard/gesture_flip_card.dart';
import 'package:flutter_flip_card/modal/flip_side.dart';

class MiEstudianteScreen extends StatefulWidget {
  final String usuarioRepresentante;
  final Sesion sesion;
  MiEstudianteScreen(this.usuarioRepresentante, this.sesion);

  @override
  _MiEstudianteScreenState createState() => _MiEstudianteScreenState();
}

class _MiEstudianteScreenState extends State<MiEstudianteScreen> {
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
        title: const Text('Datos del Estudiante'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _datosEstudiante != null
              ? SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureFlipCard(
                        // Utiliza GestureFlipCard para la tarjeta principal
                        animationDuration: const Duration(milliseconds: 300),
                        axis: FlipAxis.horizontal,
                        frontWidget: EstudianteDetailsWidget(_datosEstudiante!),

                        backWidget: EstudianteDetailsWidget(_datosEstudiante!),
                      ),
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
                      _showAprobadas
                          ? buildMateriasSection(_datosEstudiante!.materias
                              .where((materia) => materia.aprobado == true)
                              .toList())
                          : buildMateriasSection(_datosEstudiante!.materias
                              .where((materia) => materia.aprobado == false)
                              .toList()),
                    ],
                  ),
                )
              : Center(
                  child: Text('No se pudo cargar los datos del estudiante')),
    );
  }
}
