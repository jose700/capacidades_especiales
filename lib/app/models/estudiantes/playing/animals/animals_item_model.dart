class Animal {
  final String nombre;
  final String especie;
  final String habitat;
  final String alimentacion;
  final String imagen;
  final InformacionAdicional informacionAdicional;

  Animal({
    required this.nombre,
    required this.especie,
    required this.habitat,
    required this.alimentacion,
    required this.imagen,
    required this.informacionAdicional,
  });

  factory Animal.fromJson(Map<String, dynamic> json) {
    return Animal(
      nombre: json['nombre'],
      especie: json['especie'],
      habitat: json['habitat'],
      alimentacion: json['alimentación'],
      imagen: json['imagen'] ?? 'assets/img/cp.png',
      informacionAdicional:
          InformacionAdicional.fromJson(json['informacion_adicional']),
    );
  }
}

class InformacionAdicional {
  final String promedioVida;
  final String estadoConservacion;
  final String distribucion;

  InformacionAdicional({
    required this.promedioVida,
    required this.estadoConservacion,
    required this.distribucion,
  });

  factory InformacionAdicional.fromJson(Map<String, dynamic> json) {
    return InformacionAdicional(
      promedioVida: json['promedio_vida'],
      estadoConservacion: json['estado_conservacion'],
      distribucion: json['distribucion'],
    );
  }
}
