class Estudiante {
  int? idtutor;
  int? idestudiante;
  String? usuariotutor;
  String? nombres;
  String? apellidos;
  String? cedula;
  String? correo;
  String? edad;
  DateTime? fechanacimiento;
  DateTime? fecharegistro;
  String? genero;
  String? imagen;
  String? rol;

  Estudiante({
    this.idtutor,
    this.idestudiante,
    this.usuariotutor,
    this.nombres,
    this.apellidos,
    this.cedula,
    this.correo,
    this.edad,
    this.fechanacimiento,
    this.fecharegistro,
    this.genero,
    this.imagen,
    this.rol,
  });

  factory Estudiante.fromJson(Map<String, dynamic> json) {
    return Estudiante(
      idtutor: json['idtutor'] != null
          ? int.parse(json['idtutor'].toString())
          : null,
      idestudiante: json['idestudiante'] != null
          ? int.parse(json['idestudiante'].toString())
          : null,
      usuariotutor: json['usuariotutor'] ?? '',
      nombres: json['nombres'] ?? '',
      apellidos: json['apellidos'] ?? '',
      cedula: json['cedula'] ?? '',
      correo: json['correo'] ?? '',
      edad: json['edad'] ?? '',
      fechanacimiento: json['fechanacimiento'] != null
          ? DateTime.parse(json['fechanacimiento'])
          : null,
      fecharegistro: json['fecharegistro'] != null
          ? DateTime.parse(json['fecharegistro'])
          : null,
      genero: json['genero'] ?? '',
      imagen: json['imagen'] ?? 'assets/img/cp.png',
      rol: json['rol'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idtutor': idtutor,
      'idestudiante': idestudiante,
      'usuariotutor': usuariotutor,
      'nombres': nombres,
      'apellidos': apellidos,
      'cedula': cedula,
      'correo': correo,
      'edad': edad,
      'fechanacimiento': fechanacimiento?.toIso8601String(),
      'fecharegistro': fecharegistro?.toIso8601String(),
      'genero': genero,
      'imagen': imagen,
      'rol': rol,
    };
  }
}
