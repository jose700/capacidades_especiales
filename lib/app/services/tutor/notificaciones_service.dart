import 'dart:convert';
import 'package:capacidades_especiales/app/utils/guards/apiKey.dart';
import 'package:capacidades_especiales/app/models/tutor/notifications_model.dart';
import 'package:http/http.dart' as http;

class NotificacionesService {
  static String baseurl = apiUrl;

  static Future<List<Notificacion>> obtenerNotificacionesPorUsuario(
      String usuario, String token) async {
    final response = await http.get(
      Uri.parse('$baseurl/notificaciones/tutor/$usuario'),
      headers: <String, String>{
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      String jsonResponse = response.body;
      print('JSON recibido: $jsonResponse');
      List<dynamic> jsonList = jsonDecode(jsonResponse);
      return jsonList.map((json) => Notificacion.fromJson(json)).toList();
    } else {
      throw Exception('Error al cargar las notificaciones');
    }
  }

  static Future<void> marcarNotificacionComoLeida(
      String usuario, int idnotificacion, String token) async {
    try {
      await http.put(
        Uri.parse(
            '$baseurl/notificaciones/representante/$usuario/$idnotificacion'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'leida': true}),
      );
    } catch (e) {
      throw Exception('Failed to mark notification as read');
    }
  }

  static Future<List<Notificacion>> obtenerNotificacionesPorRepresentante(
      String usuario, String token) async {
    final response = await http.get(
      Uri.parse('$baseurl/notificaciones/representante/$usuario'),
      headers: <String, String>{
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      String jsonResponse = response.body;
      print('JSON recibido: $jsonResponse');
      List<dynamic> jsonList = jsonDecode(jsonResponse);
      return jsonList.map((json) => Notificacion.fromJson(json)).toList();
    } else {
      throw Exception('Error al cargar las notificaciones');
    }
  }

  Future<void> crearNotificacion(
      Notificacion notificacion, String token) async {
    final response = await _postData(
        '$baseurl/notificaciones', notificacion.toJson(), token);

    if (response.statusCode == 201 || response.statusCode == 200) {
      // Notificación creada exitosamente, manejar aquí si es necesario
      print('Notificación creada: ${response.body}');
    } else {
      print('Error al crear la notificación: ${response.body}');
      throw Exception('Fallo al crear la notificación: ${response.body}');
    }
  }

  Future<void> enviarNotificacionATodosLosRepresentantes(String usuarioTutor,
      Notificacion notificacionTodoRepresentante, String token) async {
    try {
      // Realiza la solicitud POST con los datos de la notificación
      final response = await _postData(
        '$baseurl/notificaciones/tutor/$usuarioTutor',
        notificacionTodoRepresentante.toJson(),
        token,
      );

      // Verifica el código de estado de la respuesta
      if (response.statusCode == 200 || response.statusCode == 201) {
        print(
            'Notificación enviada a todos los representantes: ${response.body}');
      } else {
        print(
            'Error al enviar la notificación a todos los representantes: ${response.body}');
        throw Exception(
            'Fallo al enviar la notificación a todos los representantes: ${response.body}');
      }
    } catch (e) {
      // Maneja errores específicos si es necesario
      print('Excepción capturada al enviar la notificación: $e');
      throw Exception('Failed to send notification to all representatives: $e');
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

  Future<void> eliminarNotificacion(String idnotificacion, String token) async {
    final response = await http.delete(
      Uri.parse('$apiUrl/notificaciones/$idnotificacion'),
      headers: <String, String>{
        'Authorization': 'Bearer $token',
      },
    );
    _checkResponseStatusCode(
        response, 200, 'Fallo al eliminar la notificacion');
  }

  void _checkResponseStatusCode(
      http.Response response, int expectedStatusCode, String errorMessage) {
    if (response.statusCode != expectedStatusCode) {
      throw Exception(errorMessage);
    }
  }
}
