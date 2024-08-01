import 'dart:convert';
import 'dart:developer';
import 'package:capacidades_especiales/app/utils/guards/apiKey.dart';
import 'package:capacidades_especiales/app/models/seguimientos-medicos/tratamientos/compliment_model.dart';
import 'package:http/http.dart' as http;

class ServicioTratamientoCumplido {
  final String url = apiUrl;

  Future<void> crearCumplido(TratamientoCumplido cumplido, String token) async {
    final response =
        await _postData('$apiUrl/cumplidos', cumplido.toJson(), token);

    if (response.statusCode == 201 || response.statusCode == 200) {
      // Tratamiento cumplido creado exitosamente, manejar aquí si es necesario
      log('Tratamiento cumplido creado: ${response.body}');
    } else {
      log('Error al crear el tratamiento cumplido: ${response.body}');
      throw Exception(
          'Fallo al crear el tratamiento cumplido: ${response.body}');
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

  Future<List<TratamientoCumplido>> obtenerTratamientosCumplidosTutor(
      String usuario, String token) async {
    final List<TratamientoCumplido> tratamientosCumplidos =
        await _fetchTratamientosCumplidos(
            '$apiUrl/cumplidos/tutor/$usuario', token);
    return tratamientosCumplidos;
  }

  Future<List<TratamientoCumplido>> _fetchTratamientosCumplidos(
      String endpoint, String token) async {
    final response = await http.get(
      Uri.parse(endpoint),
      headers: <String, String>{
        'Authorization': 'Bearer $token', // Incluyendo el token en los headers
      },
    );
    if (response.statusCode == 200) {
      List<dynamic> tratamientocumplido = jsonDecode(response.body);
      List<TratamientoCumplido> tratamientoscumplidos = tratamientocumplido
          .map((cumplido) => TratamientoCumplido.fromJson(cumplido))
          .toList();
      return tratamientoscumplidos;
    } else {
      throw Exception('Fallo al cargar los tratamientos cumplidos');
    }
  }

  Future<void> eliminarTratamientoCumplido(
      String idcumplido, String token) async {
    final response = await http.delete(
      Uri.parse('$apiUrl/cumplidos/$idcumplido'),
      headers: <String, String>{
        'Authorization': 'Bearer $token', // Incluyendo el token en los headers
      },
    );

    _checkResponseStatusCode(
        response, 200, 'Fallo al eliminar el tratamiento cumplido');
  }

  void _checkResponseStatusCode(
      http.Response response, int expectedStatusCode, String errorMessage) {
    if (response.statusCode != expectedStatusCode) {
      throw Exception(errorMessage);
    }
  }

  Future<void> actualizarTratamiento(int idcumplido,
      TratamientoCumplido tratamientocumplido, String token) async {
    final response = await _putData(
        '$apiUrl/cumplidos/$idcumplido', tratamientocumplido.toJson(), token);
    _checkResponseStatusCode(
        response, 200, 'Fallo al actualizar el tratamiento cumplido');
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
