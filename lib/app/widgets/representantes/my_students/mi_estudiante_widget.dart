import 'dart:io';
import 'package:flutter/material.dart';
import 'package:capacidades_especiales/app/models/representantes/student_data_model.dart';

class EstudianteDetailsWidget extends StatelessWidget {
  final DatosEstudiante datosEstudiante;

  EstudianteDetailsWidget(this.datosEstudiante);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [_buildProfileCard(datosEstudiante), SizedBox(height: 20)],
      ),
    );
  }

  Widget _buildProfileCard(DatosEstudiante datosEstudiante) {
    return Card(
      elevation: 3,
      margin: EdgeInsets.all(8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Container(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 40.0,
              backgroundImage: datosEstudiante.estudiante.imagen != null
                  ? FileImage(
                      File(datosEstudiante.estudiante.imagen.toString()))
                  : null,
              child: datosEstudiante.estudiante.imagen == null
                  ? const Icon(Icons.person, size: 50.0)
                  : null,
            ),
            SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Datos:',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    '${datosEstudiante.estudiante.nombres} ${datosEstudiante.estudiante.apellidos}',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Correo: ${datosEstudiante.estudiante.correo}',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Género: ${datosEstudiante.estudiante.genero}',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Edad: ${datosEstudiante.estudiante.edad} años',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 10),
                  SizedBox(height: 10),
                  Text(
                    'Cédula: ${datosEstudiante.estudiante.cedula}',
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
