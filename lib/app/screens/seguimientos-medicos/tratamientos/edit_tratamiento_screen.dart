import 'package:capacidades_especiales/app/models/estudiantes/student_model.dart';
import 'package:capacidades_especiales/app/models/seguimientos-medicos/tratamientos/treatment_model.dart';
import 'package:capacidades_especiales/app/models/tutor/login_model.dart';
import 'package:capacidades_especiales/app/services/estudiante/service_estudiantes.dart';

import 'package:capacidades_especiales/app/services/seguimientos-medicos/tratamiento/service_tratamiento.dart';
import 'package:flutter/material.dart';
import 'package:capacidades_especiales/app/widgets/tutor/Home/messages/dialogs/login_message.dart';

class EditarTratamientoScreen extends StatefulWidget {
  final Tratamiento tratamiento;
  final Sesion sesion;
  const EditarTratamientoScreen(this.tratamiento,
      {Key? key, required this.sesion})
      : super(key: key);

  @override
  _ActualizarTratamientoScreenState createState() =>
      _ActualizarTratamientoScreenState();
}

class _ActualizarTratamientoScreenState extends State<EditarTratamientoScreen> {
  final ServicioTratamiento _servicioTratamiento = ServicioTratamiento();

  late final Tratamiento tratamiento;
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _TipoCapacidadController;
  late TextEditingController _DescripcionTratamientoController;
  late TextEditingController _OpinionPacienteController;
  late TextEditingController _TratamientoPsicologicoController;
  late TextEditingController _TratamientoFisicoController;
  late TextEditingController _DuracionTratamientoController;
  late TextEditingController _ResultadoController;

  String? _selectedEstudiante;
  late Future<List<Estudiante>> estudiantes;
  final ServicioEstudiante servicioEstudiante = ServicioEstudiante();

  bool cambiosRealizados = false;

  @override
  void initState() {
    super.initState();
    _selectedEstudiante = widget.tratamiento.idestudiante.toString();
    tratamiento = widget.tratamiento;
    estudiantes = fetchEstudiantes();
    _TipoCapacidadController =
        TextEditingController(text: tratamiento.clasediscapacidad);
    _DescripcionTratamientoController =
        TextEditingController(text: tratamiento.descripcionconsulta);
    _OpinionPacienteController =
        TextEditingController(text: tratamiento.opinionpaciente);
    _TratamientoPsicologicoController =
        TextEditingController(text: tratamiento.tratamientopsicologico);
    _TratamientoFisicoController =
        TextEditingController(text: tratamiento.tratamientofisico);
    _DuracionTratamientoController =
        TextEditingController(text: tratamiento.duraciontratamiento);
    _ResultadoController = TextEditingController(text: tratamiento.resultado);
  }

  Future<List<Estudiante>> fetchEstudiantes() async {
    try {
      final fetchedEstudiantes =
          await servicioEstudiante.obtenerEstudiantesTutor(
              tratamiento.usuariotutor, widget.sesion.token);
      return fetchedEstudiantes;
    } catch (e) {
      _showErrorSnackbar();
      return [];
    }
  }

  void _showErrorSnackbar() {
    Dialogs.showSnackbarError(context, 'Error al actualizar el tratamiento');
  }

  void _showSuccessSnackbar() {
    Dialogs.showSnackbar(context, 'Tratamiento actualizado correctamente');
  }

  String? requiredValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Este campo es obligatorio';
    }
    return null;
  }

  @override
  void dispose() {
    _TipoCapacidadController.dispose();
    _DescripcionTratamientoController.dispose();
    _OpinionPacienteController.dispose();
    _TratamientoPsicologicoController.dispose();
    _TratamientoFisicoController.dispose();
    _ResultadoController.dispose();
    super.dispose();
  }

  Future<void> updatedTratamiento() async {
    if (_formKey.currentState!.validate()) {
      Tratamiento updateTratamiento = Tratamiento(
        idtratamiento: tratamiento.idtratamiento,
        idestudiante: int.parse(_selectedEstudiante!),
        usuariotutor: widget.tratamiento.usuariotutor,
        clasediscapacidad: _TipoCapacidadController.text,
        descripcionconsulta: _DescripcionTratamientoController.text,
        opinionpaciente: _OpinionPacienteController.text,
        tratamientopsicologico: _TratamientoPsicologicoController.text,
        tratamientofisico: _TratamientoFisicoController.text,
        duraciontratamiento: _DuracionTratamientoController.text,
        resultado: _ResultadoController.text,
        fechaconsulta: DateTime.now(),
      );
      try {
        await _servicioTratamiento.actualizarTratamiento(
            tratamiento.idtratamiento!, updateTratamiento, widget.sesion.token);
        _showSuccessSnackbar(); // Mostrar mensaje de éxito
      } catch (e) {
        _showErrorSnackbar(); // Mostrar mensaje de error si falla la actualización
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Actualizar tratamiento'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const SizedBox(height: 20),
              FutureBuilder<List<Estudiante>>(
                future: estudiantes,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Text('No hay estudiantes disponibles');
                  } else {
                    final estudiantes = snapshot.data!;
                    return DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                          labelText: 'Seleccione estudiante',
                          prefixIcon: Icon(Icons.people)),
                      items: estudiantes
                          .map((es) => DropdownMenuItem(
                                value: es.idestudiante.toString(),
                                child: Text('Datos: '
                                    '${es.nombres} ${es.apellidos} Cédula: ${es.cedula}'),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedEstudiante = value;
                        });
                      },
                      validator: requiredValidator,
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                      ),
                      dropdownColor: Theme.of(context).scaffoldBackgroundColor,
                    );
                  }
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _TipoCapacidadController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese la Clase de Discapacidad';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'Clase de Discapacidad',
                  hintText: 'Por favor ingrese la Clase de Discapacidad',
                  prefixIcon: const Icon(Icons.accessibility),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _OpinionPacienteController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese la opinión del paciente';
                  }
                  return null;
                },
                maxLines: null,
                decoration: InputDecoration(
                  labelText: 'Opinión del Paciente',
                  hintText: 'Por favor ingrese la opinión del paciente',
                  prefixIcon: const Icon(Icons.comment),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _DescripcionTratamientoController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingresa la descripción de tratamiento';
                  }
                  return null;
                },
                maxLines: null,
                decoration: InputDecoration(
                  labelText: 'Descripción del Tratamiento',
                  hintText: 'Por favor ingrese la descripción de la consulta',
                  prefixIcon: const Icon(Icons.description),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _TratamientoPsicologicoController,
                maxLines: null,
                decoration: InputDecoration(
                  labelText: 'Ingrese el tratamiento Psicológico',
                  hintText: 'Ingrese el tratamiento Psicológico',
                  prefixIcon: const Icon(Icons.description),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _TratamientoFisicoController,
                decoration: InputDecoration(
                  labelText: 'Tratamiento Físico',
                  hintText: 'Ingrese el tratamiento Físico',
                  prefixIcon: const Icon(Icons.fitness_center_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                maxLines: null,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _DuracionTratamientoController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingresa la descripción de tratamiento';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'Duración del Tratamiento',
                  hintText: 'Por favor ingrese la duración del tratamiento',
                  prefixIcon: const Icon(Icons.timer),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _ResultadoController,
                decoration: InputDecoration(
                  labelText: 'Resultado',
                  hintText: 'Por favor ingrese el resultado',
                  prefixIcon: const Icon(Icons.trending_up),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  updatedTratamiento();
                },
                child: const Text('Actualizar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
