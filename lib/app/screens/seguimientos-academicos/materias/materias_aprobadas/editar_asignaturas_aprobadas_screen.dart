import 'package:capacidades_especiales/app/models/tutor/login_model.dart';
import 'package:flutter/material.dart';
import 'package:capacidades_especiales/app/models/estudiantes/student_model.dart';
import 'package:capacidades_especiales/app/models/seguimientos-academicos/materias/approved_assignatura_model.dart';
import 'package:capacidades_especiales/app/models/seguimientos-academicos/materias/assignature_model.dart';
import 'package:capacidades_especiales/app/services/estudiante/service_estudiantes.dart';
import 'package:capacidades_especiales/app/services/seguimientos-academicos/inscripcion/inscripcion_materia_service.dart';
import 'package:capacidades_especiales/app/services/seguimientos-academicos/materia/materia_aprobada_service.dart';
import 'package:capacidades_especiales/app/services/seguimientos-academicos/materia/materia_reprobada_service.dart';
import 'package:capacidades_especiales/app/services/seguimientos-academicos/materia/materia_service.dart';
import 'package:capacidades_especiales/app/widgets/tutor/Home/messages/dialogs/login_message.dart';

class EditarMateriasAprobadasScreen extends StatefulWidget {
  final MateriaAprobada aprobado;
  final Sesion sesion;
  const EditarMateriasAprobadasScreen(this.aprobado,
      {Key? key, required this.sesion})
      : super(key: key);
  @override
  _AgregarMateriasAprobadasScreenState createState() =>
      _AgregarMateriasAprobadasScreenState();
}

class _AgregarMateriasAprobadasScreenState
    extends State<EditarMateriasAprobadasScreen> {
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
    _selectedEstudiante = widget.aprobado.idestudiante.toString();
    _selectedMateria = widget.aprobado.idmateria.toString();
    // Inicializar los controladores con los datos actuales de la materia aprobada
    _calificacion1Controller.text = widget.aprobado.calificacion1.toString();
    _calificacion2Controller.text = widget.aprobado.calificacion2.toString();
    _asistenciaController.text = widget.aprobado.asistencia.toString();
    _observacionController.text = widget.aprobado.observacion;
    _aprobado = widget.aprobado.aprobado ?? false;
    ;

    materias = fetchMaterias();
    estudiantes = fetchEstudiantes();
  }

  Future<List<Materia>> fetchMaterias() async {
    try {
      final fetchMaterias = await servicioMateria.obtenerMateriasTutor(
          widget.aprobado.usuarioTutor.toString(), widget.sesion.token);
      return fetchMaterias;
    } catch (e) {
      _showErrorSnackbar();
      return [];
    }
  }

  Future<List<Estudiante>> fetchEstudiantes() async {
    try {
      final fetchEstudiantes = await servicioEstudiante.obtenerEstudiantesTutor(
          widget.aprobado.usuarioTutor.toString(), widget.sesion.token);
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
        title: Text('Editar materia aprobada'),
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
                      return IgnorePointer(
                        ignoring: true, // Deshabilita la selección
                        child: DropdownButtonFormField<String>(
                          value: _selectedEstudiante,
                          decoration: InputDecoration(
                              labelText: 'Estudiante',
                              prefixIcon: Icon(Icons.people)),
                          items: estudiantesList.map((estudiante) {
                            return DropdownMenuItem<String>(
                              value: estudiante.idestudiante.toString(),
                              child: Text(
                                  'Datos:${estudiante.nombres} ${estudiante.apellidos} Cédula: ${estudiante.cedula}'),
                            );
                          }).toList(),
                          onChanged: (value) async {
                            // No se ejecutará porque el Dropdown está deshabilitado
                            setState(() {
                              _selectedEstudiante = value;
                              materias =
                                  servicioMateria.obtenerMateriasPorEstudiante(
                                      value!, widget.sesion.token);
                              _selectedMateria = null;
                            });
                          },
                          validator: requiredValidator,
                          style: TextStyle(
                            color: Theme.of(context).textTheme.bodyLarge?.color,
                          ),
                          dropdownColor:
                              Theme.of(context).scaffoldBackgroundColor,
                        ),
                      );
                    }
                  },
                ),
                SizedBox(height: 20),
                if (_selectedEstudiante != null)
                  IgnorePointer(
                    ignoring: true, // Deshabilita la selección
                    child: FutureBuilder<List<Materia>>(
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
                                labelText: 'Materia ateria',
                                prefixIcon: Icon(Icons.assignment)),
                            items: materiasList.map((materia) {
                              return DropdownMenuItem<String>(
                                value: materia.idmateria.toString(),
                                child: Text(materia.nombreMateria),
                              );
                            }).toList(),
                            onChanged: (value) {
                              // No se ejecutará porque el Dropdown está deshabilitado
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
                  ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _calificacion1Controller,
                  decoration: InputDecoration(
                      labelText: 'Calificación 1',
                      prefixIcon: Icon(Icons.calculate_sharp)),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  validator: requiredValidator,
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _calificacion2Controller,
                  decoration: InputDecoration(
                      labelText: 'Calificación 2',
                      prefixIcon: Icon(Icons.calculate_sharp)),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
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
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _editarMateriaAprobada();
                      }
                    },
                    child: Text('Actualizar'),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _editarMateriaAprobada() async {
    // Construir el objeto de materia aprobada/reprobada
    MateriaAprobada aprobada = MateriaAprobada(
      idaprobada: widget.aprobado.idaprobada,
      idestudiante: int.parse(_selectedEstudiante!),
      idmateria: int.parse(_selectedMateria!),
      usuarioTutor: widget.aprobado.usuarioTutor,
      calificacion1: double.parse(_calificacion1Controller.text),
      calificacion2: double.parse(_calificacion2Controller.text),
      promedioFinal: (double.parse(_calificacion1Controller.text) +
              double.parse(_calificacion2Controller.text)) /
          2,
      asistencia: int.parse(_asistenciaController.text),
      observacion: _observacionController.text,
      fecha: DateTime.now(),
      aprobado: _aprobado,
      // Añadir otros campos según sea necesario
    );

    try {
      if (_aprobado) {
        await _materiaAprobadaService.actualizarMateriaAprobada(
            widget.aprobado.idaprobada ?? 0, aprobada, widget.sesion.token);
      } else {
        await _materiaReprobadaService.actualizarMateriaReprobada(
            widget.aprobado.idreprobada ?? 0, aprobada, widget.sesion.token);
      }
      _limpiarCampos();
      Dialogs.showSnackbar(context, 'Materia actualizada correctamente');
    } catch (e) {
      print('Error al actualizar materia: $e');
      Dialogs.showSnackbarError(context, 'Error al actualizar materia');
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
