class Quiz {
  int? idpreguntas;
  int? idmateria;
  int? idtutor;
  String? tipo;
  String? categoria;
  String? dificultad;
  String? pregunta;
  String? respuestaCorrecta;
  List<String>? respuestasIncorrectas;
  String? respuestaSeleccionada;
  String? tiempoLimite;
  String? tiempoTardado;
  String? estado_test;
  double? calificacion;
  String? nombreMateria;
  String? nombres_tutor;
  String? apellidos_tutor;
  String? nombres_estudiante;
  String? apellidos_estudiante;
  String? cedula_estudiante;
  String? correo_estudiante;
  String? imagen_estudiante;
  List<RespuestaEstudiante>? respuestasEstudiantes;

  Quiz({
    this.idpreguntas,
    this.idtutor,
    this.idmateria,
    this.tipo,
    this.categoria,
    this.dificultad,
    this.pregunta,
    this.respuestaCorrecta,
    this.respuestasIncorrectas,
    this.respuestaSeleccionada,
    this.tiempoLimite,
    this.tiempoTardado,
    this.estado_test,
    this.calificacion,
    this.nombreMateria,
    this.nombres_tutor,
    this.apellidos_tutor,
    this.respuestasEstudiantes,
    this.nombres_estudiante,
    this.apellidos_estudiante,
    this.cedula_estudiante,
    this.correo_estudiante,
    this.imagen_estudiante,
  });

  factory Quiz.fromJson(Map<String, dynamic> json) {
    String? tiempoTardado = json['tiempo_tardado'];
    double? calificacion =
        json['calificacion'] != null ? json['calificacion'].toDouble() : null;

    return Quiz(
      idpreguntas: json['idpreguntas'],
      idtutor: json['idtutor'],
      idmateria: json['idmateria'],
      tipo: json['tipo'],
      categoria: json['categoria'],
      dificultad: json['dificultad'],
      pregunta: json['pregunta'],
      respuestaCorrecta: json['respuesta_correcta'],
      respuestasIncorrectas: List<String>.from(json['respuestas_incorrectas']),
      respuestaSeleccionada: json['respuesta_seleccionada'],
      tiempoLimite: json['limite_tiempo'] ?? '',
      tiempoTardado: tiempoTardado,
      estado_test: json['estado_test'] ?? '',
      calificacion: calificacion,
      nombreMateria: json['nombre_materia'] ?? '',
      nombres_tutor: json['nombres_tutor'] ?? '',
      apellidos_tutor: json['apellidos_tutor'] ?? '',
      nombres_estudiante: json['nombres_estudiante'] ?? '',
      apellidos_estudiante: json['apellidos_estudiante'] ?? '',
      cedula_estudiante: json['cedula_estudiante'] ?? '',
      correo_estudiante: json['correo_estudiante'] ?? '',
      imagen_estudiante: json['imagen_estudiante'] ?? '',
      respuestasEstudiantes: json['respuestas_estudiantes'] != null
          ? List<RespuestaEstudiante>.from(json['respuestas_estudiantes']
              .map((x) => RespuestaEstudiante.fromJson(x)))
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idpreguntas': idpreguntas,
      'idtutor': idtutor,
      'idmateria': idmateria,
      'tipo': tipo,
      'categoria': categoria,
      'dificultad': dificultad,
      'pregunta': pregunta,
      'respuesta_correcta': respuestaCorrecta,
      'respuestas_incorrectas': respuestasIncorrectas,
      'respuesta_seleccionada': respuestaSeleccionada,
      'limite_tiempo': tiempoLimite,
      'estado_test': estado_test,
      'calificacion': calificacion,
      'nombre_materia': nombreMateria,
      'nombres_tutor': nombres_tutor,
      'apellidos_tutor': apellidos_tutor,
      'nombres_estudiante': nombres_estudiante,
      'apellidos_estudiante': apellidos_estudiante,
      'cedula_estudiante': cedula_estudiante,
      'correo_estudiante': correo_estudiante,
      'imagen_estudiante': imagen_estudiante,
      'respuestas_estudiantes':
          respuestasEstudiantes?.map((x) => x.toJson()).toList(),
    };
  }
}

class RespuestaEstudiante {
  String? nombresEstudiante;
  String? apellidosEstudiante;
  String? respuestaSeleccionada;
  String? tiempoTardado;
  String? estadoTest;
  String? correoEstudiante;
  String? imagenEstudiante;

  RespuestaEstudiante({
    this.nombresEstudiante,
    this.apellidosEstudiante,
    this.respuestaSeleccionada,
    this.tiempoTardado,
    this.estadoTest,
    this.correoEstudiante,
    this.imagenEstudiante,
  });

  factory RespuestaEstudiante.fromJson(Map<String, dynamic> json) {
    return RespuestaEstudiante(
      nombresEstudiante: json['nombres_estudiante'],
      apellidosEstudiante: json['apellidos_estudiante'],
      respuestaSeleccionada: json['respuesta_seleccionada'],
      tiempoTardado: json['tiempo_tardado'],
      estadoTest: json['estado_test'],
      correoEstudiante: json['correo_estudiante'],
      imagenEstudiante: json['imagen_estudiante'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nombres_estudiante': nombresEstudiante,
      'apellidos_estudiante': apellidosEstudiante,
      'respuesta_seleccionada': respuestaSeleccionada,
      'tiempo_tardado': tiempoTardado,
      'estado_test': estadoTest,
      'correo_estudiante': correoEstudiante,
      'imagen_estudiante': imagenEstudiante,
    };
  }
}
