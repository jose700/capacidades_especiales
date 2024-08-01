import 'dart:convert';
import 'dart:developer';
import 'package:capacidades_especiales/app/utils/guards/apiKey.dart';
import 'package:capacidades_especiales/app/models/seguimientos-medicos/tratamientos/compliment_model.dart';
import 'package:http/http.dart' as http;

class ServicioTratamientoNoCumplido {
  final String url = apiUrl;

  Future<void> crearNoCumplido(
      TratamientoCumplido noCumplido, String token) async {
    try {
      final response =
          await _postData('$url/nocumplidos', noCumplido.toJson(), token);

      if (response.statusCode == 201 || response.statusCode == 200) {
        log('Tratamiento no cumplido creado: ${response.body}');
      } else {
        log('Error al crear el tratamiento no cumplido: ${response.body}');
        throw Exception(
            'Fallo al crear el tratamiento no cumplido: ${response.body}');
      }
    } catch (e) {
      log('Exception al crear el tratamiento no cumplido: $e');
      rethrow;
    }
  }

  Future<List<TratamientoCumplido>> obtenerTratamientosNoCumplidosTutor(
      String usuario, String token) async {
    final endpoint = '$url/nocumplidos/tutor/$usuario';
    log('Obteniendo tratamientos no cumplidos del tutor: $endpoint');
    final List<TratamientoCumplido> tratamientosNoCumplidos =
        await _fetchTratamientosNoCumplidos(endpoint, token);
    return tratamientosNoCumplidos;
  }

  Future<List<TratamientoCumplido>> _fetchTratamientosNoCumplidos(
      String endpoint, String token) async {
    try {
      final response = await http.get(
        Uri.parse(endpoint),
        headers: <String, String>{
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        List<dynamic> tratamientonocumplido = jsonDecode(response.body);
        List<TratamientoCumplido> tratamientosnocumplidos =
            tratamientonocumplido
                .map((nocumplido) => TratamientoCumplido.fromJson(nocumplido))
                .toList();
        return tratamientosnocumplidos;
      } else {
        log('Fallo al cargar los tratamientos no cumplidos: ${response.body}');
        throw Exception('Fallo al cargar los tratamientos no cumplidos');
      }
    } catch (e) {
      log('Exception al obtener tratamientos no cumplidos: $e');
      rethrow;
    }
  }

  Future<void> eliminarTratamientoNoCumplido(
      String idnocumplido, String token) async {
    final response = await http.delete(
      Uri.parse('$apiUrl/nocumplidos/$idnocumplido'),
      headers: <String, String>{
        'Authorization': 'Bearer $token',
      },
    );

    _checkResponseStatusCode(
        response, 200, 'Fallo al eliminar el tratamiento no cumplido');
  }

  void _checkResponseStatusCode(
      http.Response response, int expectedStatusCode, String errorMessage) {
    if (response.statusCode != expectedStatusCode) {
      throw Exception(errorMessage);
    }
  }

  Future<void> actualizarTratamientoNoCumplido(int idnocumplido,
      TratamientoCumplido tratamientonocumplido, String token) async {
    final response = await _putData('$apiUrl/nocumplidos/$idnocumplido',
        tratamientonocumplido.toJson(), token);
    _checkResponseStatusCode(
        response, 200, 'Fallo al actualizar el tratamiento no cumplido');
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
      log('POST request to $url: ${response.statusCode}');
      return response;
    } catch (e) {
      log('Exception en POST request a $url: $e');
      rethrow;
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
      log('PUT request to $url: ${response.statusCode}');
      return response;
    } catch (e) {
      log('Exception en PUT request a $url: $e');
      rethrow;
    }
  }
}
