import 'dart:convert';
import 'package:capacidades_especiales/app/utils/guards/apiKey.dart';
import 'package:capacidades_especiales/app/models/tutor/login_model.dart';
import 'package:capacidades_especiales/app/models/tutor/tutor_model.dart';
import 'package:http/http.dart' as http;

class RegisterLoginService {
  final String baseUrl = apiUrl; //Obtenemos la api de nuestro archivo
//Iniciar sesión
  Future<Sesion> iniciarSesion(String usuario, String pass) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/logintutor'),
        body: jsonEncode({'usuario': usuario, 'pass': pass}),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final token = responseData['token'];
        final idtutor = responseData['idtutor'];
        final idrepresentante = responseData['idrepresentante'];
        final idestudiante = responseData['idestudiante'];
        final rol = responseData['rol'];
        final nombres = responseData['nombres'];
        final apellidos = responseData['apellidos'];
        final correo = responseData['correo'];
        final imagen = responseData['imagen'];

        // Crear el objeto Sesion con la ID del tutor, representante o estudiante
        final sesion = Sesion(
          idtutor: idtutor,
          idrepresentante: idrepresentante,
          idestudiante: idestudiante,
          usuario: usuario,
          pass: pass,
          token: token,
          rol: rol, // Asegúrate de ajustar según la estructura del JSON
          nombres: nombres,
          apellidos: apellidos,
          correo: correo,
          imagen: imagen,
        );

        print('Inicio de sesión exitoso: $usuario, token: $token');
        return sesion;
      } else {
        throw Exception('Error al iniciar sesión: ${response.statusCode}');
      }
    } catch (e) {
      print('Error al iniciar sesión: $e');
      throw Exception('Error al iniciar sesión: $e');
    }
  }

  // Obtener idTutor o idRepresentante del usuario logueado a partir del token
  Future<int?> obtenerIdTutor(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/obtener-id'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return responseData['idtutor'];
      } else if (response.statusCode == 401) {
        // Si el servidor devuelve 401 Unauthorized, el token podría ser inválido o expirado
        throw Exception('Token inválido o expirado');
      } else {
        throw Exception('Error al obtener idtutor: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error al obtener idtutor: $e');
    }
  }

  Future<int?> obtenerIdRepresentante(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/obtener-id'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return responseData['idrepresentante'];
      } else if (response.statusCode == 401) {
        // Si el servidor devuelve 401 Unauthorized, el token podría ser inválido o expirado
        throw Exception('Token inválido o expirado');
      } else {
        throw Exception(
            'Error al obtener idrepresentante: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error al obtener idrepresentante: $e');
    }
  }

  //crear registro
  Future<int?> crearRegistro(Map<String, dynamic> tutorData) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/tutores'),
        body: jsonEncode(tutorData),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 201) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        return responseData['idTutor']; // Devuelve la id del tutor registrada
      } else {
        throw Exception('Error al crear el registro: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error al crear el registro: $e');
    }
  }

  //obtener el perfil del tutor
  Future<Tutor?> obtenerTutor(int idtutor) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/tutor/$idtutor/perfil'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return Tutor.fromJson(responseData);
      } else {
        throw Exception('Error al obtener el tutor: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error al obtener el tutor: $e');
    }
  }

  //Obtener perfil del tutor logueado
  Future<Sesion> obtenerPerfil(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/tutor/logueado'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      // Si la solicitud es exitosa, devolver el objeto Sesion sin la contraseña
      final responseData = jsonDecode(response.body);
      return Sesion(
        idtutor: responseData['idtutor'],
        idrepresentante: responseData['idrepresentante'],
        usuario: responseData['usuario'],
        token: token,
        rol: responseData['rol'],
      );
    } else {
      // Si hay un error, lanzar una excepción
      throw Exception('Error al obtener perfil del usuario');
    }
  }

  // Obtener perfil del tutor por usuario
  Future<Tutor?> obtenerPerfilTutorPorUsuario(String usuario) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/tutor/logueado/$usuario'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return Tutor.fromJson(responseData);
      } else {
        throw Exception(
            'Error al obtener el perfil del tutor: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error al obtener el perfil del tutor: $e');
    }
  }

  //actualizar perfil tutor
  Future<void> actualizarPerfilTutor(
      int idtutor, Map<String, dynamic> tutorData) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/tutor/logueado/$idtutor'),
        body: jsonEncode(tutorData),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        print('Perfil del tutor actualizado con éxito');
      } else {
        throw Exception(
            'Error al actualizar el perfil del tutor: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error al actualizar el perfil del tutor: $e');
    }
  }
}
