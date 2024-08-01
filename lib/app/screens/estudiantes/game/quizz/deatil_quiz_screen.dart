import 'package:flutter/material.dart';
import 'package:capacidades_especiales/app/models/estudiantes/quizz/quitz_model.dart';
import 'package:capacidades_especiales/app/utils/resources/app_colors.dart';

class QuizDetailScreen extends StatelessWidget {
  final List<Quiz> quizzes;
  final String? selectedMateria;

  const QuizDetailScreen({
    Key? key,
    required this.quizzes,
    this.selectedMateria,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // Imprime los datos de los cuestionarios
    print('Quizzes:');
    quizzes.forEach((quiz) {
      print('Pregunta: ${quiz.pregunta}');
      print('Respuesta Seleccionada: ${quiz.respuestaSeleccionada}');
    });

    // Filtra los cuestionarios según la materia seleccionada
    List<Quiz> filteredQuizzes = selectedMateria != null
        ? quizzes
            .where((quiz) => quiz.nombreMateria.toString() == selectedMateria)
            .toList()
        : quizzes;

    // Agrupa los cuestionarios por estudiante
    Map<String, List<Quiz>> groupedQuizzes = {};
    for (var quiz in filteredQuizzes) {
      String studentKey =
          '${quiz.nombres_estudiante} ${quiz.apellidos_estudiante}';
      if (groupedQuizzes.containsKey(studentKey)) {
        groupedQuizzes[studentKey]!.add(quiz);
      } else {
        groupedQuizzes[studentKey] = [quiz];
      }
    }

    print('Grouped Quizzes: $groupedQuizzes');

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Detalle de Quizzes',
          style: TextStyle(),
        ),
      ),
      body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: groupedQuizzes.isEmpty
              ? Center(child: Text('No hay cuestionarios disponibles'))
              : ListView.builder(
                  itemCount: groupedQuizzes.length,
                  itemBuilder: (context, index) {
                    String studentKey = groupedQuizzes.keys.elementAt(index);
                    List<Quiz> studentQuizzes = groupedQuizzes[studentKey]!;

                    return Card(
                      elevation: 4,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildSectionTitle('Estudiante: $studentKey'),
                            const SizedBox(height: 16),
                            _buildSectionTitle('Categoría'),
                            _buildText(
                                studentQuizzes.first.categoria.toString(),
                                fontSize: 16),
                            const SizedBox(height: 16),
                            _buildSectionTitle('Dificultad'),
                            _buildText(
                                studentQuizzes.first.dificultad.toString(),
                                fontSize: 16),
                            const SizedBox(height: 16),
                            ...studentQuizzes.map((quiz) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildSectionTitle(
                                      'Pregunta ${studentQuizzes.indexOf(quiz) + 1}'),
                                  _buildText(quiz.pregunta.toString(),
                                      fontSize: 16),
                                  const SizedBox(height: 8),
                                  _buildSectionTitle('Respuesta seleccionada'),
                                  _buildText(
                                    quiz.respuestaSeleccionada ??
                                        'Aún no hay respuestas',
                                    fontWeight: FontWeight.bold,
                                    color: quiz.respuestaSeleccionada ==
                                            quiz.respuestaCorrecta
                                        ? AppColors.contentColorGreen
                                        : AppColors.contentColorRed,
                                  ),
                                  const SizedBox(height: 8),
                                  _buildSectionTitle('Respuesta correcta'),
                                  _buildText(
                                    quiz.respuestaCorrecta.toString(),
                                    color: AppColors.contentColorGreen,
                                  ),
                                  const SizedBox(height: 8),
                                  _buildSectionTitle('Respuestas incorrectas'),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: quiz.respuestasIncorrectas!
                                        .map((respuesta) =>
                                            _buildText(respuesta, fontSize: 16))
                                        .toList(),
                                  ),
                                  const Divider(), // Separador entre cada pregunta
                                ],
                              );
                            }).toList(),
                          ],
                        ),
                      ),
                    );
                  },
                )),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildText(
    String text, {
    double fontSize = 16,
    FontWeight fontWeight = FontWeight.normal,
    Color? color,
  }) {
    return Text(
      text,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
      ),
    );
  }
}
