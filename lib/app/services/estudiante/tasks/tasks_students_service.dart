import 'dart:convert';
import 'dart:io';
import 'package:capacidades_especiales/app/models/estudiantes/tareas/add_tasks_model.dart';
import 'package:capacidades_especiales/app/models/estudiantes/tareas/data_task_model.dart';
import 'package:capacidades_especiales/app/models/estudiantes/tareas/list_item_students_task_model.dart';
import 'package:capacidades_especiales/app/models/tutor/tutor_task_model.dart';
import 'package:http/http.dart' as http;
import 'package:capacidades_especiales/app/utils/guards/apiKey.dart';

class ServicioProgresoEstudiante {
  final String url = apiUrl;

  Future<void> crearProgresoEstudiante(
      TasksStudents tareas, String token) async {
    try {
      final response = await http.post(
        Uri.parse('$apiUrl/tareas_estudiante'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization':
              'Bearer $token', // Incluyendo el token en los headers
        },
        body: jsonEncode(tareas.toJson()),
      );

      // Imprimir detalles de la creación del progreso del estudiante
      print(
          'POST $url/tareas_estudiante - Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 201) {
        print('Progreso del estudiante creado correctamente');
      } else {
        print('Error al crear las tareas para el estudiante: ${response.body}');
        throw Exception('Fallo al crear las tareas del estudiante');
      }
    } catch (e) {
      print('Error al conectar con el servidor: $e');
      throw Exception('Error al conectar con el servidor');
    }
  }

  Future<List<DatosTutor>> obtenerTareasEstudiantesPorTutor(
      String usuarioTutor, String token) async {
    final response = await http.get(
      Uri.parse('$apiUrl/tareas_estudiantes/tutor/$usuarioTutor'),
      headers: <String, String>{
        'Authorization': 'Bearer $token', // Incluyendo el token en los headers
      },
    );

    // Imprimir detalles de la obtención de tareas por tutor
    print(
        'GET $url/tareas_estudiantes/tutor/$usuarioTutor - Status Code: ${response.statusCode}');

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      List<DatosTutor> datosTutor = jsonResponse
          .map((tutorJson) => DatosTutor.fromJson(tutorJson))
          .toList();

      // Imprimir la cantidad de datos de tutor obtenidos
      print('Cantidad de datos de tutor obtenidos: ${datosTutor.length}');

      return datosTutor;
    } else {
      throw Exception('Error al cargar los datos');
    }
  }

  Future<List<DatosTareasEstudiantes>> obtenerTareasEstudiante(
      String cedulaEstudiante, String idMateria, String token) async {
    try {
      final response = await http.get(
        Uri.parse('$apiUrl/estudiantes/tareas/$cedulaEstudiante/$idMateria'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization':
              'Bearer $token', // Incluyendo el token en los headers
        },
      );

      // Imprimir detalles de la obtención de tareas por estudiante
      print(
          'GET $apiUrl/estudiantes/tareas/$cedulaEstudiante/$idMateria - Status Code: ${response.statusCode}');

      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = json.decode(response.body);
        List<DatosTareasEstudiantes> datosTareasEstudiantes = jsonResponse
            .map((datosJson) => DatosTareasEstudiantes.fromJson(datosJson))
            .toList();

        // Imprimir la cantidad de datos de tareas de estudiante obtenidos
        print(
            'Cantidad de datos de tareas de estudiante obtenidos: ${datosTareasEstudiantes.length}');

        return datosTareasEstudiantes;
      } else {
        throw Exception('Fallo al cargar las tareas del estudiante');
      }
    } catch (e) {
      print('Error al obtener las tareas del estudiante: $e');
      throw Exception('Error al obtener las tareas del estudiante: $e');
    }
  }

  Future<void> actualizarProgresoEstudiante(String cedula, String idtarea,
      Map<String, dynamic> progreso, String token) async {
    try {
      final response = await http.put(
        Uri.parse('$apiUrl/estudiante/$cedula/tarea/$idtarea'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(progreso),
      );

      print(
          'PUT $apiUrl/estudiante/$cedula/tarea/$idtarea - Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        print('Progreso del estudiante actualizado correctamente');
      } else {
        print(
            'Error al actualizar el progreso del estudiante: ${response.body}');
        throw Exception('Fallo al actualizar el progreso del estudiante');
      }
    } catch (e) {
      print('Error al conectar con el servidor: $e');
      throw Exception('Error al conectar con el servidor');
    }
  }

  //eliminar estudiante tarea del estudante
  Future<void> eliminarTareaEstudiante(String idtarea) async {
    try {
      final response = await http.delete(
        Uri.parse('$apiUrl/tareas_estudiantes/$idtarea'),
        headers: <String, String>{},
      );

      _checkResponseStatusCode(
          response, 200, 'Fallo al eliminar la tarea del estudiante');
    } catch (e) {
      print('Error al eliminar estudiante: $e');
      throw Exception('Error al eliminar estudiante: $e');
    }
  }

//elminar tarea que subioo el estudiante

  Future<void> eliminarTareaSubidaEstudiante(String id) async {
    try {
      final response = await http.delete(
        Uri.parse('$apiUrl/tareas-subidas/$id'),
        headers: <String, String>{},
      );
      _checkResponseStatusCode(
          response, 200, 'Fallo al eliminar la tarea del estudiante');
    } catch (e) {
      print('Error al eliminar estudiante: $e');
      throw Exception('Error al eliminar estudiante: $e');
    }
  }

  void _checkResponseStatusCode(
      http.Response response, int expectedStatusCode, String errorMessage) {
    print('Response Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode == 401) {
      // Manejar específicamente el error de autenticación
      throw Exception('Usuario no autenticado o falta información de tutor');
    } else if (response.statusCode != expectedStatusCode) {
      // Otros errores de estado HTTP
      print(
          'Error en _checkResponseStatusCode: ${response.statusCode} - ${response.body}');
      throw Exception(errorMessage);
    }
  }

  Future<void> actualizarTareaPorTutor(
      int idtarea, TareaEstudiante tarea, String token) async {
    final response =
        await _putData('$apiUrl/tareas/$idtarea', tarea.toJson(), token);
    _checkResponseStatusCode(response, 200, 'Fallo al actualizar las tareas');
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

  Future<void> subirArchivo(String cedula, String idtarea, File file,
      Map<String, dynamic> progreso) async {
    final uri = Uri.parse('$apiUrl/estudiante/$cedula/tarea/$idtarea');
    final request = http.MultipartRequest('PUT', uri)
      ..fields['idtarea'] = idtarea
      ..fields['fecha_envio_tarea'] = progreso['fecha_envio_tarea']
      ..fields['archivo_nombre'] = progreso['archivo_nombre']
      ..fields['archivo_mimetype'] = progreso['archivo_mimetype']
      ..fields['tarea_cumplida'] = progreso['tarea_cumplida'].toString();

    // Agrega el archivo
    request.files.add(await http.MultipartFile.fromPath('file', file.path));

    final response = await request.send();

    if (response.statusCode == 200) {
      print('Archivo subido correctamente');
    } else {
      print(
          'Error al subir el archivo. Código de estado: ${response.statusCode}');
      throw Exception('Error al subir el archivo');
    }
  }
}
