import 'dart:io';

import 'package:capacidades_especiales/app/models/estudiantes/student_model.dart';
import 'package:capacidades_especiales/app/models/tutor/login_model.dart';
import 'package:capacidades_especiales/app/utils/resources/app_colors.dart';
import 'package:capacidades_especiales/app/screens/estudiantes/page/detalle_estudiante_screen.dart';
import 'package:capacidades_especiales/app/screens/estudiantes/page/editar_estudiante.dart';
import 'package:capacidades_especiales/app/services/estudiante/service_estudiantes.dart';
import 'package:capacidades_especiales/app/widgets/search/no_results_widgets.dart';
import 'package:capacidades_especiales/app/widgets/tutor/Home/messages/dialogs/login_message.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class StudentList extends StatefulWidget {
  final Sesion sesion;
  final List<Estudiante> filteredEstudiantes;
  final List<Estudiante> estudiantes;
  final Future<List<Estudiante>> Function() fetchEstudiantes;
  final BuildContext context;
  final ServicioEstudiante servicioEstudiante;

  StudentList({
    required this.filteredEstudiantes,
    required this.estudiantes,
    required this.fetchEstudiantes,
    required this.context,
    required this.servicioEstudiante,
    required this.sesion,
  });

  @override
  _StudentListState createState() => _StudentListState();
}

class _StudentListState extends State<StudentList> {
  late Future<List<Estudiante>> futureEstudiantes;

  @override
  void initState() {
    super.initState();
    futureEstudiantes = widget.fetchEstudiantes();
  }

  @override
  Widget build(BuildContext context) {
    return _buildStudentList();
  }

  Widget _buildStudentList() {
    return FutureBuilder<List<Estudiante>>(
      future: futureEstudiantes,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData) {
          if (widget.filteredEstudiantes.isEmpty) {
            return NoResultsWidget();
          }
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Foto')),
                  DataColumn(label: Text('Nombres')),
                  DataColumn(label: Text('Apellidos')),
                  DataColumn(label: Text('Cédula')),
                  DataColumn(label: Text('Correo')),
                  DataColumn(label: Text('Sexo')),
                  DataColumn(label: Text('Edad')),
                  DataColumn(label: Text('Fecha de Nacimiento')),
                  DataColumn(label: Text('Fecha de Registro')),
                  DataColumn(label: Text('Acciones')),
                ],
                rows: widget.filteredEstudiantes
                    .map((estudiante) => DataRow(cells: [
                          DataCell(
                            InkWell(
                              onTap: () {
                                // Aquí puedes manejar lo que sucede al hacer clic en la fila del estudiante
                                print(
                                    'Clic en estudiante ${estudiante.idestudiante}');
                                // Por ejemplo, podrías navegar a otra pantalla usando Navigator
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          DetalleEstudianteScreen(
                                              estudiante, widget.sesion)),
                                );
                              },
                              child: Hero(
                                tag: 'estudiante_${estudiante.idestudiante}',
                                child: CircleAvatar(
                                  radius: 20.0,
                                  backgroundImage: estudiante.imagen != null
                                      ? FileImage(
                                          File(estudiante.imagen.toString()))
                                      : null,
                                  child: estudiante.imagen == null
                                      ? const Icon(Icons.person, size: 20.0)
                                      : null,
                                ),
                              ),
                            ),
                          ),
                          DataCell(Text(estudiante.nombres.toString())),
                          DataCell(Text(estudiante.apellidos.toString())),
                          DataCell(Text(estudiante.cedula.toString())),
                          DataCell(Text(estudiante.correo.toString())),
                          DataCell(Text(estudiante.genero.toString())),
                          DataCell(Text(estudiante.edad.toString())),
                          DataCell(Text(
                            estudiante.fechanacimiento != null
                                ? DateFormat('dd MMM \'del\' yyyy')
                                    .format(estudiante.fechanacimiento!)
                                : 'Fecha no disponible',
                          )),
                          DataCell(
                            Text(
                              estudiante.fecharegistro != null
                                  ? '${DateFormat('dd MMM \'del\' yyyy').format(estudiante.fecharegistro!)}'
                                  : 'Fecha no disponible',
                            ),
                          ),
                          DataCell(Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit,
                                    color: AppColors.contentColorBlue),
                                onPressed: () async {
                                  final cambiosRealizados =
                                      await Navigator.push<bool>(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          EditarEstudianteScreen(estudiante,
                                              sesion: widget.sesion),
                                    ),
                                  );
                                  if (cambiosRealizados == true) {
                                    setState(() {
                                      futureEstudiantes =
                                          widget.fetchEstudiantes();
                                    });
                                  }
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete,
                                    color: AppColors.contentColorRed),
                                onPressed: () {
                                  _showDeleteConfirmationDialog(estudiante);
                                },
                              ),
                            ],
                          )),
                        ]))
                    .toList(),
              ),
            ),
          );
        } else {
          return NoTDataWidget();
        }
      },
    );
  }

  void _showDeleteConfirmationDialog(Estudiante estudiante) {
    showAdaptiveDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Eliminar'),
          content: const Text('¿Estás seguro de eliminar este estudiante?'),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.contentColorRed,
              ),
              onPressed: () async {
                try {
                  await widget.servicioEstudiante.eliminarEstudiante(
                      estudiante.idestudiante.toString(), widget.sesion.token);
                  Dialogs.showSnackbar(
                      context, 'Se ha eliminado al estudiante correctamente');
                  Navigator.pop(context);

                  setState(() {
                    widget.estudiantes.remove(estudiante);
                    widget.filteredEstudiantes.remove(estudiante);
                  });
                } catch (e) {
                  Dialogs.showSnackbarError(
                      context, 'Error al eliminar al estudiante');
                  Navigator.pop(context);
                }
              },
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );
  }
}
