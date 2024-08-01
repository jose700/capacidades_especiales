import 'package:flutter/material.dart';
import 'package:capacidades_especiales/app/utils/resources/app_colors.dart';

class ResultScreen extends StatelessWidget {
  final int correctAnswers;
  final int totalQuestions;
  final List<Map<String, dynamic>> questionData;

  const ResultScreen({
    Key? key,
    required this.correctAnswers,
    required this.totalQuestions,
    required this.questionData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Resultados del Quiz',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Respuestas correctas: $correctAnswers / $totalQuestions',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: questionData.length,
                  itemBuilder: (BuildContext context, int index) {
                    var status = questionData[index]['status'];
                    var selectedAnswer = questionData[index]['selected_answer'];
                    var correctAnswer = questionData[index]['correct_answer'];
                    var question = questionData[index]['question'];

                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Pregunta ${index + 1}:',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              question,
                              style: TextStyle(fontSize: 14),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(
                                  status ? Icons.check : Icons.close,
                                  color: status
                                      ? AppColors.contentColorGreen
                                      : AppColors.contentColorRed,
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    status
                                        ? 'Respuesta correcta'
                                        : 'Respuesta incorrecta',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: status
                                          ? AppColors.contentColorGreen
                                          : AppColors.contentColorRed,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Tu respuesta: $selectedAnswer',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.contentColorBlue,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Respuesta correcta: $correctAnswer',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.contentColorGreen,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
