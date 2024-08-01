import 'dart:io';
import 'package:capacidades_especiales/app/models/tutor/login_model.dart';
import 'package:capacidades_especiales/app/widgets/tutor/Home/messages/dialogs/login_message.dart';
import 'package:capacidades_especiales/app/widgets/tutor/settings/photo/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:capacidades_especiales/app/models/estudiantes/student_model.dart';
import 'package:capacidades_especiales/app/services/estudiante/service_estudiantes.dart';
import 'package:image_picker/image_picker.dart';

import 'package:intl/intl.dart';

class AgregarEstudianteScreen extends StatefulWidget {
  final int idEstudiante;
  final String usuario;
  final int idTutor;
  final Sesion sesion;
  const AgregarEstudianteScreen({
    super.key,
    required this.usuario,
    required this.idEstudiante,
    required this.idTutor,
    required this.sesion,
  });

  @override
  _AgregarEstudianteScreenState createState() =>
      _AgregarEstudianteScreenState();
}

class _AgregarEstudianteScreenState extends State<AgregarEstudianteScreen> {
  final ServicioEstudiante servicioEstudiante = ServicioEstudiante();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nombresController = TextEditingController();
  final TextEditingController _apellidosController = TextEditingController();
  final TextEditingController _cedulaController = TextEditingController();
  final TextEditingController _correoController = TextEditingController();
  final TextEditingController _edadController = TextEditingController();
  DateTime? _fechaNacimiento;
  String? _selectSexo;
  dynamic _selectedImage;
  final picker = ImagePicker();
  int? idestudiante;
  final String rol = "estudiante";

  void _showErrorSnackbar() {
    Dialogs.showSnackbarError(context, 'Error al registrar al estudiante');
  }

