import 'dart:convert';
import 'package:capacidades_especiales/app/models/seguimientos-academicos/materias/approved_assignatura_model.dart';
import 'package:http/http.dart' as http;
import 'package:capacidades_especiales/app/utils/guards/apiKey.dart';

class MateriaReprobadaService {
  final String url = apiUrl;

  Future<void> crearMateriaReprobada(
      MateriaAprobada aprobada, String token) async {
    final response =
        await _postData('$apiUrl/reprobadas', aprobada.toJson(), token);

    if (response.statusCode == 201 || response.statusCode == 200) {
      print('Materia reaprobada creada correctamente: ${response.body}');
    } else {
      print('Error al crear la materia: ${response.body}');
      throw Exception('Fallo al crear la materia reaprobada: ${response.body}');
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

  Future<List<MateriaAprobada>> obtenerMateriasReprobadasTutor(
      String usuario, String token) async {
    final List<MateriaAprobada> aprobadas = await _fetchMateriasReprobadas(
        '$apiUrl/reprobadas/tutor/$usuario', token);
    return aprobadas;
  }

  Future<List<MateriaAprobada>> _fetchMateriasReprobadas(
      String endpoint, String token) async {
    final response = await http.get(
      Uri.parse(endpoint),
      headers: <String, String>{
        'Authorization': 'Bearer $token', // Incluyendo el token en los headers
      },
    );
    if (response.statusCode == 200) {
      List<dynamic> aprobadasJson = jsonDecode(response.body);
      List<MateriaAprobada> aprobadas = aprobadasJson
          .map((aprobadaJson) => MateriaAprobada.fromJson(aprobadaJson))
          .toList();
      print('Materias reprobadas obtenidas correctamente');
      return aprobadas;
    } else {
      print('Error al obtener las materias reprobadas: ${response.statusCode}');
      throw Exception('Fallo al cargar las materias reprobadas');
    }
  }

  Future<void> eliminarMateriaReprobada(
      String idreprobada, String token) async {
    final response = await http.delete(
      Uri.parse('$apiUrl/reprobadas/$idreprobada'),
      headers: <String, String>{
        'Authorization': 'Bearer $token', // Incluyendo el token en los headers
      },
    );

    _checkResponseStatusCode(
        response, 200, 'Fallo al eliminar la materia reprobada');
  }

  void _checkResponseStatusCode(
      http.Response response, int expectedStatusCode, String errorMessage) {
    if (response.statusCode != expectedStatusCode) {
      throw Exception(errorMessage);
    }
  }

  Future<void> actualizarMateriaReprobada(
      int idaprobada, MateriaAprobada aprobada, String token) async {
    final response = await _putData(
        '$apiUrl/reprobadas/$idaprobada', aprobada.toJson(), token);
    _checkResponseStatusCode(
        response, 200, 'Fallo al actualizar la materia reprobada');
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

  Future<List<MateriaAprobada>> obtenerMateriasReprobadasEstudiante(
      String idEstudiante, String token) async {
    final List<MateriaAprobada> reprobadas = await _fetchMateriasReprobadas(
        '$apiUrl/reprobadas/estudiante/$idEstudiante', token);
    return reprobadas;
  }
}
