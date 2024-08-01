import 'dart:convert';
import 'package:capacidades_especiales/app/utils/guards/apiKey.dart';
import 'package:capacidades_especiales/app/models/estudiantes/student_model.dart';
import 'package:capacidades_especiales/app/models/tutor/login_model.dart';
import 'package:http/http.dart' as http;

class ServicioEstudiante {
  final String baseUrl = apiUrl; //Obtenemos la api de nuestro archivo

  //login estudiante
  Future<Sesion> iniciarSesionEstudiante(String cedula) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/loginEstudiante'),
        body: jsonEncode({'cedula': cedula}),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final token = responseData['token'];
        final idestudiante = responseData['idestudiante'];
        final nombres = responseData['nombres'];
        final apellidos = responseData['apellidos'];

        // Crear el objeto Sesion con la ID del estudiante, nombres y apellidos
        final sesion = Sesion(
          idestudiante: idestudiante,
          cedula: cedula,
          token: token,
          rol: responseData['rol'],
          nombres: nombres,
          apellidos: apellidos,
        );

        print('Inicio de sesión exitoso: $cedula, token: $token');
        return sesion;
      } else {
        throw Exception('Error al iniciar sesión: ${response.statusCode}');
      }
    } catch (e) {
      print('Error al iniciar sesión: $e');
      throw Exception('Error al iniciar sesión: $e');
    }
  }

  Future<List<Estudiante>> obtenerEstudiantesTutor(
      String usuario, String token) async {
    try {
      return await _fetchEstudiantes(
          '$baseUrl/estudiantes/tutor/$usuario', token);
    } catch (e) {
      print('Error en obtenerEstudiantesTutor: $e');
      throw Exception('Fallo al cargar los estudiantes');
    }
  }

  Future<List<Estudiante>> getEstudiantes(int idTutor, String token) async {
    try {
      return await _fetchEstudiantes(
          '$baseUrl/estudiantes/tutor/$idTutor', token);
    } catch (e) {
      print('Error en getEstudiantes: $e');
      throw Exception('Fallo al cargar los estudiantes');
    }
  }

  Future<List<Estudiante>> _fetchEstudiantes(
      String endpoint, String token) async {
    try {
      final response = await http.get(
        Uri.parse(endpoint),
        headers: <String, String>{
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> estudiantesJson = jsonDecode(response.body);
        List<Estudiante> estudiantes = estudiantesJson
            .map((estudianteJson) => Estudiante.fromJson(estudianteJson))
            .toList();
        return estudiantes;
      } else {
        throw Exception(
            'Fallo al cargar los estudiantes: ${response.statusCode}');
      }
    } catch (e) {
      print('Error en _fetchEstudiantes: $e');
      throw Exception('Error al cargar los estudiantes: $e');
    }
  }

  Future<void> crearEstudiante(Estudiante estudiante, String token) async {
    try {
      final response =
          await _postData('$baseUrl/estudiantes', estudiante.toJson(), token);

      if (response.statusCode == 201 || response.statusCode == 200) {
        // Estudiante creado exitosamente, manejar aquí si es necesario
        print('Estudiante creado: ${response.body}');
      } else {
        print('Error al crear el estudiante: ${response.body}');
        throw Exception('Fallo al crear al estudiante: ${response.statusCode}');
      }
    } catch (e) {
      print('Error al crear estudiante: $e');
      throw Exception('Error al crear estudiante: $e');
    }
  }

  Future<http.Response> _postData(
      String url, dynamic data, String token) async {
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(data),
      );
      return response;
    } catch (e) {
      print('Error en _postData: $e');
      throw Exception('Error al enviar datos: $e');
    }
  }

  Future<void> eliminarEstudiante(String idEstudiante, String token) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/estudiantes/$idEstudiante'),
        headers: <String, String>{
          'Authorization': 'Bearer $token',
        },
      );

      _checkResponseStatusCode(
          response, 200, 'Fallo al eliminar el estudiante');
    } catch (e) {
      print('Error al eliminar estudiante: $e');
      throw Exception('Error al eliminar estudiante: $e');
    }
  }

  Future<void> actualizarEstudiante(
      int idEstudiante, Estudiante estudiante, String token) async {
    try {
      final response = await _putData(
          '$baseUrl/estudiantes/$idEstudiante', estudiante.toJson(), token);
      _checkResponseStatusCode(
          response, 200, 'Fallo al actualizar el estudiante');
    } catch (e) {
      print('Error al actualizar estudiante: $e');
      throw Exception('Error al actualizar estudiante: $e');
    }
  }

  Future<List<dynamic>> buscarEstudiantes(
      String parametro, String valor, String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/estudiantes?$parametro=$valor'),
        headers: <String, String>{
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception(
            'Fallo al cargar los estudiantes: ${response.statusCode}');
      }
    } catch (e) {
      print('Error en buscarEstudiantes: $e');
      throw Exception('Error al cargar los estudiantes: $e');
    }
  }

  Future<http.Response> _putData(String url, dynamic data, String token) async {
    try {
      final response = await http.put(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(data),
      );
      return response;
    } catch (e) {
      print('Error en _putData: $e');
      throw Exception('Error al enviar datos: $e');
    }
  }

  void _checkResponseStatusCode(
      http.Response response, int expectedStatusCode, String errorMessage) {
    if (response.statusCode != expectedStatusCode) {
      print(
          'Error en _checkResponseStatusCode: ${response.statusCode} - ${response.body}');
      throw Exception(errorMessage);
    }
  }
}
