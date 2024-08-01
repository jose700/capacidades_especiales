class Representante {
  int? idrepresentante;
  int? idestudiante;
  String? usuariotutor;
  String? representandoNombres;
  String? representandoApellidos;
  String? nombres;
  String? apellidos;
  String? cedula;
  String? correo;
  String? estadocivil;
  String? ocupacion;
  String? imagen;
  String? numberphone;
  String? usuario;
  String? pass;
  String? token;
  String? rol;

  Representante({
    this.idrepresentante,
    this.idestudiante,
    this.usuariotutor,
    this.representandoNombres,
    this.representandoApellidos,
    this.nombres,
    this.apellidos,
    this.cedula,
    this.correo,
    this.estadocivil,
    this.ocupacion,
    this.imagen,
    this.numberphone,
    this.usuario,
    this.pass,
    this.token,
    this.rol,
  });

  factory Representante.fromJson(Map<String, dynamic> json) {
    return Representante(
      idrepresentante: json['idrepresentante'] != null
          ? int.parse(json['idrepresentante'].toString())
          : null,
      idestudiante: json['idestudiante'] != null
          ? int.parse(json['idestudiante'].toString())
          : null,
      usuariotutor: json['usuariotutor'] ?? '',
      representandoNombres: json['representado_nombre'] ?? '',
      representandoApellidos: json['representado_apellidos'] ?? '',
      nombres: json['nombres'] ?? '',
      apellidos: json['apellidos'] ?? '',
      cedula: json['cedula'] ?? '',
      correo: json['correo'] ?? '',
      estadocivil: json['estadocivil'] ?? '',
      ocupacion: json['ocupacion'] ?? '',
      imagen: json['imagen'] ?? 'assets/img/cp.png',
      numberphone: json['numberphone'] ?? '',
      usuario: json['usuario'] ?? '',
      pass: json['pass'] ?? '',
      token: json['token'] ?? '',
      rol: json['rol'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idrepresentante': idrepresentante,
      'idestudiante': idestudiante,
      'usuariotutor': usuariotutor,
      'representado_nombre': representandoNombres,
      'representado_apellidos': representandoApellidos,
      'nombres': nombres,
      'apellidos': apellidos,
      'cedula': cedula,
      'correo': correo,
      'estadocivil': estadocivil,
      'ocupacion': ocupacion,
      'imagen': imagen,
      'numberphone': numberphone,
      'usuario': usuario,
      'pass': pass,
      'token': token,
      'rol': rol,
    };
  }
}
