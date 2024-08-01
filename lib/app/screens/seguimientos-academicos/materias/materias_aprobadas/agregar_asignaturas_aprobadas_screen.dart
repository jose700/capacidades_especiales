import 'package:capacidades_especiales/app/models/estudiantes/student_model.dart';
import 'package:capacidades_especiales/app/models/seguimientos-academicos/materias/approved_assignatura_model.dart';
import 'package:capacidades_especiales/app/models/seguimientos-academicos/materias/assignature_model.dart';
import 'package:capacidades_especiales/app/models/tutor/login_model.dart';
import 'package:capacidades_especiales/app/services/estudiante/service_estudiantes.dart';
import 'package:capacidades_especiales/app/services/seguimientos-academicos/inscripcion/inscripcion_materia_service.dart';
import 'package:capacidades_especiales/app/services/seguimientos-academicos/materia/materia_aprobada_service.dart';
import 'package:capacidades_especiales/app/services/seguimientos-academicos/materia/materia_reprobada_service.dart';
import 'package:capacidades_especiales/app/services/seguimientos-academicos/materia/materia_service.dart';
import 'package:capacidades_especiales/app/widgets/tutor/Home/messages/dialogs/login_message.dart';
import 'package:flutter/material.dart';

class AgregarMateriasAprobadasScreen extends StatefulWidget {
  final String usuario;
  final int idaprobada;
  final Sesion sesion;

  const AgregarMateriasAprobadasScreen({
    Key? key,
    required this.usuario,
    required this.idaprobada,
    required this.sesion,
  }) : super(key: key);

  @override
  _AgregarMateriasAprobadasScreenState createState() =>
      _AgregarMateriasAprobadasScreenState();
}