  void _onImageSelected(dynamic image) {
    setState(() {
      _selectedImage = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agregar Estudiante'),
        elevation: 0.0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const SizedBox(height: 20),
              Stack(
                alignment: Alignment.center,
                children: [
                  CircleAvatar(
                    radius: 90.0,
                    backgroundImage: _selectedImage != null
                        ? kIsWeb
                            ? Image.memory(_selectedImage).image
                            : FileImage(File(_selectedImage.path))
                        : null,
                    child: _selectedImage == null
                        ? const Icon(
                            Icons.person,
                            size: 90,
                          )
                        : null,
                  ),
                  Positioned(
                    bottom: 0,
                    child: InkWell(
                      onTap: () {
                        CameraServices.showImagePicker(
                            context, _onImageSelected);
                      },
                      child: const Icon(
                        Icons.camera_alt,
                        size: 40,
                      ),
                    ),
                  ),
                ],
              ),
              TextFormField(
                controller: _nombresController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingresa los nombres';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  labelText: 'Nombres',
                  hintText: 'Por favor escriba sus nombres',
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _apellidosController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingresa los apellidos';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  labelText: 'Apellidos',
                  hintText: 'Por favor escriba sus apellidos',
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _cedulaController,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingresa el número de cédula';
                  } else if (value.length != 10) {
                    return 'La cédula debe tener exactamente 10 dígitos';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  labelText: 'Cédula',
                  hintText: 'Por favor escriba su número de cédula',
                  prefixIcon: Icon(Icons.credit_card),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _correoController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingresa el correo electrónico';
                  } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                      .hasMatch(value)) {
                    return 'Ingresa un correo electrónico válido';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'Correo Electrónico',
                  hintText: 'Por favor escriba su correo electrónico',
                  prefixIcon: const Icon(Icons.email),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String?>(
                value: _selectSexo,
                onChanged: (value) {
                  setState(() {
                    _selectSexo = value;
                  });
                },
                items: const [
                  DropdownMenuItem(
                    value: 'Masculino',
                    child: Text('Masculino'),
                  ),
                  DropdownMenuItem(
                    value: 'Femenino',
                    child: Text('Femenino'),
                  ),
                  // Puedes agregar más opciones según tus necesidades
                ],
                decoration: const InputDecoration(
                  labelText: 'Sexo',
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, selecciona el sexo';
                  }
                  return null;
                },
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
                dropdownColor: Theme.of(context).scaffoldBackgroundColor,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _edadController,
                keyboardType:
                    TextInputType.number, // Establecer el teclado como numérico
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingresa la edad';
                  } else if (int.tryParse(value) == null ||
                      int.parse(value) <= 0) {
                    return 'Ingresa una edad válida';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  labelText: 'Edad',
                  hintText: 'Por favor escriba su edad',
                  prefixIcon: Icon(Icons.numbers),
                ),
              ),
              const SizedBox(height: 20),

              GestureDetector(
                onTap: () {
                  _selectDate(context);
                },
                child: AbsorbPointer(
                  child: TextFormField(
                    controller: TextEditingController(
                      text: _fechaNacimiento != null
                          ? DateFormat('kk:mm:ss \n EEE d MMM')
                              .format(_fechaNacimiento!)
                          : '',
                    ),
                    validator: (value) {
                      if (_fechaNacimiento == null) {
                        return 'Por favor, selecciona la fecha de nacimiento';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      labelText: 'Fecha de Nacimiento',
                      prefixIcon: Icon(Icons.date_range),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Resto de los TextFormField para otros campos

              ElevatedButton(
                onPressed: () async {
                  if (_nombresController.text.isEmpty ||
                      _apellidosController.text.isEmpty ||
                      _cedulaController.text.isEmpty ||
                      _correoController.text.isEmpty ||
                      _edadController.text.isEmpty ||
                      _fechaNacimiento == null) {
                    // Verificar si algún campo está vacío y mostrar el mensaje
                    Dialogs.showSnackbarError(
                        context, 'Todos los campos son obligatorios');
                  } else {
                    // Si todos los campos están completos, proceder con la lógica de guardado
                    bool cedulaEnUso =
                        await _verificarCedulaEnUso(_cedulaController.text);

                    if (cedulaEnUso) {
                      // ignore: use_build_context_synchronously
                      Dialogs.showSnackbarError(
                          context, 'El número de cédula ya está en uso');
                    } else {
                      Estudiante nuevoEstudiante = Estudiante(
                        idestudiante: widget.idEstudiante,
                        idtutor: widget.idTutor,
                        usuariotutor: widget.usuario,
                        nombres: _nombresController.text,
                        apellidos: _apellidosController.text,
                        cedula: _cedulaController.text,
                        correo: _correoController.text,
                        edad: _edadController.text,
                        genero: _selectSexo,
                        fechanacimiento: _fechaNacimiento ?? DateTime.now(),
                        fecharegistro: DateTime.now().toLocal(),
                        imagen: _selectedImage?.path ?? '',
                        rol: rol, // Avoid null error
                      );

                      setState(() {
                        servicioEstudiante
                            .crearEstudiante(
                                nuevoEstudiante, widget.sesion.token)
                            .then((_) {
                          Dialogs.showSnackbar(context,
                              'Se ha guardado al estudiante correctamente');

                          // Volver a la pantalla anterior
                        }).catchError((error) {
                          _showErrorSnackbar();
                        });
                      });
                    }
                  }
                },
                child: const Text('Guardar'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _isValidCedula(String cedula) {
    // Ejemplo de validación de cédula en Ecuador (10 dígitos)
    if (cedula.length != 10) {
      return false;
    }
    return true;
  }

  //fecha de nacimiento
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _fechaNacimiento ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _fechaNacimiento) {
      setState(() {
        _fechaNacimiento = picked;
      });
    }
  }

  //verificar numero de cedula
  Future<bool> _verificarCedulaEnUso(String cedula) async {
    // Lógica para verificar si la cédula está en uso
    // Esto podría ser una llamada a tu servicio o base de datos para verificar la existencia de la cédula
    // Retorna true si la cédula ya está en uso, false si no está en uso
    // Ejemplo ficticio:
    List<Estudiante> estudiantes = (await servicioEstudiante
            .obtenerEstudiantesTutor(widget.usuario, widget.sesion.token))
        .cast<Estudiante>();

    return estudiantes.any((estudiante) => estudiante.cedula == cedula);
  }
}
