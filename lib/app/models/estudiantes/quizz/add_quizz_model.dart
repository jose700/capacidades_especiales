class addQuiz {
  final int idpreguntas;
  final int idtutor;
  final int idmateria;
  final String categoria;
  final String tipo;
  final String dificultad;
  final String pregunta;
  final String respuestaCorrecta;
  final List<String> respuestasIncorrectas;
  final String estado_test;
  final String tiempoLimite;

  addQuiz({
    required this.idpreguntas,
    required this.idtutor,
    required this.idmateria,
    required this.categoria,
    required this.tipo,
    required this.dificultad,
    required this.pregunta,
    required this.respuestaCorrecta,
    required this.respuestasIncorrectas,
    required this.estado_test,
    required this.tiempoLimite,
  });

  Map<String, dynamic> toMap() {
    return {
      'idpreguntas': idpreguntas,
      'idtutor': idtutor,
      'idmateria': idmateria,
      'categoria': categoria,
      'tipo': tipo,
      'dificultad': dificultad,
      'pregunta': pregunta,
      'respuestaCorrecta': respuestaCorrecta,
      'respuestasIncorrectas': respuestasIncorrectas,
      'estado_test': estado_test,
      'tiempoLimite': tiempoLimite,
    };
  }
}
