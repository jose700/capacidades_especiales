import 'dart:convert';
import 'package:capacidades_especiales/app/models/seguimientos-academicos/materias/approved_assignatura_model.dart';
import 'package:http/http.dart' as http;
import 'package:capacidades_especiales/app/utils/guards/apiKey.dart';

class MateriaAprobadaService {
  final String url = apiUrl;

  Future<void> crearMateria(MateriaAprobada aprobada, String token) async {
    final response =
        await _postData('$apiUrl/aprobadas', aprobada.toJson(), token);

    if (response.statusCode == 201 || response.statusCode == 200) {
      print('Materia aprobada creada correctamente: ${response.body}');
    } else {
      print('Error al crear la materia: ${response.body}');
      throw Exception('Fallo al crear la materia aprobada: ${response.body}');
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

  Future<List<MateriaAprobada>> obtenerMateriasAprobadasTutor(
      String usuario, String token) async {
    final List<MateriaAprobada> aprobadas = await _fetchMateriasAprobadas(
        '$apiUrl/aprobadas/tutor/$usuario', token);
    return aprobadas;
  }

  Future<List<MateriaAprobada>> _fetchMateriasAprobadas(
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
      print('Materias aprobadas obtenidas correctamente');
      return aprobadas;
    } else {
      print('Error al obtener las materias aprobadas: ${response.statusCode}');
      throw Exception('Fallo al cargar las materias');
    }
  }

  Future<void> eliminarMateriaAprobada(String idaprobada, String token) async {
    final response = await http.delete(
      Uri.parse('$apiUrl/aprobadas/$idaprobada'),
      headers: <String, String>{
        'Authorization': 'Bearer $token', // Incluyendo el token en los headers
      },
    );

    _checkResponseStatusCode(
        response, 200, 'Fallo al eliminar la materia aprobada');
  }

  void _checkResponseStatusCode(
      http.Response response, int expectedStatusCode, String errorMessage) {
    if (response.statusCode != expectedStatusCode) {
      throw Exception(errorMessage);
    }
  }

  Future<void> actualizarMateriaAprobada(
      int idaprobada, MateriaAprobada aprobada, String token) async {
    final response = await _putData(
        '$apiUrl/aprobadas/$idaprobada', aprobada.toJson(), token);
    _checkResponseStatusCode(
        response, 200, 'Fallo al actualizar la materia aprobada');
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

  Future<List<MateriaAprobada>> obtenerMateriasAprobadasEstudiante(
      String idEstudiante, String token) async {
    final List<MateriaAprobada> aprobadas = await _fetchMateriasAprobadas(
        '$apiUrl/aprobadas/estudiante/$idEstudiante', token);
    return aprobadas;
  }
}
