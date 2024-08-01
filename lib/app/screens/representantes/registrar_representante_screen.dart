import 'package:capacidades_especiales/app/models/estudiantes/student_model.dart';
import 'package:capacidades_especiales/app/models/representantes/representative_model.dart';
import 'package:capacidades_especiales/app/models/tutor/login_model.dart';
import 'package:capacidades_especiales/app/services/estudiante/service_estudiantes.dart';
import 'package:capacidades_especiales/app/services/representante/service_representantes.dart';
import 'package:capacidades_especiales/app/widgets/tutor/Home/messages/dialogs/login_message.dart';
import 'package:capacidades_especiales/app/widgets/representantes/agregar_representante_widget.dart';
import 'package:flutter/material.dart';

class RegistroEstudiante extends StatefulWidget {
  final String usuario;
  final Sesion sesion;
  const RegistroEstudiante(
      {Key? key, required this.usuario, required this.sesion})
      : super(key: key);

  @override
  _RegistroEstudianteState createState() => _RegistroEstudianteState();
}

class _RegistroEstudianteState extends State<RegistroEstudiante> {
  final _formKey = GlobalKey<FormState>();
  late Future<List<Estudiante>> estudiantes;
  late Future<List<Representante>> representantes;
  String? _selectedEstudiante;
  final TextEditingController _nombresController = TextEditingController();
  final TextEditingController _apellidosController = TextEditingController();
  final TextEditingController _cedulaController = TextEditingController();
  final TextEditingController _correoController = TextEditingController();
  final TextEditingController _estadoCivilController = TextEditingController();
  final TextEditingController _ocupacionController = TextEditingController();
  final TextEditingController _numberphoneController = TextEditingController();
  final TextEditingController _usuarioController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final ServicioEstudiante servicioEstudiante = ServicioEstudiante();
  final ServicioRepresentante servicioRepresentante = ServicioRepresentante();
  @override
  void initState() {
    super.initState();
    estudiantes = fetchEstudiantes();
  }

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

  void _showErrorSnackbar() {
    Dialogs.showSnackbarError(context, 'Error al guardar el registro');
  }

  void _showSuccessSnackbar() {
    Dialogs.showSnackbar(context, 'Se ha registrado al representante');
  }

  String? requiredValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Este campo es obligatorio';
    }
    return null;
  }

  String? emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Este campo es obligatorio';
    }
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value)) {
      return 'Ingrese un correo electrónico válido';
    }
    return null;
  }

  String? cedulaValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Este campo es obligatorio';
    }
    if (!RegExp(r'^\d+$').hasMatch(value)) {
      return 'Ingrese solo números';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Agregar representantes')),
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
                            prefixIcon: Icon(Icons.people),
                            labelText: 'Seleccione Estudiante'),
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
                const SizedBox(height: 20),
                RegistroFormulario(
                    nombresController: _nombresController,
                    apellidosController: _apellidosController,
                    cedulaController: _cedulaController,
                    correoController: _correoController,
                    estadoCivilController: _estadoCivilController,
                    ocupacionController: _ocupacionController,
                    numberphoneController: _numberphoneController,
                    nombresValidator: requiredValidator,
                    apellidosValidator: requiredValidator,
                    cedulaValidator: cedulaValidator,
                    correoValidator: emailValidator,
                    estadoCivilValidator: requiredValidator,
                    ocupacionValidator: requiredValidator,
                    numberphoneValidator: requiredValidator,
                    usuarioController: _usuarioController,
                    passController: _passController),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState?.validate() ?? false) {
                      final representante = Representante(
                          idrepresentante: 1, // Ajustar según sea necesario
                          idestudiante: int.parse(_selectedEstudiante!),
                          usuariotutor: widget.usuario,
                          nombres: _nombresController.text,
                          apellidos: _apellidosController.text,
                          cedula: _cedulaController.text,
                          correo: _correoController.text,
                          estadocivil: _estadoCivilController.text,
                          ocupacion: _ocupacionController.text,
                          imagen: '',
                          numberphone: _numberphoneController.text,
                          usuario: _usuarioController.text,
                          pass: _passController.text,
                          rol: 'representante');

                      try {
                        // Si la cédula no está en uso, guardar el representante
                        await servicioRepresentante.crearRepresentante(
                            representante, widget.sesion.token);
                        // Show success Snackbar after successful save
                        _showSuccessSnackbar();
                      } catch (error) {
                        // Show error Snackbar if an error occurs during the process
                        _showErrorSnackbar();
                      }
                    }
                  },
                  child: const Text('Guardar'),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
