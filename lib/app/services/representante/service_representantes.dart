import 'dart:convert';
import 'package:capacidades_especiales/app/utils/guards/apiKey.dart';
import 'package:capacidades_especiales/app/models/representantes/student_data_model.dart';
import 'package:capacidades_especiales/app/models/representantes/representative_model.dart';
import 'package:http/http.dart' as http;

class ServicioRepresentante {
  final String baseUrl = apiUrl;

  Future<List<Representante>> getRepresentantes(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/representantes'),
      headers: <String, String>{
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      List<Representante> representantes =
          body.map((dynamic item) => Representante.fromJson(item)).toList();
      return representantes;
    } else {
      throw Exception('Failed to load representantes');
    }
  }

  Future<List<Representante>> obtenerRepresentantesTutor(
      String usuario, String token) async {
    final List<Representante> representantes = await _fetchRepresentantes(
        '$baseUrl/representantes/tutor/$usuario', token);
    return representantes;
  }

  Future<List<Representante>> _fetchRepresentantes(
      String endpoint, String token) async {
    final response = await http.get(
      Uri.parse(endpoint),
      headers: <String, String>{
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      List<dynamic> representantesJson = jsonDecode(response.body);
      List<Representante> representantes = representantesJson
          .map((representantesJson) =>
              Representante.fromJson(representantesJson))
          .toList();
      return representantes;
    } else {
      throw Exception('Fallo al cargar los estudiantes');
    }
  }

  Future<void> crearRepresentante(
      Representante representante, String token) async {
    final response = await _postData(
        '$baseUrl/representantes', representante.toJson(), token);

    if (response.statusCode == 201 || response.statusCode == 200) {
      // Representante creado exitosamente, manejar aquí si es necesario
      print('Representante creado: ${response.body}');
    } else {
      print('Error al crear el representante: ${response.body}');
      throw Exception('Fallo al crear al representante: ${response.body}');
    }
  }

  Future<http.Response> _postData(
      String url, dynamic data, String token) async {
    final response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(data),
    );
    return response;
  }

  Future<void> eliminarRepresentante(
      String idrepresentante, String token) async {
    final response = await http.delete(
        Uri.parse('$baseUrl/representantes/$idrepresentante'),
        headers: <String, String>{
          'Authorization': 'Bearer $token',
        });

    _checkResponseStatusCode(response, 200, 'Fallo al eliminar el estudiante');
  }

  Future<Representante> buscarPorCedula(String cedula, String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/representantes/$cedula'),
      headers: <String, String>{
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return Representante.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to find representante by cedula');
    }
  }

  void _checkResponseStatusCode(
      http.Response response, int expectedStatusCode, String errorMessage) {
    if (response.statusCode != expectedStatusCode) {
      throw Exception(errorMessage);
    }
  }

  Future<void> actualizarRepresentante(
      int idrepresentante, Representante representante, String token) async {
    final response = await _putData('$baseUrl/representantes/$idrepresentante',
        representante.toJson(), token);
    _checkResponseStatusCode(
        response, 200, 'Fallo al actualizar el representante');
  }

  Future<http.Response> _putData(String url, dynamic data, String token) async {
    final response = await http.put(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(data),
    );
    return response;
  }

  Future<bool> existeCedula(String cedula, String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/representantes/cedula/$cedula'),
      headers: <String, String>{
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      // Si el estado de la respuesta es 200, significa que la cédula existe
      return true;
    } else if (response.statusCode == 404) {
      // Si el estado de la respuesta es 404, significa que la cédula no existe
      return false;
    } else {
      // En caso de cualquier otro código de estado, lanzamos una excepción
      throw Exception('Error al verificar la existencia de la cédula');
    }
  }

  Future<DatosEstudiante> obtenerEstudiantePorUsuarioRepresentante(
      String usuarioRepresentante, String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/representante/estudiante/$usuarioRepresentante'),
      headers: <String, String>{
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      // Convertir el cuerpo de la respuesta JSON a un mapa
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);

      // Crear una instancia de DatosEstudiante usando el constructor fromJson
      DatosEstudiante datosEstudiante = DatosEstudiante.fromJson(jsonResponse);

      return datosEstudiante;
    } else {
      throw Exception('Failed to load estudiante');
    }
  }
}
