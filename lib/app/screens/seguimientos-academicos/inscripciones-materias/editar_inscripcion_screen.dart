import 'package:capacidades_especiales/app/models/estudiantes/student_model.dart';
import 'package:capacidades_especiales/app/models/seguimientos-academicos/materias/assignature_model.dart';
import 'package:capacidades_especiales/app/models/tutor/login_model.dart';
import 'package:capacidades_especiales/app/services/estudiante/service_estudiantes.dart';
import 'package:capacidades_especiales/app/services/seguimientos-academicos/materia/materia_service.dart';
import 'package:capacidades_especiales/app/widgets/tutor/Home/messages/dialogs/login_message.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:capacidades_especiales/app/models/seguimientos-academicos/inscripcion/inscription_assignatura_model.dart';
import 'package:capacidades_especiales/app/services/seguimientos-academicos/inscripcion/inscripcion_materia_service.dart';

class EditarInscripcionScreen extends StatefulWidget {
  final InscripcionMateria inscripcion;
  final Sesion sesion;
  const EditarInscripcionScreen(this.inscripcion,
      {Key? key, required this.sesion})
      : super(key: key);

  @override
  _EditarInscripcionScreenState createState() =>
      _EditarInscripcionScreenState();
}

class _EditarInscripcionScreenState extends State<EditarInscripcionScreen> {
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
  DateTime? _fechaInscripcion;
  String? _selectedEstado; // Inicializar _selectedEstado con un valor válido

  @override
  void initState() {
    super.initState();
    _selectedEstudiante = widget.inscripcion.idEstudiante.toString();
    _selectedMateria = widget.inscripcion.idmateria.toString();
    _fechaInscripcion = widget.inscripcion.fechaInscripcion;
    materias = fetchMaterias();
    estudiantes = fetchEstudiantes();
  }

  Future<List<Materia>> fetchMaterias() async {
    try {
      final fetchMaterias = await servicioMateria.obtenerMateriasTutor(
          widget.inscripcion.usuarioTutor, widget.sesion.token);
      return fetchMaterias;
    } catch (e) {
      _showErrorSnackbar();
      return [];
    }
  }

  Future<List<Estudiante>> fetchEstudiantes() async {
    try {
      final fetchEstudiantes = await servicioEstudiante.obtenerEstudiantesTutor(
          widget.inscripcion.usuarioTutor, widget.sesion.token);
      return fetchEstudiantes;
    } catch (e) {
      _showErrorSnackbar();
      return [];
    }
  }

  void _showErrorSnackbar() {
    Dialogs.showSnackbarError(context,
        'Error al registrar la inscripción, el alumno ya esta inscrito en esa materia');
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
        title: Text('Editar Inscripción Materia'),
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                FutureBuilder<List<Materia>>(
                  future: materias,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Text('No hay materias disponibles');
                    } else {
                      final materiasList = snapshot.data!;
                      return DropdownButtonFormField<String>(
                        value: _selectedMateria,
                        decoration: InputDecoration(
                          labelText: 'Seleccione materia',
                          prefixIcon: Icon(Icons.subject),
                        ),
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
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                        ),
                        dropdownColor:
                            Theme.of(context).scaffoldBackgroundColor,
                      );
                    }
                  },
                ),
                SizedBox(height: 20),
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
                          prefixIcon: Icon(Icons.people),
                        ),
                        items: estudiantesList.map((estudiante) {
                          return DropdownMenuItem<String>(
                            value: estudiante.idestudiante.toString(),
                            child: Text(
                                'Datos: ${estudiante.nombres} ${estudiante.apellidos} Cédula: ${estudiante.cedula}'),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedEstudiante = value;
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
                DropdownButtonFormField<String>(
                  value: _selectedEstado ?? widget.inscripcion.estado,
                  onChanged: (value) {
                    setState(() {
                      _selectedEstado = value;
                    });
                  },
                  items: [
                    DropdownMenuItem(
                      value: 'activo',
                      child: Text('Activo'),
                    ),
                    DropdownMenuItem(
                      value: 'inactivo',
                      child: Text('Inactivo'),
                    ),
                  ],
                  decoration: InputDecoration(
                    labelText: 'Estado',
                    prefixIcon: Icon(Icons.info),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, selecciona el estado';
                    }
                    return null;
                  },
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                  dropdownColor: Theme.of(context).scaffoldBackgroundColor,
                ),
                SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    _selectDate(context);
                  },
                  child: AbsorbPointer(
                    child: TextFormField(
                      controller: TextEditingController(
                        text: _fechaInscripcion != null
                            ? DateFormat('dd-MM-yyyy')
                                .format(_fechaInscripcion!)
                            : '',
                      ),
                      validator: (value) {
                        if (_fechaInscripcion == null) {
                          return 'Por favor, selecciona la fecha de inscripción';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'Fecha de Inscripción',
                        prefixIcon: Icon(Icons.date_range),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      // Actualizar la inscripción con los datos ingresados
                      InscripcionMateria inscripcionActualizada =
                          InscripcionMateria(
                        idinscripcion: widget.inscripcion.idinscripcion,
                        idEstudiante: int.parse(_selectedEstudiante!),
                        idmateria: int.parse(_selectedMateria!),
                        usuarioTutor: widget.inscripcion.usuarioTutor,
                        estado: _selectedEstado!,
                        fechaInscripcion: _fechaInscripcion ?? DateTime.now(),
                        nombreMateria: '', // Ajustar este valor si es necesario
                      );

                      try {
                        await servicioInscripcionMateria.actualizarInscripcion(
                            widget.inscripcion.idinscripcion ?? 0,
                            inscripcionActualizada,
                            widget.sesion.token);
                        Dialogs.showSnackbar(context,
                            'Se ha actualizado la inscripción correctamente');

                        // Puedes redirigir a la pantalla anterior o hacer otra acción aquí
                      } catch (error) {
                        _showErrorSnackbar();
                      }
                    }
                  },
                  child: Text('Guardar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _fechaInscripcion ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _fechaInscripcion) {
      setState(() {
        _fechaInscripcion = picked;
      });
    }
  }
}
