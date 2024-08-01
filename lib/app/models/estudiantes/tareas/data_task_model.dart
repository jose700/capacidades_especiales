import 'package:capacidades_especiales/app/models/estudiantes/tareas/list_item_students_task_model.dart';

class DatosTareasEstudiantes {
  final String cedulaEstudiante;
  final int idTarea;

  final List<TareaEstudiante> tareas;

  DatosTareasEstudiantes({
    required this.idTarea,
    required this.cedulaEstudiante,
    required this.tareas,
  });

  factory DatosTareasEstudiantes.fromJson(Map<String, dynamic> json) {
    List<TareaEstudiante> tareasList = (json['tareas'] as List)
        .map((taskJson) => TareaEstudiante.fromJson(taskJson))
        .toList();

    return DatosTareasEstudiantes(
      idTarea: json['idtarea'],
      cedulaEstudiante: json['cedula_estudiante'],
      tareas: tareasList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idtarea': idTarea,
      'cedula_estudiante': cedulaEstudiante,
      'tareas': tareas.map((task) => task.toJson()).toList(),
    };
  }
}
