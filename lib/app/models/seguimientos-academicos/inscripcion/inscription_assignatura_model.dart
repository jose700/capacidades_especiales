class InscripcionMateria {
  int? idinscripcion;
  int idEstudiante;
  int idmateria;
  String usuarioTutor;
  DateTime fechaInscripcion;
  String estado;
  String? nombres;
  String? apellidos;
  String? imagen;
  String? correo;
  String? nombreMateria;
  String? institucion;
  String? curso;
  String? nivel;
  String? paralelo;
  String? jornada;
  String? descripcion;
  int? creditos;
  String? cedula_estudiante;
  InscripcionMateria(
      {this.idinscripcion,
      required this.idEstudiante,
      required this.idmateria,
      required this.usuarioTutor,
      required this.fechaInscripcion,
      required this.estado,
      this.nombres,
      this.apellidos,
      this.imagen,
      this.correo,
      required this.nombreMateria,
      this.institucion,
      this.curso,
      this.nivel,
      this.paralelo,
      this.jornada,
      this.descripcion,
      this.creditos,
      this.cedula_estudiante});

  // Método para crear una instancia de InscripcionMateria desde un JSON
  factory InscripcionMateria.fromJson(Map<String, dynamic> json) {
    return InscripcionMateria(
        idinscripcion: json['idinscripcion'],
        idEstudiante: json['idestudiante'],
        idmateria: json['idmateria'],
        usuarioTutor: json['usuariotutor'],
        fechaInscripcion: DateTime.parse(json['fecha_inscripcion']),
        estado: json['estado'],
        nombres: json['nombres'],
        apellidos: json['apellidos'],
        imagen: json['imagen'],
        correo: json['correo'],
        nombreMateria: json['nombre_materia'],
        institucion: json['institucion'],
        curso: json['curso'],
        nivel: json['nivel'],
        paralelo: json['paralelo'],
        jornada: json['jornada'],
        descripcion: json['descripcion'],
        creditos: json['creditos'],
        cedula_estudiante: json['cedula_estudiante']);
  }

  // Método para convertir una instancia de InscripcionMateria a JSON
  Map<String, dynamic> toJson() {
    return {
      'idinscripcion': idinscripcion,
      'idestudiante': idEstudiante,
      'idmateria': idmateria,
      'usuariotutor': usuarioTutor,
      'fecha_inscripcion': fechaInscripcion.toIso8601String(),
      'estado': estado,
      'nombres': nombres,
      'apellidos': apellidos,
      'imagen': imagen,
      'correo': correo,
      'nombre_materia': nombreMateria,
      'institucion': institucion,
      'curso': curso,
      'nivel': nivel,
      'paralelo': paralelo,
      'jornada': jornada,
      'descripcion': descripcion,
      'creditos': creditos,
      'cedula_estudiante': cedula_estudiante
    };
  }
}
