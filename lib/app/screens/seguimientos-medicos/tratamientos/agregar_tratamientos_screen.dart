import 'package:capacidades_especiales/app/models/tutor/login_model.dart';
import 'package:capacidades_especiales/app/widgets/tutor/Home/messages/dialogs/login_message.dart';
import 'package:capacidades_especiales/app/models/estudiantes/student_model.dart';

import 'package:capacidades_especiales/app/models/seguimientos-medicos/tratamientos/treatment_model.dart';
import 'package:capacidades_especiales/app/services/estudiante/service_estudiantes.dart';
import 'package:capacidades_especiales/app/services/seguimientos-medicos/tratamiento/service_tratamiento.dart';
import 'package:capacidades_especiales/app/widgets/seguimientos-medicos/tratamientos/tratamiento_form_fields_widget.dart';

import 'package:flutter/material.dart';

class AgregarTratamientosScreen extends StatefulWidget {
  final int idestudiante;
  final int idtratamiento;
  final String usuario;
  final Sesion sesion;
  const AgregarTratamientosScreen({
    Key? key,
    required this.idestudiante,
    required this.usuario,
    required this.idtratamiento,
    required this.sesion,
  }) : super(key: key);

  @override
  _AgregarTratamientoScreenState createState() =>
      _AgregarTratamientoScreenState();
}

class _AgregarTratamientoScreenState extends State<AgregarTratamientosScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _claseDiscapacidad = TextEditingController();
  final TextEditingController _descripcionConsulta = TextEditingController();
  final TextEditingController _tratamientoPsicologico = TextEditingController();
  final TextEditingController _tratamientoFisico = TextEditingController();
  final TextEditingController _opinionPaciente = TextEditingController();
  final TextEditingController _resultado = TextEditingController();
  final TextEditingController _duracionController = TextEditingController();
  final ServicioTratamiento servicioTratamiento = ServicioTratamiento();
  final ServicioEstudiante servicioEstudiante = ServicioEstudiante();
  late Future<List<Estudiante>> estudiantes = fetchEstudiantes();
  DateTime? _fechaConsulta;

  String? _selectedEstudiante;

  Future<List<Estudiante>> fetchEstudiantes() async {
    try {
      final fetchedEstudiantes = await servicioEstudiante
          .obtenerEstudiantesTutor(widget.usuario, widget.sesion.token);
      return fetchedEstudiantes;
    } catch (e) {
      _showErrorSnackbar();
      return [];
    }
  }

  String? requiredValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Este campo es obligatorio';
    }
    return null;
  }

  void _showErrorSnackbar() {
    Dialogs.showSnackbarError(context, 'Error al registrar el tratamiento');
  }

  void _showSuccessSnackbar() {
    Dialogs.showSnackbar(context, 'Se ha creado el tratamiento correctamente');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agregar tratamiento'),
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                FutureBuilder<List<Estudiante>>(
                  future: estudiantes,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Text('No hay estudiantes disponibles');
                    } else {
                      final estudiantes = snapshot.data!;
                      return DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
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
                        dropdownColor:
                            Theme.of(context).scaffoldBackgroundColor,
                      );
                    }
                  },
                ),
                TratamientoFormFields(
                  claseDiscapacidadController: _claseDiscapacidad,
                  descripcionConsultaController: _descripcionConsulta,
                  opinionPacienteController: _opinionPaciente,
                  tratamientoPsicologicoController: _tratamientoPsicologico,
                  tratamientoFisicoController: _tratamientoFisico,
                  duracionController: _duracionController,
                  fechaConsulta: _fechaConsulta,
                  onDateSelected: (DateTime) {},
                  resultado: _resultado,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      // Formulario válido, proceder a crear el tratamiento
                      Tratamiento nuevoTratamiento = Tratamiento(
                        idtratamiento: widget.idtratamiento,
                        idestudiante: int.parse(_selectedEstudiante!),
                        usuariotutor: widget.usuario,
                        clasediscapacidad: _claseDiscapacidad.text,
                        descripcionconsulta: _descripcionConsulta.text,
                        fechaconsulta: _fechaConsulta ?? DateTime.now(),
                        opinionpaciente: _opinionPaciente.text,
                        tratamientopsicologico: _tratamientoPsicologico.text,
                        tratamientofisico: _tratamientoFisico.text,
                        duraciontratamiento: _duracionController.text,
                        resultado: _resultado.text,
                      );

                      try {
                        await servicioTratamiento.crearTratamiento(
                            nuevoTratamiento, widget.sesion.token);
                        _showSuccessSnackbar(); // Cerrar la pantalla de agregar tratamiento después de guardar
                      } catch (error) {
                        _showErrorSnackbar(); // Mostrar un mensaje de error en caso de que falle la creación del tratamiento
                      }
                    }
                  },
                  child: const Text('Guardar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
