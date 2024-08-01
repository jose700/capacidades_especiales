class MateriaAprobada {
  final int? idaprobada;
  final int? idreprobada;
  final int? idmateria;
  final int? idestudiante;
  final String? nombres;
  final String? apellidos;
  final String? cedula;
  final String? nombreMateria;
  final String? usuarioTutor;
  final String observacion;
  final double calificacion1;
  final double? calificacion2;
  final double? promedioFinal;
  final int? asistencia; // Cambiado a bool en el modelo Dart
  final DateTime fecha;
  final bool? aprobado;
  final String? estado_materia;
  MateriaAprobada(
      {this.idaprobada,
      this.idreprobada,
      this.idmateria,
      this.idestudiante,
      this.nombres,
      this.apellidos,
      this.cedula,
      this.nombreMateria,
      this.usuarioTutor,
      required this.observacion,
      required this.calificacion1,
      this.calificacion2,
      this.promedioFinal,
      this.asistencia,
      required this.fecha,
      this.aprobado,
      this.estado_materia});

  factory MateriaAprobada.fromJson(Map<String, dynamic> json) {
    return MateriaAprobada(
        idaprobada: json['idaprobada'],
        idreprobada: json['idreprobada'],
        idmateria: json['idmateria'] ?? 0,
        idestudiante: json['idestudiante'] ?? 0,
        nombres: json['nombres'],
        apellidos: json['apellidos'],
        cedula: json['cedula'],
        nombreMateria: json['nombre_materia'],
        usuarioTutor: json['usuariotutor'],
        observacion: json['observacion'],
        calificacion1: json['calificacion1'].toDouble(),
        calificacion2: json['calificacion2'].toDouble(),
        promedioFinal: json['promediofinal'].toDouble(),
        asistencia: json[
            'asistencia'], // Se asume que 'asistencia' es bool directamente
        fecha: DateTime.parse(json['fecha']),
        aprobado: json['aprobado'],
        estado_materia: json['estado_materia']);
  }

  Map<String, dynamic> toJson() {
    return {
      'idaprobada': idaprobada,
      'idreprobada': idreprobada,
      'idmateria': idmateria,
      'idestudiante': idestudiante,
      'nombres': nombres,
      'apellidos': apellidos,
      'cedula': cedula,
      'nombre_materia': nombreMateria,
      'usuariotutor': usuarioTutor,
      'observacion': observacion,
      'calificacion1': calificacion1,
      'calificacion2': calificacion2,
      'promediofinal': promedioFinal,
      'asistencia':
          asistencia, // Se asume que 'asistencia' es bool directamente
      'fecha': fecha.toIso8601String(),
      'aprobado': aprobado,
      'estado_materia': estado_materia
    };
  }
}
