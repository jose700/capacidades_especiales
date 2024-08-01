import 'dart:io';

import 'package:capacidades_especiales/app/models/estudiantes/student_model.dart';
import 'package:capacidades_especiales/app/models/representantes/representative_model.dart';
import 'package:capacidades_especiales/app/models/tutor/login_model.dart';
import 'package:capacidades_especiales/app/services/estudiante/service_estudiantes.dart';
import 'package:capacidades_especiales/app/services/representante/service_representantes.dart';
import 'package:flutter/material.dart';
import 'package:capacidades_especiales/app/widgets/tutor/Home/messages/dialogs/login_message.dart';
import 'package:image_picker/image_picker.dart';

class EditarRepresentantesScreen extends StatefulWidget {
  final Representante representante;
  final Sesion sesion;
  const EditarRepresentantesScreen(this.representante,
      {Key? key, required this.sesion})
      : super(key: key);

  @override
  _ActualizarRepresentanteScreenState createState() =>
      _ActualizarRepresentanteScreenState();
}

class _ActualizarRepresentanteScreenState
    extends State<EditarRepresentantesScreen> {
  final ServicioRepresentante _servicioRepresentante = ServicioRepresentante();

  late final Representante representante;
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nombresController;
  late TextEditingController _apellidosController;
  late TextEditingController _cedulaController;
  late TextEditingController _correoController;
  late TextEditingController _ocupacionController;
  late TextEditingController _numberphoneController;
  late TextEditingController _estadocivilController;
  String? _selectedEstudiante;
  late Future<List<Estudiante>> estudiantes;
  final ServicioEstudiante servicioEstudiante = ServicioEstudiante();
  File? _selectedImage;
  bool cambiosRealizados = false;
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _selectedEstudiante = widget.representante.idestudiante.toString();
    representante = widget.representante;
    estudiantes = fetchEstudiantes();
    _nombresController = TextEditingController(text: representante.nombres);
    _apellidosController = TextEditingController(text: representante.apellidos);
    _cedulaController = TextEditingController(text: representante.cedula);
    _correoController = TextEditingController(text: representante.correo);
    _ocupacionController = TextEditingController(text: representante.ocupacion);
    _numberphoneController =
        TextEditingController(text: representante.numberphone);
    _estadocivilController =
        TextEditingController(text: representante.estadocivil);
  }

  Future<List<Estudiante>> fetchEstudiantes() async {
    try {
      final fetchedEstudiantes =
          await servicioEstudiante.obtenerEstudiantesTutor(
              representante.usuariotutor.toString(), widget.sesion.token);
      return fetchedEstudiantes;
    } catch (e) {
      _showErrorSnackbar();
      return [];
    }
  }

  void _showErrorSnackbar() {
    Dialogs.showSnackbarError(context, 'Error al actualizar al representante');
  }

  void _showSuccessSnackbar() {
    Dialogs.showSnackbar(context, 'Representante actualizado correctamente');
  }

  String? requiredValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Este campo es obligatorio';
    }
    return null;
  }

  Future<void> _getImagen(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);

    setState(() {
      if (pickedFile != null) {
        _selectedImage = File(pickedFile.path);
      }
    });
  }

  String? _phoneValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Este campo es obligatorio';
    }
    final phoneRegex = RegExp(r'^\+?\d{10,14}$');
    if (!phoneRegex.hasMatch(value)) {
      return 'Ingrese un número de teléfono válido (10-14 dígitos, incluyendo el código de país)';
    }
    return null;
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
    _ocupacionController.dispose();
    _numberphoneController.dispose();
    super.dispose();
  }

  Future<void> updatedRepresentante() async {
    if (_formKey.currentState!.validate()) {
      Representante updatedRepresentante = Representante(
        idrepresentante: representante.idrepresentante,
        idestudiante: int.parse(_selectedEstudiante!),
        usuariotutor: widget.representante.usuariotutor,
        nombres: _nombresController.text,
        apellidos: _apellidosController.text,
        cedula: _cedulaController.text,
        correo: _correoController.text,
        estadocivil: _estadocivilController.text,
        ocupacion: _ocupacionController.text,
        imagen: _selectedImage?.path ??
            representante.imagen, // Usar la imagen seleccionada o la actual
        numberphone: _numberphoneController.text,
      );
      try {
        await _servicioRepresentante.actualizarRepresentante(
            representante.idrepresentante!,
            updatedRepresentante,
            widget.sesion.token);
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
        title: const Text('Actualizar representante'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  CircleAvatar(
                    radius: 90.0,
                    backgroundImage: _selectedImage != null
                        ? FileImage(_selectedImage!)
                        : (representante.imagen != null
                            ? FileImage(File(representante.imagen!))
                            : null),
                    child:
                        (_selectedImage == null && representante.imagen == null)
                            ? const Icon(Icons.person, size: 20.0)
                            : null,
                  ),
                  Positioned(
                    bottom: 0,
                    child: InkWell(
                      onTap: () {
                        _showImagePicker(context);
                      },
                      child: const Icon(
                        Icons.camera_alt,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const SizedBox(height: 20),
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
                          prefixIcon: Icon(Icons.person)),
                      items: estudiantesList.map((estudiante) {
                        return DropdownMenuItem<String>(
                          value: estudiante.idestudiante.toString(),
                          child: Text(
                              '${estudiante.nombres}: ${estudiante.apellidos}'),
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
                      dropdownColor: Theme.of(context).scaffoldBackgroundColor,
                    );
                  }
                },
              ),
              const SizedBox(height: 20),
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
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _estadocivilController,
                decoration: InputDecoration(
                  labelText: 'Estado Civil',
                  hintText: 'Ingresa el estado civil',
                  prefixIcon: const Icon(Icons.account_balance),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _ocupacionController,
                decoration: InputDecoration(
                  labelText: 'Ocupación',
                  hintText: 'Ingresa la ocupación',
                  prefixIcon: const Icon(Icons.work),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _numberphoneController,
                keyboardType: TextInputType.phone,
                validator: _phoneValidator,
                decoration: InputDecoration(
                  labelText: 'Número de Teléfono',
                  hintText: 'Ingresa el número de teléfono',
                  prefixIcon: const Icon(Icons.phone),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_nombresController.text.isEmpty ||
                      _apellidosController.text.isEmpty ||
                      _cedulaController.text.isEmpty ||
                      _correoController.text.isEmpty ||
                      _numberphoneController.text.isEmpty ||
                      _ocupacionController.text.isEmpty ||
                      _estadocivilController.text.isEmpty) {
                    // Asegurar que el campo de estado civil no esté vacío
                    Dialogs.showSnackbarError(
                        context, 'Todos los campos son obligatorios');
                  } else {
                    updatedRepresentante();
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
}
