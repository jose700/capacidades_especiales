import 'package:capacidades_especiales/app/models/estudiantes/tareas/list_item_students_task_model.dart';
import 'package:capacidades_especiales/app/models/tutor/login_model.dart';
import 'package:capacidades_especiales/app/utils/resources/app_colors.dart';
import 'package:capacidades_especiales/app/screens/estudiantes/game/my_tasks/tasks_students/detalle_tarea_estudiante_screen.dart';
import 'package:capacidades_especiales/app/screens/estudiantes/game/my_tasks/tasks_students/crud/edit_task_screen.dart';
import 'package:capacidades_especiales/app/services/estudiante/tasks/tasks_students_service.dart';
import 'package:capacidades_especiales/app/widgets/tutor/Home/messages/dialogs/login_message.dart';
import 'package:flutter/material.dart';
import 'package:capacidades_especiales/app/models/tutor/tutor_task_model.dart';

class TareasEstudiantesDataTableWidget extends StatefulWidget {
  final List<DatosTutor> datosTutores;
  final Sesion sesion;
  TareasEstudiantesDataTableWidget(
      {required this.datosTutores, required this.sesion});

  @override
  State<TareasEstudiantesDataTableWidget> createState() =>
      _TareasEstudiantesDataTableWidgetState();
}

class _TareasEstudiantesDataTableWidgetState
    extends State<TareasEstudiantesDataTableWidget> {
  final ServicioProgresoEstudiante servicioProgresoEstudiante =
      ServicioProgresoEstudiante();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: const <DataColumn>[
          DataColumn(label: Text('Materia')),
          DataColumn(label: Text('Fecha de Creación')),
          DataColumn(label: Text('Fecha de Envío')),
          DataColumn(label: Text('Título de la tarea')),
          DataColumn(label: Text('Información Tarea')),
          DataColumn(label: Text('Calificación')),
          DataColumn(label: Text('Comentarios')),
          DataColumn(label: Text('Nombre Archivo')),
          DataColumn(label: Text('Archivo')),
          DataColumn(label: Text('Tarea Cumplida')),
          DataColumn(label: Text('Estudiante')),
          DataColumn(label: Text('Correo Estudiante')),
          DataColumn(label: Text('Acciones'))
        ],
        rows: widget.datosTutores
            .expand((tutor) => tutor.tareas.map((tarea) {
                  return DataRow(
                    cells: [
                      DataCell(Text(tarea.nombreMateria.toString())),
                      DataCell(Text(tarea.fechaCreoTarea.toString())),
                      DataCell(tarea.fecha_envio_tarea_subida != null
                          ? Text(tarea.fecha_envio_tarea_subida!.toString())
                          : const Text('-')),
                      DataCell(Text(tarea.titulo_tarea ?? '')),
                      DataCell(Text(tarea.informacionTarea.toString())),
                      DataCell(tarea.calificacion != null
                          ? Text(tarea.calificacion!.toString())
                          : const Text('-')),
                      DataCell(tarea.comentarios != null
                          ? Text(tarea.comentarios!.toString())
                          : const Text('-')),
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
                      DataCell(Text(
                          '${tarea.nombresEstudiante} ${tarea.apellidosEstudiante}')),
                      DataCell(Text(tarea.correoEstudiante.toString())),
                      DataCell(Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove_red_eye_sharp,
                                color: AppColors.contentColorGreen),
                            onPressed: () {
                              if (tarea.archivo_nombre_subida == null) {
                                // Si no se ha subido tarea, mostrar mensaje
                                Dialogs.showSnackbarError(context,
                                    'No se ha subido ninguna tarea aún.');
                              } else {
                                // Si se ha subido tarea, navegar a la pantalla de detalles
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        DetalleTareaEstudianteScreen(
                                            tarea: tarea),
                                  ),
                                );
                              }
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.edit,
                                color: AppColors.contentColorBlue),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      EditarTareaEstudianteScreen(
                                          tarea: tarea, sesion: widget.sesion),
                                ),
                              );
                            },
                          ),
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
                      .eliminarTareaEstudiante(tarea.idTarea.toString());
                  Dialogs.showSnackbar(context,
                      'Se ha eliminado la tarea para el estudiante correctamente');
                  Navigator.pop(context);

                  setState(() {
                    // Encuentra y elimina la tarea del widget.datosTutores
                    for (var tutor in widget.datosTutores) {
                      tutor.tareas
                          .removeWhere((t) => t.idTarea == tarea.idTarea);
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
