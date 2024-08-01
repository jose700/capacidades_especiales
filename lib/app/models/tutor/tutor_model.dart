class Tutor {
  int? idTutor; // Podría ser opcional si es autoincremental
  String nombres;
  String apellidos;
  String cedula;
  String correo;
  String usuario;
  String pass;
  String? imagen;
  String? rol;

  Tutor(
      {required this.idTutor,
      required this.nombres,
      required this.apellidos,
      required this.cedula,
      required this.correo,
      required this.usuario,
      required this.pass,
      this.imagen,
      this.rol});

  factory Tutor.fromJson(Map<String, dynamic> json) {
    return Tutor(
        idTutor: json['idtutor'] ?? 0,
        nombres: json['nombres'] ?? '',
        apellidos: json['apellidos'] ?? '',
        cedula: json['cedula'] ?? '',
        correo: json['correo'] ?? '',
        usuario: json['usuario'] ?? '',
        pass: json['pass'] ?? '',
        imagen: json['imagen'],
        rol: json['rol']);
  }

  Map<String, dynamic> toJson() {
    return {
      'idtutor': idTutor,
      'nombres': nombres,
      'apellidos': apellidos,
      'cedula': cedula,
      'correo': correo,
      'usuario': usuario,
      'pass': pass,
      'imagen': imagen,
      'rol': rol
    };
  }
}
