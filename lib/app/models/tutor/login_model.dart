class Sesion {
  int? idtutor;
  int? idrepresentante;
  int? idestudiante;
  int? idnotificacion;
  String? usuario;
  String? pass;
  String token;
  String? cedula;
  String? rol;
  String? nombres;
  String? apellidos;
  String? imagen;
  String? correo;
  Sesion(
      {this.idtutor,
      this.idrepresentante,
      this.idnotificacion,
      this.idestudiante,
      this.cedula,
      this.usuario,
      this.pass,
      required this.token,
      this.rol,
      this.nombres,
      this.apellidos,
      this.correo,
      this.imagen});

  factory Sesion.fromJson(Map<String, dynamic> json) {
    return Sesion(
        idtutor: json['idtutor'] ?? 0,
        idrepresentante: json['idrepresentante'] ?? 0,
        idnotificacion: json['idnotificacion'] ?? 0,
        idestudiante: json['idestudiante'] ?? 0,
        cedula: json['cedula'] ?? '',
        usuario: json['usuario'] ?? '',
        pass: json['pass'] ?? '',
        token: json['token'] ?? '',
        rol: json['rol'] ?? '',
        nombres: json['nombres'] ??
            '', // Asegúrate de ajustar según la estructura del JSON
        apellidos: json['apellidos'] ?? '',
        correo: json['correo'] ?? '',
        imagen: json['imagen'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {
      'idtutor': idtutor,
      'idrepresentante': idrepresentante,
      'idnotificacion': idnotificacion,
      'idestudiante': idestudiante,
      'cedula': cedula,
      'usuario': usuario,
      'pass': pass,
      'token': token,
      'rol': rol,
      'nombres': nombres,
      'apellidos': apellidos,
      'correo': correo,
      'imagen': imagen
    };
  }
}
