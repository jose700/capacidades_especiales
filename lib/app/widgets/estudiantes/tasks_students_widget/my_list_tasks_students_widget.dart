import 'package:capacidades_especiales/app/models/estudiantes/tareas/data_task_model.dart';

import 'package:capacidades_especiales/app/models/estudiantes/tareas/list_item_students_task_model.dart';
import 'package:capacidades_especiales/app/utils/resources/app_colors.dart';
import 'package:capacidades_especiales/app/services/estudiante/tasks/tasks_students_service.dart';
import 'package:capacidades_especiales/app/widgets/tutor/Home/messages/dialogs/login_message.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class MisTareasEstudiantesDataTableWidget extends StatefulWidget {
  final List<DatosTareasEstudiantes> datosTutores;

  MisTareasEstudiantesDataTableWidget({
    required this.datosTutores,
  });

  @override
  State<MisTareasEstudiantesDataTableWidget> createState() =>
      _MisTareasEstudiantesDataTableWidgetState();
}

class _MisTareasEstudiantesDataTableWidgetState
    extends State<MisTareasEstudiantesDataTableWidget> {
  final ServicioProgresoEstudiante servicioProgresoEstudiante =
      ServicioProgresoEstudiante();
  @override
  void initState() {
    super.initState();
    initializeDateFormatting(
        'es_ES', null); // Inicializa la localización en español
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: <DataColumn>[
          DataColumn(label: Text('Materia')),
          DataColumn(label: Text('Fecha de creación de tarea')),
          DataColumn(label: Text('Fecha de envió')),
          DataColumn(label: Text('Título de la tarea')),
          DataColumn(label: Text('Información Tarea')),
          DataColumn(label: Text('Calificación')),
          DataColumn(label: Text('Comentarios')),
          DataColumn(label: Text('Nombre Archivo')),
          DataColumn(label: Text('Tipo de Archivo')),
          DataColumn(label: Text('Tarea Cumplida')),
          DataColumn(label: Text('Acciones'))
        ],
        rows: widget.datosTutores
            .expand((tutor) => tutor.tareas.map((tarea) {
                  return DataRow(
                    cells: [
                      DataCell(Text(tarea.nombreMateria.toString())),
                      DataCell(tarea.fechaCreoTarea != null
                          ? Text(
                              'Se creó el día ${DateFormat('EEEE', 'es_ES').format(tarea.fechaCreoTarea!)} ${DateFormat('d MMMM yyyy', 'es_ES').format(tarea.fechaCreoTarea!)} a las ${DateFormat('h:mm a', 'es_ES').format(tarea.fechaCreoTarea!)}')
                          : Text('Aún no hay envió')),
                      DataCell(tarea.fecha_envio_tarea_subida != null
                          ? Text(
                              'Enviado el día ${DateFormat('EEEE', 'es_ES').format(tarea.fecha_envio_tarea_subida!)} ${DateFormat('d MMMM yyyy', 'es_ES').format(tarea.fecha_envio_tarea_subida!)} a las ${DateFormat('h:mm a', 'es_ES').format(tarea.fecha_envio_tarea_subida!)}')
                          : const Text('Aún no hay envió')),
                      DataCell(Text(tarea.titulo_tarea ?? '-')),
                      DataCell(Text(tarea.informacionTarea ?? '-')),
                      DataCell(tarea.calificacion != null
                          ? Text(tarea.calificacion!.toString())
                          : Text('-')),
                      DataCell(tarea.comentarios != null
                          ? Text(tarea.comentarios!.toString())
                          : Text('-')),
                      DataCell(tarea.archivo_nombre_subida != null
                          ? Text(tarea.archivo_nombre_subida!.toString())
                          : const Text('-')),
                      DataCell(tarea.archivo_mimetype_subida != null
                          ? Text(tarea.archivo_mimetype_subida!.toString())
                          : const Text('-')),
                      DataCell(
                        tarea.tarea_cumplida_subida == null
                            ? Icon(
                                Icons
                                    .cancel, // O cualquier otro ícono que prefieras
                                color: AppColors
                                    .contentColorRed, // Color rojo cuando es null
                              )
                            : tarea.tarea_cumplida_subida == true
                                ? Icon(
                                    Icons
                                        .check_circle, // O cualquier otro ícono que prefieras
                                    color: AppColors
                                        .contentColorGreen, // Color verde cuando es true
                                  )
                                : Icon(
                                    Icons
                                        .cancel, // O cualquier otro ícono que prefieras
                                    color: AppColors
                                        .contentColorRed, // Color rojo cuando es false
                                  ),
                      ),
                      DataCell(Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.delete,
                                color: AppColors.contentColorRed),
                            onPressed: () {
                              _showDeleteConfirmationDialog(tarea, context);
                            },
                          ),
                        ],
                      )),
                    ],
                  );
                }))
            .toList(),
      ),
    );
  }

  void _showDeleteConfirmationDialog(
      TareaEstudiante tarea, BuildContext context) {
    showAdaptiveDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Eliminar'),
          content: const Text('¿Estás seguro de eliminar esta tarea?'),
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
                  await servicioProgresoEstudiante
                      .eliminarTareaSubidaEstudiante(tarea.id.toString());
                  Dialogs.showSnackbar(
                      context, 'Se ha eliminado su tarea correctamente');
                  Navigator.pop(context);

                  setState(() {
                    // Encuentra y elimina la tarea del widget.datosTutores
                    for (var tutor in widget.datosTutores) {
                      tutor.tareas.removeWhere((t) => t.id == tarea.id);
                    }
                  });
                } catch (e) {
                  Dialogs.showSnackbarError(
                      context, 'Error al eliminar la tarea');
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
