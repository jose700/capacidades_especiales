import 'package:capacidades_especiales/app/models/estudiantes/tareas/list_item_students_task_model.dart';

class DatosTutor {
  final String usuarioTutor;
  final List<TareaEstudiante> tareas;

  DatosTutor({
    required this.usuarioTutor,
    required this.tareas,
  });

  factory DatosTutor.fromJson(Map<String, dynamic> json) {
    List<TareaEstudiante> tareasList = (json['tareas'] as List)
        .map((taskJson) => TareaEstudiante.fromJson(taskJson))
        .toList();

    return DatosTutor(
      usuarioTutor: json['usuariotutor'],
      tareas: tareasList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'usuariotutor': usuarioTutor,
      'tareas': tareas.map((task) => task.toJson()).toList(),
    };
  }
}
