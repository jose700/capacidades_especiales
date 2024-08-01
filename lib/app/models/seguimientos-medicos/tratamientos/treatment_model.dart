class Tratamiento {
  int? idtratamiento;
  int? idestudiante;
  String usuariotutor;
  String clasediscapacidad;
  String descripcionconsulta;
  DateTime fechaconsulta;
  String opinionpaciente;
  String tratamientopsicologico;
  String tratamientofisico;
  String? duraciontratamiento;
  String resultado;
  String? estudiante_nombres;
  String? estudiante_apellidos;
  String? estudiante_cedula;
  String? estudiante_imagen;
  Tratamiento(
      {required this.idtratamiento,
      required this.idestudiante,
      required this.usuariotutor,
      required this.clasediscapacidad,
      required this.descripcionconsulta,
      required this.fechaconsulta,
      required this.opinionpaciente,
      required this.tratamientopsicologico,
      required this.tratamientofisico,
      this.duraciontratamiento,
      required this.resultado,
      this.estudiante_nombres,
      this.estudiante_apellidos,
      this.estudiante_cedula,
      this.estudiante_imagen});
  factory Tratamiento.fromJson(Map<String, dynamic> json) {
    return Tratamiento(
      idtratamiento: json['idtratamiento'] != null
          ? int.parse(json['idtratamiento'].toString())
          : null,
      idestudiante: json['idestudiante'] != null
          ? int.parse(json['idestudiante'].toString())
          : null,
      usuariotutor: json['usuariotutor'] ?? '',
      clasediscapacidad: json['clasediscapacidad'] ?? '',
      descripcionconsulta: json['descripcionconsulta'] ?? '',
      fechaconsulta: json['fechaconsulta'] != null
          ? DateTime.parse(json['fechaconsulta'])
          : DateTime.now(),
      opinionpaciente: json['opinionpaciente'] ?? '',
      tratamientopsicologico: json['tratamientopsicologico'] ?? '',
      tratamientofisico: json['tratamientofisico'] ?? '',
      duraciontratamiento: json['duraciontratamiento'] ?? '',
      resultado: json['resultado'] ?? '',
      estudiante_nombres: json['estudiante_nombres'] ?? '',
      estudiante_apellidos: json['estudiante_apellidos'] ?? '',
      estudiante_cedula: json['estudiante_cedula'] ?? '',
      estudiante_imagen: json['estudiante_imagen'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idtratamiento': idtratamiento,
      'idestudiante': idestudiante,
      'usuariotutor': usuariotutor,
      'clasediscapacidad': clasediscapacidad,
      'descripcionconsulta': descripcionconsulta,
      'fechaconsulta': fechaconsulta.toIso8601String(),
      'opinionpaciente': opinionpaciente,
      'tratamientopsicologico': tratamientopsicologico,
      'tratamientofisico': tratamientofisico,
      'duraciontratamiento': duraciontratamiento,
      'resultado': resultado,
      'estudiante_nombres': estudiante_nombres,
      'estudiante_apellidos': estudiante_apellidos,
      'estudiante_cedula': estudiante_cedula,
      'estudiante_imagen': estudiante_imagen,
    };
  }
}
