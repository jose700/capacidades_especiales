import 'dart:convert';
import 'dart:developer';
import 'package:capacidades_especiales/app/utils/guards/apiKey.dart';
import 'package:capacidades_especiales/app/models/seguimientos-medicos/tratamientos/treatment_model.dart';
import 'package:http/http.dart' as http;

class ServicioTratamiento {
  final String url = apiUrl;

  Future<void> crearTratamiento(Tratamiento tratamiento, String token) async {
    final response =
        await _postData('$apiUrl/tratamientos', tratamiento.toJson(), token);

    if (response.statusCode == 201 || response.statusCode == 200) {
      // Tratamiento creado exitosamente, manejar aquí si es necesario
      log('Tratamiento creado: ${response.body}');
    } else {
      log('Error al crear el tratamiento: ${response.body}');
      throw Exception('Fallo al crear el tratamiento: ${response.body}');
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

  Future<List<Tratamiento>> obtenerTratamientosTutor(
      String usuario, String token) async {
    final List<Tratamiento> tratamientos =
        await _fetchTratamientos('$apiUrl/tratamientos/tutor/$usuario', token);
    return tratamientos;
  }

  Future<List<Tratamiento>> _fetchTratamientos(
      String endpoint, String token) async {
    final response = await http.get(
      Uri.parse(endpoint),
      headers: <String, String>{
        'Authorization': 'Bearer $token', // Incluyendo el token en los headers
      },
    );
    if (response.statusCode == 200) {
      List<dynamic> tratamientosJson = jsonDecode(response.body);
      List<Tratamiento> tratamientos = tratamientosJson
          .map((tratamientoJson) => Tratamiento.fromJson(tratamientoJson))
          .toList();
      return tratamientos;
    } else {
      throw Exception('Fallo al cargar los tratamientos');
    }
  }

  Future<void> eliminarTratamiento(String idtratamiento, String token) async {
    final response = await http.delete(
      Uri.parse('$apiUrl/tratamientos/$idtratamiento'),
      headers: <String, String>{
        'Authorization': 'Bearer $token', // Incluyendo el token en los headers
      },
    );

    _checkResponseStatusCode(response, 200, 'Fallo al eliminar el tratamiento');
  }

  void _checkResponseStatusCode(
      http.Response response, int expectedStatusCode, String errorMessage) {
    if (response.statusCode != expectedStatusCode) {
      throw Exception(errorMessage);
    }
  }

  Future<void> actualizarTratamiento(
      int idtratamiento, Tratamiento tratamiento, String token) async {
    final response = await _putData(
        '$apiUrl/tratamientos/$idtratamiento', tratamiento.toJson(), token);
    _checkResponseStatusCode(
        response, 200, 'Fallo al actualizar el tratamiento');
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
