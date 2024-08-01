import 'dart:io';

import 'package:capacidades_especiales/app/models/tutor/login_model.dart';
import 'package:flutter/material.dart';
import 'package:capacidades_especiales/app/widgets/tutor/Home/messages/dialogs/login_message.dart';
import 'package:capacidades_especiales/app/models/estudiantes/student_model.dart';
import 'package:capacidades_especiales/app/services/estudiante/service_estudiantes.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class EditarEstudianteScreen extends StatefulWidget {
  final Estudiante estudiante;
  final Sesion sesion;
  const EditarEstudianteScreen(this.estudiante,
      {Key? key, required this.sesion})
      : super(key: key);

  @override
  _ActualizarEstudianteScreenState createState() =>
      _ActualizarEstudianteScreenState();
}

class _ActualizarEstudianteScreenState extends State<EditarEstudianteScreen> {
  final ServicioEstudiante _servicioEstudiante = ServicioEstudiante();

  late final Estudiante estudiante;
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nombresController;
  late TextEditingController _apellidosController;
  late TextEditingController _cedulaController;
  late TextEditingController _correoController;
  late TextEditingController _edadController;
  DateTime? _fechaNacimiento;
  String? _selectSexo;
  File? _selectedImage;
  bool cambiosRealizados = false;
  final picker = ImagePicker();
  @override
  void initState() {
    super.initState();
    estudiante =
        widget.estudiante; // Aquí asignamos widget.estudiante a estudiante
    _nombresController = TextEditingController(text: estudiante.nombres);
    _apellidosController = TextEditingController(text: estudiante.apellidos);
    _cedulaController = TextEditingController(text: estudiante.cedula);
    _correoController = TextEditingController(text: estudiante.correo);
    _edadController = TextEditingController(text: estudiante.edad);
    _fechaNacimiento = estudiante.fechanacimiento;
    _selectSexo = estudiante.genero.toString();
  }

  Future<void> _getImagen(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);

    setState(() {
      if (pickedFile != null) {
        _selectedImage = File(pickedFile.path);
      }
    });
  }

  void _showErrorSnackbar() {
    Dialogs.showSnackbarError(context, 'Error al actualizar al estudiante');
  }

  void _showSuccessSnackbar() {
    Dialogs.showSnackbar(context, 'Estudiante actualizado correctamente');
  }

  void _showImagePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Tomar foto'),
                onTap: () {
                  _getImagen(ImageSource.camera);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Seleccionar de la galería'),
                onTap: () {
                  _getImagen(ImageSource.gallery);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _nombresController.dispose();
    _apellidosController.dispose();
    _cedulaController.dispose();
    _correoController.dispose();
    _edadController.dispose();
    super.dispose();
  }

  Future<void> _actualizarEstudiante() async {
    if (_formKey.currentState!.validate()) {
      try {
        Estudiante updatedEstudiante = Estudiante(
          usuariotutor: widget.estudiante.usuariotutor,
          nombres: _nombresController.text,
          apellidos: _apellidosController.text,
          cedula: _cedulaController.text,
          correo: _correoController.text,
          edad: _edadController.text,
          fechanacimiento: _fechaNacimiento ?? DateTime.now(),
          fecharegistro: DateTime.now(),
          genero: _selectSexo,
        );

        // Si hay una imagen seleccionada, actualizarla; de lo contrario, mantener la imagen existente
        if (_selectedImage != null) {
          updatedEstudiante.imagen = _selectedImage!.path;
        } else {
          updatedEstudiante.imagen =
              estudiante.imagen; // Mantener la imagen existente
        }

        await _servicioEstudiante.actualizarEstudiante(
            estudiante.idestudiante!, updatedEstudiante, widget.sesion.token);
        _showSuccessSnackbar();
      } catch (e) {
        _showErrorSnackbar();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Actualizar Estudiante'),
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
                        ? FileImage(_selectedImage!)
                        : (estudiante.imagen != null
                            ? FileImage(File(estudiante.imagen!))
                            : null),

                    // Color de fondo gris cuando no hay imagen
                    child: _selectedImage == null && estudiante.imagen == null
                        ? Icon(Icons.person,
                            size: 40.0) // Icono mostrado cuando no hay imagen
                        : null, // No mostrar ningún child si hay una imagen
                  ),
                  Positioned(
                    bottom: 0,
                    child: InkWell(
                      onTap: () {
                        _showImagePicker(context);
                      },
                      child: const Icon(
                        Icons
                            .camera_alt, // Cambia el icono según tus necesidades
                        size: 40,
                        color: Colors.white,
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
                decoration: InputDecoration(
                  labelText: 'Nombres',
                  hintText: 'Por favor ingrese sus nombres',
                  prefixIcon: const Icon(Icons.person),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
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
                decoration: InputDecoration(
                  labelText: 'Apellidos',
                  hintText: 'Por favor ingrese sus apellidos',
                  prefixIcon: const Icon(Icons.person),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
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
                decoration: InputDecoration(
                  labelText: 'Cédula',
                  hintText: 'Por favor ingrese su número de cédula',
                  prefixIcon: const Icon(Icons.credit_card),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
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
                  hintText: 'Por favor ingrese su correo electrónico',
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
                decoration: InputDecoration(
                  labelText: 'Sexo',
                  prefixIcon: const Icon(Icons.person),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, selecciona el sexo';
                  }
                  return null;
                },
                key: UniqueKey(),
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
                decoration: InputDecoration(
                  labelText: 'Edad',
                  hintText: 'Por favor ingrese su edad',
                  prefixIcon: const Icon(Icons.date_range_sharp),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
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
                          ? DateFormat('yyyy-MM-dd').format(_fechaNacimiento!)
                          : '',
                    ),
                    validator: (value) {
                      if (_fechaNacimiento == null) {
                        return 'Por favor, selecciona la fecha de nacimiento';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: 'Fecha de Nacimiento',
                      prefixIcon: const Icon(Icons.date_range),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
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
                    _actualizarEstudiante();
                  }
                },
                child: const Text('Actualizar'),
              ),
            ],
          ),
        ),
      ),
    );
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
}
