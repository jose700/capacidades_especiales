import 'dart:io';

import 'package:capacidades_especiales/app/models/seguimientos-academicos/inscripcion/inscription_assignatura_model.dart';
import 'package:capacidades_especiales/app/models/tutor/login_model.dart';
import 'package:capacidades_especiales/app/utils/resources/app_colors.dart';
import 'package:capacidades_especiales/app/screens/seguimientos-academicos/inscripciones-materias/editar_inscripcion_screen.dart';
import 'package:capacidades_especiales/app/services/seguimientos-academicos/inscripcion/inscripcion_materia_service.dart';
import 'package:capacidades_especiales/app/widgets/search/no_results_widgets.dart';
import 'package:capacidades_especiales/app/widgets/tutor/Home/messages/dialogs/login_message.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MateriaInscripcionList extends StatefulWidget {
  final Sesion sesion;
  final List<InscripcionMateria> filteredMateriasInscritas;
  final List<InscripcionMateria> inscritas;
  final Future<List<InscripcionMateria>> Function() fetchMateriasIncritas;
  final BuildContext context;
  final ServicioInscripcionMateria servicioMateriaInscritas;

  MateriaInscripcionList({
    required this.filteredMateriasInscritas,
    required this.inscritas,
    required this.fetchMateriasIncritas,
    required this.context,
    required this.servicioMateriaInscritas,
    required this.sesion,
  });

  @override
  _MateriaListState createState() => _MateriaListState();
}

class _MateriaListState extends State<MateriaInscripcionList> {
  late Future<List<InscripcionMateria>> futureMateriasInscritas;

  @override
  void initState() {
    super.initState();
    futureMateriasInscritas = widget.fetchMateriasIncritas();
  }

  @override
  Widget build(BuildContext context) {
    return _buildMateriasList();
  }

  Widget _buildMateriasList() {
    return FutureBuilder<List<InscripcionMateria>>(
      future: futureMateriasInscritas,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData) {
          if (widget.filteredMateriasInscritas.isEmpty) {
            return NoResultsWidget();
          }
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: const [
                DataColumn(label: Text('Asignatura')),
                DataColumn(label: Text('Foto del estudiante')),
                DataColumn(label: Text('Estudiante inscrito')),
                DataColumn(label: Text('Fecha de Inscripción')),
                DataColumn(label: Text('Institución')),
                DataColumn(label: Text('Curso')),
                DataColumn(label: Text('Nivel')),
                DataColumn(label: Text('Paralelo')),
                DataColumn(label: Text('Jornada')),
                DataColumn(label: Text('Descripción')),
                DataColumn(label: Text('Créditos')),
                DataColumn(label: Text('Estado')),
                DataColumn(label: Text('Acciones')),
              ],
              rows: widget.filteredMateriasInscritas
                  .map((inscripcion) => DataRow(cells: [
                        DataCell(Text(inscripcion.nombreMateria!)),
                        DataCell(CircleAvatar(
                          radius: 20.0,
                          backgroundImage: inscripcion.imagen != null
                              ? FileImage(File(inscripcion.imagen.toString()))
                              : null,
                          child: inscripcion.imagen == null
                              ? const Icon(Icons.person, size: 20.0)
                              : null,
                        )),
                        DataCell(Text(
                            '${inscripcion.nombres} ${inscripcion.apellidos}')),
                        DataCell(Text(DateFormat('dd/MM/yyyy EEEE')
                            .format(inscripcion.fechaInscripcion))),
                        DataCell(Text(inscripcion.institucion ?? '')),
                        DataCell(Text(inscripcion.curso ?? '')),
                        DataCell(Text(inscripcion.nivel ?? '')),
                        DataCell(Text(inscripcion.paralelo ?? '')),
                        DataCell(Text(inscripcion.jornada ?? '')),
                        DataCell(Text(inscripcion.descripcion ?? '')),
                        DataCell(Text(inscripcion.creditos?.toString() ?? '')),
                        DataCell(Text(inscripcion.estado)),
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
                                        EditarInscripcionScreen(
                                      inscripcion,
                                      sesion: widget.sesion,
                                    ),
                                  ),
                                );
                                if (cambiosRealizados == true) {
                                  // Si se realizaron cambios, actualiza la lista.
                                  await widget.fetchMateriasIncritas();
                                }
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete,
                                  color: AppColors.contentColorRed),
                              onPressed: () {
                                _showDeleteConfirmationDialog(inscripcion);
                              },
                            ),
                          ],
                        )),
                      ]))
                  .toList(),
            ),
          );
        } else {
          return NoTDataWidget();
        }
      },
    );
  }

  void _showDeleteConfirmationDialog(InscripcionMateria inscripcion) {
    showAdaptiveDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Eliminar'),
          content: const Text('¿Estás seguro de eliminar esta inscripción?'),
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
                  await widget.servicioMateriaInscritas
                      .eliminarInscripcionMateria(
                          inscripcion.idinscripcion.toString(),
                          widget.sesion.token);

                  // Elimina la inscripción de las listas locales
                  setState(() {
                    widget.inscritas.remove(inscripcion);
                    widget.filteredMateriasInscritas.remove(inscripcion);
                  });

                  // Muestra un mensaje de confirmación
                  Dialogs.showSnackbar(
                      context, 'Se ha eliminado la inscripción correctamente');

                  // Cierra el diálogo de confirmación
                  Navigator.pop(context);
                } catch (e) {
                  // Muestra un mensaje de error si falla la eliminación
                  Dialogs.showSnackbarError(
                      context, 'Error al eliminar la inscripción');

                  // Cierra el diálogo de confirmación
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
