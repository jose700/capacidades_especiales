import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:capacidades_especiales/app/models/seguimientos-academicos/materias/assignature_model.dart';
import 'package:capacidades_especiales/app/utils/guards/apiKey.dart';

class ServicioMateria {
  final String url = apiUrl;

  Future<void> crearMateria(Materia materia, String token) async {
    final response =
        await _postData('$apiUrl/materias', materia.toJson(), token);

    if (response.statusCode == 201 || response.statusCode == 200) {
      log('Materia creada correctamente: ${response.body}');
    } else {
      log('Error al crear la materia: ${response.body}');
      throw Exception('Fallo al crear la materia: ${response.body}');
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
    return response;
  }

  Future<List<Materia>> obtenerMateriasTutor(
      String usuario, String token) async {
    final List<Materia> materias =
        await _fetchMaterias('$apiUrl/materias/tutor/$usuario', token);
    return materias;
  }

  Future<List<Materia>> _fetchMaterias(String endpoint, String token) async {
    final response = await http.get(
      Uri.parse(endpoint),
      headers: <String, String>{
        'Authorization': 'Bearer $token', // Incluyendo el token en los headers
      },
    );
    if (response.statusCode == 200) {
      List<dynamic> materiasJson = jsonDecode(response.body);
      List<Materia> materias = materiasJson
          .map((materiaJson) => Materia.fromJson(materiaJson))
          .toList();
      return materias;
    } else {
      throw Exception('Fallo al cargar las materias');
    }
  }

  Future<List<Materia>> obtenerMateriasPorEstudiante(
      String idestudiante, String token) async {
    final List<Materia> materias = await _fetchMaterias(
        '$apiUrl/materias/estudiante/$idestudiante', token);
    return materias;
  }

  Future<void> eliminarMateria(String idMateria, String token) async {
    final response = await http.delete(
      Uri.parse('$apiUrl/materias/$idMateria'),
      headers: <String, String>{
        'Authorization': 'Bearer $token', // Incluyendo el token en los headers
      },
    );

    _checkResponseStatusCode(response, 200, 'Fallo al eliminar la materia');
  }

  void _checkResponseStatusCode(
      http.Response response, int expectedStatusCode, String errorMessage) {
    if (response.statusCode != expectedStatusCode) {
      throw Exception(errorMessage);
    }
  }

  Future<void> actualizarMateria(
      int idMateria, Materia materia, String token) async {
    final response =
        await _putData('$apiUrl/materias/$idMateria', materia.toJson(), token);
    _checkResponseStatusCode(response, 200, 'Fallo al actualizar la materia');
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
    return response;
  }
}
