class TasksStudents {
  final int idmateria;
  final String usuarioTutor;
  final String informacionTarea;
  final String tituloTarea;
  final bool tareaCumplida;

  TasksStudents({
    required this.idmateria,
    required this.usuarioTutor,
    required this.informacionTarea,
    required this.tituloTarea,
    required this.tareaCumplida,
  });

  // Factory constructor para crear una instancia desde un mapa (JSON)
  factory TasksStudents.fromJson(Map<String, dynamic> json) {
    return TasksStudents(
      idmateria: json['idmateria'],
      usuarioTutor: json['usuariotutor'],
      tituloTarea: json['titulo_tarea'],
      informacionTarea: json['informacion_tarea'],
      tareaCumplida: json['tarea_cumplida'],
    );
  }

  // Método toJson para convertir la instancia a un mapa (JSON)
  Map<String, dynamic> toJson() {
    return {
      'idmateria': idmateria,
      'usuariotutor': usuarioTutor,
      'titulo_tarea': tituloTarea,
      'informacion_tarea': informacionTarea,
      'tarea_cumplida': tareaCumplida,
    };
  }
}
