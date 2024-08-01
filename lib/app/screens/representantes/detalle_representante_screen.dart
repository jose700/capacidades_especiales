import 'dart:io';

import 'package:capacidades_especiales/app/models/representantes/representative_model.dart';
import 'package:capacidades_especiales/app/models/tutor/login_model.dart';
import 'package:capacidades_especiales/app/utils/resources/app_colors.dart';
import 'package:capacidades_especiales/app/screens/representantes/editar_representantes_screen.dart';
import 'package:flutter/material.dart';

class DetalleRepresentanteScreen extends StatelessWidget {
  final Representante representante;
  final Sesion sesion;

  const DetalleRepresentanteScreen(this.representante, this.sesion);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${representante.nombres} ${representante.apellidos}',
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: AppColors.contentColorBlue),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditarRepresentantesScreen(
                    representante,
                    sesion: sesion,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Hero(
              tag: 'representante_${representante.idestudiante}',
              child: Stack(
                children: [
                  // Utilizamos un operador ternario para manejar la carga de la imagen
                  representante.imagen != null
                      ? Image.file(
                          File(representante
                              .imagen!), // Asumiendo que 'imagen' es un String con la ruta
                          fit: BoxFit.contain,
                          width: double.infinity,
                          height: double.infinity,
                          errorBuilder: (BuildContext context, Object exception,
                              StackTrace? stackTrace) {
                            return Image.asset(
                              'assets/img/cp.png',
                              fit: BoxFit.contain,
                              width: double.infinity,
                              height: double.infinity,
                            ); // Imagen local por defecto
                          },
                        )
                      : Image.asset(
                          'assets/img/cp.png',
                          fit: BoxFit.contain,
                          width: double.infinity,
                          height: double.infinity,
                        ), // Imagen local por defecto si 'representante.imagen' es nulo
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
