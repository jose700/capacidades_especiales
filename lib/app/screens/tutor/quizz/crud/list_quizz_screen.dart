import 'dart:io';

import 'package:capacidades_especiales/app/models/tutor/login_model.dart';
import 'package:capacidades_especiales/app/screens/tutor/quizz/crud/add_quizz_screen.dart';
import 'package:capacidades_especiales/app/widgets/search/no_results_widgets.dart';
import 'package:capacidades_especiales/app/widgets/tutor/Home/messages/dialogs/login_message.dart';
import 'package:flutter/material.dart';
import 'package:capacidades_especiales/app/models/estudiantes/quizz/quitz_model.dart';
import 'package:capacidades_especiales/app/screens/estudiantes/game/quizz/deatil_quiz_screen.dart';
import 'package:capacidades_especiales/app/services/estudiante/quizz/quizz_service.dart';
import 'package:capacidades_especiales/app/utils/resources/app_colors.dart';

class QuizScreen extends StatelessWidget {
  final Sesion sesion;
  final int idTutor;
  final QuizService quizService = QuizService();

  QuizScreen({required this.idTutor, required this.sesion});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Quizzes'),
      ),
      body: FutureBuilder<List<Quiz>>(
        future: quizService.getQuiz(idTutor, sesion.token),
        builder: (context, AsyncSnapshot<List<Quiz>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return NoQuizAssignedWidget();
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No hay quizzes disponibles'));
          } else {
            // Agrupar los quizzes por materia
            Map<String, List<Quiz>> quizzesPorMateria = {};

            snapshot.data!.forEach((quiz) {
              String key = quiz.nombreMateria.toString();

              if (!quizzesPorMateria.containsKey(key)) {
                quizzesPorMateria[key] = [];
              }
              quizzesPorMateria[key]!.add(quiz);
            });

            // Mostrar los quizzes agrupados
            return ListView.builder(
              itemCount: quizzesPorMateria.length,
              itemBuilder: (context, index) {
                String materia = quizzesPorMateria.keys.toList()[index];
                List<Quiz> quizzes = quizzesPorMateria[materia]!;
                Set<String> estudiantesUnicos = {};
                List<DataRow> rows = [];

                quizzes.forEach((quiz) {
                  String nombreEstudiante =
                      '${quiz.nombres_estudiante} ${quiz.apellidos_estudiante}';
                  if (!estudiantesUnicos.contains(nombreEstudiante)) {
                    estudiantesUnicos.add(nombreEstudiante);
                    rows.add(
                      DataRow(cells: [
                        DataCell(
                          CircleAvatar(
                            radius: 20.0,
                            backgroundImage: quiz.imagen_estudiante != null
                                ? FileImage(
                                    File(quiz.imagen_estudiante!.toString()))
                                : null,
                            child: quiz.imagen_estudiante == null
                                ? const Icon(Icons.person, size: 20.0)
                                : null,
                          ),
                        ),
                        DataCell(Text(nombreEstudiante)),
                        DataCell(Text(quiz.cedula_estudiante.toString())),
                        DataCell(
                          quiz.estado_test == 'Completado'
                              ? Icon(Icons.check_circle,
                                  color: AppColors.contentColorGreen)
                              : Icon(Icons.cancel,
                                  color: AppColors.contentColorRed),
                        ),
                        DataCell(
                          Text(quiz.calificacion != null
                              ? quiz.calificacion!.toStringAsFixed(2)
                              : "Sin calificación"),
                        ),
                        DataCell(Text(quiz.dificultad.toString())),
                        DataCell(
                          Row(
                            children: [
                              IconButton(
                                icon: Icon(Icons.remove_red_eye,
                                    color: AppColors.contentColorGreen),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => QuizDetailScreen(
                                        quizzes: quizzes
                                            .where((q) =>
                                                q.nombres_estudiante ==
                                                    quiz.nombres_estudiante &&
                                                q.apellidos_estudiante ==
                                                    quiz.apellidos_estudiante)
                                            .toList(),
                                        selectedMateria: materia,
                                      ),
                                    ),
                                  );
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.delete,
                                    color: AppColors.contentColorRed),
                                onPressed: () {
                                  _showDeleteConfirmationDialog(quiz, context);
                                },
                              ),
                            ],
                          ),
                        ),
                      ]),
                    );
                  }
                });

                return Card(
                  margin: EdgeInsets.all(8),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Materia: $materia',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            columns: [
                              DataColumn(label: Text('Imagen estudiante')),
                              DataColumn(label: Text('Nombres y apellidos')),
                              DataColumn(label: Text('Cédula')),
                              DataColumn(label: Text('Estado')),
                              DataColumn(label: Text('Calificación')),
                              DataColumn(label: Text('Dificultad')),
                              DataColumn(label: Text('Acciones')),
                            ],
                            rows: rows,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CrearQuizScreen(
                idpreguntas: 1,
                idTutor: sesion.idtutor ?? 0,
                sesion: sesion,
              ),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showDeleteConfirmationDialog(Quiz quiz, BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Eliminar'),
          content: const Text('¿Estás seguro de eliminar este quiz?'),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.contentColorRed,
              ),
              onPressed: () async {
                try {
                  await quizService.eliminarRespuestasPorTutor(
                    quiz.idpreguntas.toString(),
                    sesion.token,
                    quiz.cedula_estudiante.toString(),
                  );
                  Dialogs.showSnackbar(
                      context, 'Se ha eliminado el quiz correctamente');
                  Navigator.pop(context); // Cierra el diálogo
                  // Vuelve a la pantalla anterior
                } catch (e) {
                  Dialogs.showSnackbarError(
                      context, 'Error al eliminar el quiz');
                  Navigator.pop(context); // Cierra el diálogo
                }
              },
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );
  }
}
