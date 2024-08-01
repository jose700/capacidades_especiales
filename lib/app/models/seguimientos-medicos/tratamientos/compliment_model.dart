class TratamientoCumplido {
  final int? idcumplido;
  final int? idnocumplido;
  final int? idtratamiento;
  final int? idestudiante;
  String usuariotutor;
  final String observacion;
  final DateTime fechainicio;
  final DateTime fechafin;
  final bool? cumplimiento;
  String? estudiante_nombres;
  String? estudiante_apellidos;
  String? estudiante_cedula;
  String? estudiante_imagen;
  String? tratamientopsicologico;
  String? tratamientofisico;
  TratamientoCumplido(
      {this.idcumplido,
      this.idnocumplido,
      this.idtratamiento,
      this.idestudiante,
      required this.usuariotutor,
      required this.observacion,
      required this.fechainicio,
      required this.fechafin,
      this.cumplimiento,
      this.estudiante_nombres,
      this.estudiante_apellidos,
      this.estudiante_cedula,
      this.estudiante_imagen,
      this.tratamientofisico,
      this.tratamientopsicologico});

  factory TratamientoCumplido.fromJson(Map<String, dynamic> json) {
    return TratamientoCumplido(
      idcumplido: json['idcumplido'],
      idnocumplido: json['idnocumplido'],
      idtratamiento: json['idtratamiento'],
      idestudiante: json['idestudiante'],
      usuariotutor: json['usuariotutor'],
      observacion: json['observacion'],
      fechainicio: DateTime.parse(json['fechainicio']),
      fechafin: DateTime.parse(json['fechafin']),
      cumplimiento: json['cumplimiento'],
      estudiante_nombres: json['nombres'] ?? '',
      estudiante_apellidos: json['apellidos'] ?? '',
      estudiante_cedula: json['ci'] ?? '',
      estudiante_imagen: json['imagen'] ?? '',
      tratamientopsicologico: json['tratamientopsicologico'] ?? '',
      tratamientofisico: json['tratamientofisico'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idconsulta': idcumplido,
      'idnocumplido': idnocumplido,
      'idtratamiento': idtratamiento,
      'idestudiante': idestudiante,
      'usuariotutor': usuariotutor,
      'observacion': observacion,
      'fechainicio': fechainicio.toIso8601String(),
      'fechafin': fechafin.toIso8601String(),
      'cumplimiento': cumplimiento,
    };
  }
}