class _AgregarMateriasAprobadasScreenState
    extends State<AgregarMateriasAprobadasScreen> {
  final MateriaAprobadaService _materiaAprobadaService =
      MateriaAprobadaService();
  final MateriaReprobadaService _materiaReprobadaService =
      MateriaReprobadaService();
  TextEditingController _calificacion1Controller = TextEditingController();
  TextEditingController _calificacion2Controller = TextEditingController();
  TextEditingController _asistenciaController = TextEditingController();
  TextEditingController _observacionController = TextEditingController();
  final ServicioInscripcionMateria servicioInscripcionMateria =
      ServicioInscripcionMateria();
  final ServicioMateria servicioMateria = ServicioMateria();
  final ServicioEstudiante servicioEstudiante =
      ServicioEstudiante(); // Servicio para estudiantes

  late Future<List<Materia>> materias;
  late Future<List<Estudiante>> estudiantes; // Futuro para obtener estudiantes

  final _formKey = GlobalKey<FormState>();
  String? _selectedEstudiante;
  String? _selectedMateria;
  bool _aprobado = false; // Variable para manejar el estado del switch

  @override
  void initState() {
    super.initState();
    materias = fetchMaterias();
    estudiantes = fetchEstudiantes();
  }

  Future<List<Materia>> fetchMaterias() async {
    try {
      final fetchMaterias = await servicioMateria.obtenerMateriasTutor(
          widget.usuario, widget.sesion.token);
      return fetchMaterias;
    } catch (e) {
      _showErrorSnackbar();
      return [];
    }
  }

  Future<List<Estudiante>> fetchEstudiantes() async {
    try {
      final fetchEstudiantes = await servicioEstudiante.obtenerEstudiantesTutor(
          widget.usuario, widget.sesion.token);
      return fetchEstudiantes;
    } catch (e) {
      _showErrorSnackbar();
      return [];
    }
  }

  void _showErrorSnackbar() {
    Dialogs.showSnackbarError(context,
        'Error, Ya existe una materia aprobada/u reprobada con los mismos datos');
  }

  String? requiredValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Este campo es obligatorio';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Agregar estudiantes con materias aprobadas'),
          elevation: 0.0,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FutureBuilder<List<Estudiante>>(
                    future: estudiantes,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Text('No hay estudiantes disponibles');
                      } else {
                        final estudiantesList = snapshot.data!;
                        return DropdownButtonFormField<String>(
                          value: _selectedEstudiante,
                          decoration: InputDecoration(
                              labelText: 'Seleccione estudiante',
                              prefixIcon: Icon(Icons.people)),
                          items: estudiantesList.map((estudiante) {
                            return DropdownMenuItem<String>(
                              value: estudiante.idestudiante.toString(),
                              child: Text(
                                  ' Datos: ${estudiante.nombres} ${estudiante.apellidos} Cédula:${estudiante.cedula}'),
                            );
                          }).toList(),
                          onChanged: (value) async {
                            setState(() {
                              _selectedEstudiante = value;
                              // Llamar al servicio para obtener materias por estudiante
                              materias =
                                  servicioMateria.obtenerMateriasPorEstudiante(
                                      value!, widget.sesion.token);
                              // Reiniciar la selección de materia al cambiar de estudiante
                              _selectedMateria = null;
                            });
                          },
                          validator: requiredValidator,
                          style: TextStyle(
                            color: Theme.of(context).textTheme.bodyLarge?.color,
                          ),
                          dropdownColor:
                              Theme.of(context).scaffoldBackgroundColor,
                        );
                      }
                    },
                  ),
                  SizedBox(height: 20),
                  if (_selectedEstudiante != null)
                    FutureBuilder<List<Materia>>(
                      future: materias,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return Text(
                              'No hay materias disponibles para este estudiante');
                        } else {
                          final materiasList = snapshot.data!;
                          return DropdownButtonFormField<String>(
                            value: _selectedMateria,
                            decoration: InputDecoration(
                                labelText: 'Seleccione materia',
                                prefixIcon: Icon(Icons.assignment)),
                            items: materiasList.map((materia) {
                              return DropdownMenuItem<String>(
                                value: materia.idmateria.toString(),
                                child: Text(materia.nombreMateria),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedMateria = value;
                              });
                            },
                            validator: requiredValidator,
                            style: TextStyle(
                              color:
                                  Theme.of(context).textTheme.bodyLarge?.color,
                            ),
                            dropdownColor:
                                Theme.of(context).scaffoldBackgroundColor,
                          );
                        }
                      },
                    ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _calificacion1Controller,
                    decoration: InputDecoration(
                        labelText: 'Calificación 1',
                        prefixIcon: Icon(Icons.calculate_sharp)),
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                    validator: requiredValidator,
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _calificacion2Controller,
                    decoration: InputDecoration(
                        labelText: 'Calificación 2',
                        prefixIcon: Icon(Icons.calculate_sharp)),
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                    validator: requiredValidator,
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _asistenciaController,
                    decoration: InputDecoration(
                        labelText: 'Asistencia',
                        prefixIcon: Icon(Icons.assignment)),
                    keyboardType: TextInputType.number,
                    validator: requiredValidator,
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _observacionController,
                    decoration: InputDecoration(
                        labelText: 'Observación',
                        prefixIcon: Icon(Icons.description)),
                    keyboardType: TextInputType.text,
                    maxLines: null,
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('¿El estudiante aprobó?'),
                      Row(
                        children: [
                          Text(
                            _aprobado ? 'Sí' : 'No',
                          ),
                          Switch(
                            value: _aprobado,
                            onChanged: (bool value) {
                              setState(() {
                                _aprobado = value;
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 20.0),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _agregarMateriaAprobada();
                        }
                      },
                      child: Text('Guardar datos'),
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }

  void _agregarMateriaAprobada() async {
    // Crear objeto MateriaAprobada
    MateriaAprobada nuevaMateria = MateriaAprobada(
      idaprobada: widget.idaprobada,
      idestudiante: int.parse(_selectedEstudiante!),
      idmateria: int.parse(_selectedMateria!),
      usuarioTutor: widget.usuario,
      calificacion1: double.parse(_calificacion1Controller.text),
      calificacion2: double.parse(_calificacion2Controller.text),
      promedioFinal: (double.parse(_calificacion1Controller.text) +
              double.parse(_calificacion2Controller.text)) /
          2,
      asistencia: int.parse(_asistenciaController.text),
      observacion: _observacionController.text,
      fecha: DateTime.now(),
      aprobado: _aprobado, // Aquí se asigna directamente el valor de _aprobado
    );

    try {
      // Llamar al servicio correspondiente según el valor de _aprobado
      if (_aprobado) {
        await _materiaAprobadaService.crearMateria(
            nuevaMateria, widget.sesion.token);
        Dialogs.showSnackbar(context, 'Materia aprobada creada correctamente');
      } else {
        await _materiaReprobadaService.crearMateriaReprobada(
            nuevaMateria, widget.sesion.token);
        Dialogs.showSnackbar(context, 'Materia reprobada creada correctamente');
      }

      // Limpiar los campos después de guardar
      _limpiarCampos();
    } catch (e) {
      _showErrorSnackbar();
    }
  }

  void _limpiarCampos() {
    _calificacion1Controller.clear();
    _calificacion2Controller.clear();
    _asistenciaController.clear();
    _observacionController.clear();
    setState(() {
      _aprobado = false; // Reiniciamos el switch a falso después de guardar
    });
  }
}
