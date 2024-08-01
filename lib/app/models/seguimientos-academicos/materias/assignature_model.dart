class Materia {
  final int idmateria;
  final int? idEstudiante;
  final String usuarioTutor;
  final String nombreMateria;
  final String institucion;
  final String curso;
  final String nivel;
  final String paralelo;
  final String jornada;
  final String descripcion;
  final int creditos;

  Materia({
    required this.idmateria,
    this.idEstudiante,
    required this.usuarioTutor,
    required this.nombreMateria,
    required this.institucion,
    required this.curso,
    required this.nivel,
    required this.paralelo,
    required this.jornada,
    required this.descripcion,
    required this.creditos,
  });

  factory Materia.fromJson(Map<String, dynamic> json) {
    return Materia(
      idmateria: json['idmateria'],
      idEstudiante: json['idestudiante'],
      usuarioTutor: json['usuariotutor'],
      nombreMateria: json['nombre_materia'],
      institucion: json['institucion'],
      curso: json['curso'],
      nivel: json['nivel'],
      paralelo: json['paralelo'],
      jornada: json['jornada'],
      descripcion: json['descripcion'],
      creditos: json['creditos'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idmateria': idmateria,
      'idestudiante': idEstudiante,
      'usuariotutor': usuarioTutor,
      'nombre_materia': nombreMateria,
      'institucion': institucion,
      'curso': curso,
      'nivel': nivel,
      'paralelo': paralelo,
      'jornada': jornada,
      'descripcion': descripcion,
      'creditos': creditos,
    };
  }
}
