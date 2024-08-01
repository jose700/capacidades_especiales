class TareaEstudiante {
  final int? idTarea;
  final int? id;
  final int? idMateria;
  final DateTime? fechaCreoTarea;

  final String? titulo_tarea;
  final String? informacionTarea;
  final double? calificacion;
  final String? comentarios;
  final String? categoriaMejora;
  final String? archivoNombre;
  final String? archivoMimeType;
  final String? nombresEstudiante;
  final String? apellidosEstudiante;
  final String? cedulaEstudiante;
  final String? correoEstudiante;
  final String? imagenEstudiante;
  final String? nombreMateria;
  final DateTime? fecha_envio_tarea_subida;
  final String? archivo_nombre_subida;
  final String? archivo_mimetype_subida;
  final bool? tarea_cumplida_subida;
  final String? archivo_url;

  TareaEstudiante(
      {this.idTarea,
      this.id,
      this.idMateria,
      this.fechaCreoTarea,
      this.titulo_tarea,
      this.informacionTarea,
      this.calificacion,
      this.comentarios,
      this.categoriaMejora,
      this.archivoNombre,
      this.archivoMimeType,
      this.nombresEstudiante,
      this.apellidosEstudiante,
      this.cedulaEstudiante,
      this.correoEstudiante,
      this.imagenEstudiante,
      this.nombreMateria,
      this.fecha_envio_tarea_subida,
      this.archivo_nombre_subida,
      this.archivo_mimetype_subida,
      this.tarea_cumplida_subida,
      this.archivo_url});

  factory TareaEstudiante.fromJson(Map<String, dynamic> json) {
    return TareaEstudiante(
        idTarea: json['idtarea'],
        id: json['id'],
        idMateria: json['idmateria'],
        fechaCreoTarea: json['fecha_creo_tarea'] != null
            ? DateTime.parse(json['fecha_creo_tarea'])
            : null,
        titulo_tarea: json['titulo_tarea'],
        informacionTarea: json['informacion_tarea'],
        calificacion: json['calificacion']?.toDouble(),
        comentarios: json['comentarios'],
        categoriaMejora: json['categoria_mejora'],
        archivoNombre: json['archivo_nombre'],
        archivoMimeType: json['archivo_mimetype'],
        nombresEstudiante: json['nombres_estudiante'],
        apellidosEstudiante: json['apellidos_estudiante'],
        cedulaEstudiante: json['cedula_estudiante'],
        correoEstudiante: json['correo_estudiante'],
        imagenEstudiante: json['imagen_estudiante'],
        nombreMateria: json['nombre_materia'],
        fecha_envio_tarea_subida: json['fecha_envio_tarea_subida'] != null
            ? DateTime.parse(json['fecha_envio_tarea_subida'])
            : null,
        archivo_nombre_subida: json['archivo_nombre_subida'],
        archivo_mimetype_subida: json['archivo_mimetype_subida'],
        tarea_cumplida_subida: json['tarea_cumplida_subida'],
        archivo_url: json['archivo_url']);
  }

  Map<String, dynamic> toJson() {
    return {
      'idtarea': idTarea,
      'id': id,
      'idmateria': idMateria,
      'fecha_creo_tarea': fechaCreoTarea?.toIso8601String(),
      'titulo_tarea': titulo_tarea,
      'informacion_tarea': informacionTarea,
      'calificacion': calificacion,
      'comentarios': comentarios,
      'categoria_mejora': categoriaMejora,
      'archivo_nombre': archivoNombre,
      'archivo_mimetype': archivoMimeType,
      'nombres_estudiante': nombresEstudiante,
      'apellidos_estudiante': apellidosEstudiante,
      'cedula_estudiante': cedulaEstudiante,
      'correo_estudiante': correoEstudiante,
      'imagen_estudiante': imagenEstudiante,
      'nombre_materia': nombreMateria,
      'fecha_envio_tarea_subida': fecha_envio_tarea_subida?.toIso8601String(),
      'archivo_nombre_subida': archivo_nombre_subida,
      'archivo_mimetype_subida': archivo_mimetype_subida,
      'tarea_cumplida_subida': tarea_cumplida_subida,
      'archivo_url': archivo_url
    };
  }

  // Búsqueda
  bool containsQuery(String query) {
    final lowerCaseQuery = query.toLowerCase();
    return (nombreMateria?.toLowerCase().contains(lowerCaseQuery) ?? false) ||
        (fechaCreoTarea?.toString().contains(query) ?? false) ||
        (titulo_tarea?.toLowerCase().contains(lowerCaseQuery) ?? false) ||
        (informacionTarea?.toLowerCase().contains(lowerCaseQuery) ?? false) ||
        (calificacion?.toString().contains(query) ?? false) ||
        (comentarios?.toLowerCase().contains(lowerCaseQuery) ?? false) ||
        (categoriaMejora?.toLowerCase().contains(lowerCaseQuery) ?? false) ||
        (archivoNombre?.toLowerCase().contains(lowerCaseQuery) ?? false) ||
        (archivoMimeType?.toLowerCase().contains(lowerCaseQuery) ?? false) ||
        (nombresEstudiante?.toLowerCase().contains(lowerCaseQuery) ?? false) ||
        (apellidosEstudiante?.toLowerCase().contains(lowerCaseQuery) ??
            false) ||
        (correoEstudiante?.toLowerCase().contains(lowerCaseQuery) ?? false);
  }
}
