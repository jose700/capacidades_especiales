import 'dart:convert';
import 'dart:developer';
import 'package:capacidades_especiales/app/models/seguimientos-academicos/inscripcion/inscription_assignatura_model.dart';
import 'package:http/http.dart' as http;
import 'package:capacidades_especiales/app/utils/guards/apiKey.dart';

class ServicioInscripcionMateria {
  final String url = apiUrl;

  Future<void> crearInscripcion(
      InscripcionMateria inscripcion, String token) async {
    final response =
        await _postData('$apiUrl/inscripciones', inscripcion.toJson(), token);

    if (response.statusCode == 201 || response.statusCode == 200) {
      log('Inscripción creada correctamente: ${response.body}');
    } else {
      log('Error al crear la inscripción: ${response.body}');
      throw Exception('Fallo al crear la inscripción: ${response.body}');
    }
  }

  Future<http.Response> _postData(
      String url, dynamic data, String token) async {
    final response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token', // Incluyendo el token en los headers
      },
      body: jsonEncode(data),
    );

    // Imprimir detalles del POST
    print('POST $url - Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');

    return response;
  }

  Future<List<InscripcionMateria>> obtenerInscripcionesTutor(
      String usuario, String token) async {
    final List<InscripcionMateria> materias = await _fetchInscripciones(
        '$apiUrl/inscripciones/tutor/$usuario', token);

    // Imprimir detalles de las inscripciones obtenidas
    print('Inscripciones obtenidas para el tutor $usuario: ${materias.length}');

    return materias;
  }

  Future<List<InscripcionMateria>> _fetchInscripciones(
      String endpoint, String token) async {
    final response = await http.get(
      Uri.parse(endpoint),
      headers: <String, String>{
        'Authorization': 'Bearer $token', // Incluyendo el token en los headers
      },
    );

    // Imprimir detalles del GET
    print('GET $endpoint - Status Code: ${response.statusCode}');

    if (response.statusCode == 200) {
      List<dynamic> materiasJson = jsonDecode(response.body);
      List<InscripcionMateria> inscripciones = materiasJson
          .map((materiaJson) => InscripcionMateria.fromJson(materiaJson))
          .toList();

      // Imprimir la primera materia como ejemplo
      if (inscripciones.isNotEmpty) {
        print('Ejemplo de inscripción obtenida: ${inscripciones[0]}');
      }

      return inscripciones;
    } else {
      // Imprimir el código de estado en caso de error
      print('Error - Código de estado: ${response.statusCode}');
      throw Exception('Fallo al cargar las inscripciones');
    }
  }

  Future<void> eliminarInscripcionMateria(
      String idInscripcion, String token) async {
    final response = await http.delete(
      Uri.parse('$apiUrl/inscripciones/$idInscripcion'),
      headers: <String, String>{
        'Authorization': 'Bearer $token', // Incluyendo el token en los headers
      },
    );

    // Imprimir detalles de la eliminación
    print('DELETE $url - Status Code: ${response.statusCode}');

    _checkResponseStatusCode(response, 200, 'Fallo al eliminar la inscripción');
  }

  void _checkResponseStatusCode(
      http.Response response, int expectedStatusCode, String errorMessage) {
    if (response.statusCode != expectedStatusCode) {
      throw Exception(errorMessage);
    }
  }

  Future<void> actualizarInscripcion(
      int idInscripcion, InscripcionMateria inscripcion, String token) async {
    final response = await _putData(
        '$apiUrl/inscripciones/$idInscripcion', inscripcion.toJson(), token);

    // Imprimir detalles de la actualización
    print('PUT $url - Status Code: ${response.statusCode}');

    _checkResponseStatusCode(
        response, 200, 'Fallo al actualizar la inscripción');
  }

  Future<http.Response> _putData(String url, dynamic data, String token) async {
    final response = await http.put(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token', // Incluyendo el token en los headers
      },
      body: jsonEncode(data),
    );

    // Imprimir detalles del PUT
    print('PUT $url - Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');

    return response;
  }

  Future<List<InscripcionMateria>> obtenerInscripcionesEstudiantes(
      String cedula, String token) async {
    final List<InscripcionMateria> materias =
        await _fetchInscripcionesEstudiantes(
            '$apiUrl/inscripciones/estudiante/$cedula', token);

    // Imprimir detalles de las inscripciones obtenidas por estudiante
    print(
        'Inscripciones obtenidas para el estudiante $cedula: ${materias.length}');

    return materias;
  }

  Future<List<InscripcionMateria>> _fetchInscripcionesEstudiantes(
      String endpoint, String token) async {
    final response = await http.get(
      Uri.parse(endpoint),
      headers: <String, String>{
        'Authorization': 'Bearer $token', // Incluyendo el token en los headers
      },
    );

    // Imprimir detalles del GET por estudiante
    print('GET $endpoint - Status Code: ${response.statusCode}');

    if (response.statusCode == 200) {
      List<dynamic> materiasJson = jsonDecode(response.body);
      List<InscripcionMateria> inscripciones = materiasJson
          .map((materiaJson) => InscripcionMateria.fromJson(materiaJson))
          .toList();

      // Imprimir la primera inscripción como ejemplo
      if (inscripciones.isNotEmpty) {
        print('Ejemplo de inscripción obtenida: ${inscripciones[0]}');
      }

      return inscripciones;
    } else {
      // Imprimir el código de estado en caso de error
      print('Error - Código de estado: ${response.statusCode}');
      throw Exception('Fallo al cargar las inscripciones');
    }
  }
}
