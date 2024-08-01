import 'package:flutter/material.dart';

class Notificacion {
  final int idnotificacion;
  final int idtutor;

  final int? idrepresentante; // Cambiado a List<int>
  final int? idestudiante;
  final String mensaje;
  final bool esEvento;
  final String? tituloEvento;
  final DateTime? fechaEvento;
  final TimeOfDay? horaEvento;
  late bool leida;
  final String? representanteNombres;
  final String? representanteApellidos;
  final DateTime fechaEnvio;
  final String? usuarioTutor;

  Notificacion({
    required this.idnotificacion,
    required this.idtutor,
    this.idrepresentante,
    this.idestudiante,
    required this.mensaje,
    required this.esEvento,
    this.tituloEvento,
    this.fechaEvento,
    this.horaEvento,
    required this.leida,
    this.representanteNombres,
    this.representanteApellidos,
    this.usuarioTutor,
    required this.fechaEnvio,
  });

  factory Notificacion.fromJson(Map<String, dynamic> json) {
    return Notificacion(
      idnotificacion: json['idnotificacion'],
      idtutor: json['idtutor'],
      idrepresentante: json['idrepresentante'],
      idestudiante: json['idestudiante'],
      mensaje: json['mensaje'],
      esEvento: json['es_evento'],
      tituloEvento: json['titulo_evento'],
      fechaEvento: json['fecha_evento'] != null
          ? DateTime.parse(json['fecha_evento'])
          : null,
      horaEvento: json['hora_evento'] != null
          ? parseTimeOfDay(json['hora_evento'])
          : null,
      leida: json['leida'],
      representanteNombres: json['representantenombres'],
      representanteApellidos: json['representanteapellidos'],
      fechaEnvio: DateTime.parse(json['fecha_envio']),
      usuarioTutor: json['usuariotutor'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idnotificacion': idnotificacion,
      'idtutor': idtutor,
      'idrepresentante': idrepresentante,
      'idestudiante': idestudiante,
      'mensaje': mensaje,
      'es_evento': esEvento,
      'titulo_evento': tituloEvento,
      'fecha_evento':
          fechaEvento?.toIso8601String(), // Convertir fecha a ISO 8601
      'hora_evento': horaEvento != null
          ? '${horaEvento!.hour}:${horaEvento!.minute}'
          : null,
      'leida': leida,
      'representantenombres': representanteNombres,
      'representanteapellidos': representanteApellidos,
      'fecha_envio': fechaEnvio.toIso8601String(),
      'usuariotutor': usuarioTutor,
    };
  }

  static TimeOfDay parseTimeOfDay(String? timeString) {
    if (timeString == null) return TimeOfDay(hour: 0, minute: 0);
    List<String> parts = timeString.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }
}
