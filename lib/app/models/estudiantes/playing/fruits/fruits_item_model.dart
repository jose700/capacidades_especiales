class Fruit {
  final String nombre;
  final int id;
  final String familia;
  final String orden;
  final String genero;
  final Nutricion nutricion;
  final String imagen;

  Fruit({
    required this.nombre,
    required this.id,
    required this.familia,
    required this.orden,
    required this.genero,
    required this.nutricion,
    required this.imagen,
  });

  factory Fruit.fromJson(Map<String, dynamic> json) {
    return Fruit(
      nombre: json['nombre'],
      id: json['id'],
      familia: json['familia'],
      orden: json['orden'],
      genero: json['género'],
      nutricion: Nutricion.fromJson(json['nutrición']),
      imagen: json['imagen'],
    );
  }
}

class Nutricion {
  final int calorias;
  final double grasa;
  final double azucar;
  final double carbohidratos;
  final double proteina;

  Nutricion({
    required this.calorias,
    required this.grasa,
    required this.azucar,
    required this.carbohidratos,
    required this.proteina,
  });

  factory Nutricion.fromJson(Map<String, dynamic> json) {
    return Nutricion(
      calorias: json['calorías'],
      grasa: json['grasa'].toDouble(),
      azucar: json['azúcar'].toDouble(),
      carbohidratos: json['carbohidratos'].toDouble(),
      proteina: json['proteína'].toDouble(),
    );
  }
}
