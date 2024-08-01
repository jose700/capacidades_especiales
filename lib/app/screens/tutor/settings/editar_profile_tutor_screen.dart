import 'dart:developer';
import 'package:capacidades_especiales/app/models/tutor/tutor_model.dart';
import 'package:capacidades_especiales/app/services/tutor/service_register_login.dart';
import 'package:capacidades_especiales/app/widgets/tutor/Home/messages/dialogs/login_message.dart';
import 'package:flutter/material.dart';

class EditProfileScreen extends StatefulWidget {
  final int idTutor;
  final String usuario;

  const EditProfileScreen(this.idTutor, {Key? key, required this.usuario})
      : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  Tutor? tutorData;
  final registerLoginService = RegisterLoginService();
  bool usuarioUpdated = false;

  @override
  void initState() {
    super.initState();
    cargarPerfilTutor();
  }

  Future<void> cargarPerfilTutor() async {
    try {
      final tutor = await registerLoginService.obtenerTutor(widget.idTutor);
      setState(() {
        tutorData = tutor;
      });
    } catch (e) {
      log('Error al cargar el perfil del tutor: $e');
    }
  }

  Future<void> _actualizarPerfil() async {
    try {
      if (tutorData != null) {
        await registerLoginService.actualizarPerfilTutor(
          widget.idTutor,
          {
            'usuario': tutorData!.usuario,
            'correo': tutorData!.correo,
          },
        );
        await cargarPerfilTutor(); // Refresh the data after update
        Dialogs.showSnackbar(context, 'Perfil actualizado correctamente');

        if (usuarioUpdated) {
          Navigator.of(context).pushReplacementNamed('/login');
        }
      }
    } catch (e) {
      log('Error al actualizar el perfil del tutor: $e');
      Dialogs.showSnackbarError(
          context, 'Error al actualizar el perfil del tutor');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Perfil'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: tutorData == null ? _buildLoading() : _buildProfileEditor(),
    );
  }

  Widget _buildLoading() {
    return Center(child: CircularProgressIndicator());
  }

  Widget _buildProfileEditor() {
    return SingleChildScrollView(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (tutorData != null) ...[
                const SizedBox(height: 20),
                _buildTextFieldWithIcon(
                  Icons.person,
                  'Usuario',
                  tutorData!.usuario,
                  enabled: true,
                  hintText: 'Ingrese su usuario',
                ),
                const SizedBox(height: 20),
                _buildTextFieldWithIcon(
                  Icons.email,
                  'Correo',
                  tutorData!.correo,
                  enabled: true,
                  hintText: 'Ingrese su correo',
                ),
                const SizedBox(height: 20),
              ],
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _actualizarPerfil,
                child: const Text('Actualizar'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextFieldWithIcon(
    IconData icon,
    String label,
    String? value, {
    required bool enabled,
    required String hintText,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label,
          hintText: hintText,
          prefixIcon:
              Icon(icon), // Aquí se define el ícono a la izquierda del campo
        ),
        initialValue: value,
        enabled: enabled,
        onChanged: (newValue) {
          setState(() {
            if (label == 'Usuario') {
              tutorData!.usuario = newValue;
              usuarioUpdated = true;
            } else if (label == 'Correo') {
              tutorData!.correo = newValue;
            }
          });
        },
      ),
    );
  }
}
