import 'dart:convert';
import 'package:capacidades_especiales/app/utils/guards/apiKey.dart';
import 'package:capacidades_especiales/app/models/estudiantes/quizz/quitz_model.dart';
import 'package:http/http.dart' as http;

class QuizService {
  final String url = apiUrl; // URL base de tu API

  Future<List<Quiz>> getQuiz(int idTutor, String token) async {
    final List<Quiz> estudiantes =
        await _fetchQuizs('$url/tutor/$idTutor', token);
    return estudiantes;
  }

  Future<List<Quiz>> _fetchQuizs(String endpoint, String token) async {
    try {
      final response = await http.get(
        Uri.parse(endpoint),
        headers: <String, String>{
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        List<dynamic> quizsJson = jsonDecode(response.body);
        List<Quiz> quizs =
            quizsJson.map((quizJson) => Quiz.fromJson(quizJson)).toList();
        return quizs;
      } else {
        print('Status Code: ${response.statusCode}');
        print('Response Body: ${response.body}');
        throw Exception('Failed to load quizzes');
      }
    } catch (e) {
      print('Error fetching quizzes: $e');
      throw Exception('Failed to load quizzes: $e');
    }
  }

  Future<List<Quiz>> getQuizzesByCedulaEstudiante(
      String cedulaEstudiante, String token) async {
    final List<Quiz> quizzes =
        await _fetchQuizs('$url/estudiante/$cedulaEstudiante', token);
    return quizzes;
  }

  Future<int?> crearQuiz(Map<String, dynamic> quizzData) async {
    try {
      final response = await http.post(
        Uri.parse('$apiUrl/crearQuizz'),
        body: jsonEncode(quizzData),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 201) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        return responseData['idpreguntas']
            as int?; // Devuelve la id del quizz creada
      } else {
        throw Exception('Error al crear el quizz: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error al crear el quizz: $e');
    }
  }

  Future<void> actualizarQuizzPorCedulaEstudiante(
      String cedula, List<Map<String, dynamic>> quizz, String token) async {
    try {
      final response = await http.put(
        Uri.parse('$apiUrl/actualizarQuizEstudiante/$cedula/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(quizz), // Aquí usamos jsonEncode directamente
      );

      // Imprimir detalles de la actualización del progreso del estudiante
      print(
          'PUT $apiUrl/actualizarQuizEstudiante/$cedula- Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        print('Quizz del estudiante actualizado correctamente');
      } else {
        print('Error al actualizar el quizz del estudiante: ${response.body}');
        throw Exception('Fallo al actualizar el quizz del estudiante');
      }
    } catch (e) {
      print('Error al conectar con el servidor: $e');
      throw Exception('Error al conectar con el servidor');
    }
  }

  Future<void> eliminarRespuestasPorTutor(
      String idpreguntas, String token, String cedulaEstudiante) async {
    try {
      final response = await http.delete(
        Uri.parse(
            '$apiUrl/preguntas_estudiantes/$idpreguntas?cedula_estudiante=$cedulaEstudiante'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      );

      print(
          'DELETE $apiUrl/preguntas_estudiantes/$idpreguntas?cedula_estudiante=$cedulaEstudiante - Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        print('Respuestas eliminadas correctamente');
      } else {
        print('Error al eliminar respuestas: ${response.body}');
        throw Exception('Fallo al eliminar respuestas');
      }
    } catch (e) {
      print('Error al conectar con el servidor: $e');
      throw Exception('Error al conectar con el servidor');
    }
  }
}
