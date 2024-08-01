import 'dart:async';
import 'package:flutter/material.dart';
import 'package:capacidades_especiales/app/models/tutor/login_model.dart';
import 'package:capacidades_especiales/app/models/estudiantes/quizz/quitz_model.dart';
import 'package:capacidades_especiales/app/services/estudiante/quizz/quizz_service.dart';
import 'package:capacidades_especiales/app/screens/estudiantes/game/quizz/result_quizz_screen.dart';

class ResolverQuizScreen extends StatefulWidget {
  final Sesion sesion;
  final String materia;
  final String cedulaEstudiante;
  final Quiz quiz;

  ResolverQuizScreen({
    Key? key,
    required this.materia,
    required this.cedulaEstudiante,
    required this.sesion,
    required this.quiz,
  }) : super(key: key);

  @override
  _ResolverQuizScreenState createState() => _ResolverQuizScreenState();
}

class _ResolverQuizScreenState extends State<ResolverQuizScreen> {
  final QuizService _quizService = QuizService();
  late List<Quiz> _quizzes;
  bool _isLoading = false;
  int _currentIndex = 0;
  int _seconds = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _quizzes = [];
    _fetchQuizzes();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _fetchQuizzes() async {
    setState(() {
      _isLoading = true;
    });

    try {
      List<Quiz> quizzes = await _quizService.getQuizzesByCedulaEstudiante(
          widget.cedulaEstudiante, widget.sesion.token);

      // Filtrar los quizzes por materia y que no estén completados
      List<Quiz> filteredQuizzes = quizzes
          .where((quiz) =>
              quiz.nombreMateria == widget.materia &&
              quiz.estado_test != 'Completado')
          .toList();

      setState(() {
        _quizzes = filteredQuizzes;
        _isLoading = false;
      });

      // Iniciar el temporizador para la primera pregunta del quiz
      if (_quizzes.isNotEmpty) {
        _startTimerForCurrentQuestion();
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _startTimerForCurrentQuestion() {
    Quiz quiz = _quizzes[_currentIndex];
    _startTimer(_quizDurationInSeconds(quiz));
  }

  void _startTimer(double durationInSeconds) {
    _seconds = durationInSeconds.toInt();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_seconds > 0) {
          _seconds--;
          _quizzes[_currentIndex].tiempoTardado =
              _formatTime(_seconds); // Actualiza el tiempo transcurrido
        } else {
          _handleNextQuestion();
        }
      });
    });
  }

  String _formatTime(int seconds) {
    int hours = seconds ~/ 3600;
    int minutes = (seconds % 3600) ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  double _quizDurationInSeconds(Quiz quiz) {
    if (quiz.tiempoLimite!.contains('horas')) {
      return int.parse(quiz.tiempoLimite!.split(' ')[0]) * 3600.0;
    } else if (quiz.tiempoLimite!.contains('minutos')) {
      return int.parse(quiz.tiempoLimite!.split(' ')[0]) * 60.0;
    } else {
      return 60.0; // Default value
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Resolver cuestionario'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _quizzes.isEmpty
              ? Center(
                  child: Text('No hay quizzes disponibles para esta materia'),
                )
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTimerAndProgress(),
                      SizedBox(height: 20),
                      Text('Pregunta ${_currentIndex + 1}:',
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold)),
                      SizedBox(height: 10),
                      Text(
                        _quizzes[_currentIndex].pregunta.toString(),
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(height: 20),
                      ..._buildOptions(),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          if (_currentIndex > 0)
                            ElevatedButton.icon(
                              onPressed: () {
                                _handlePreviousQuestion();
                              },
                              icon: Icon(Icons.arrow_back),
                              label: Text('Pregunta Anterior'),
                            ),
                          ElevatedButton.icon(
                            onPressed: () {
                              _handleNextQuestion();
                            },
                            icon: Icon(Icons.arrow_forward),
                            label: Text(
                              _currentIndex == _quizzes.length - 1
                                  ? 'Finalizar Quiz'
                                  : 'Siguiente Pregunta',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
    );
  }

  Widget _buildTimerAndProgress() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Tiempo restante: $_seconds segundos',
            style: TextStyle(fontSize: 16)),
        SizedBox(height: 10),
        LinearProgressIndicator(
          value:
              1 - (_seconds / _quizDurationInSeconds(_quizzes[_currentIndex])),
          backgroundColor: Colors.grey[300],
          valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
        ),
      ],
    );
  }

  List<Widget> _buildOptions() {
    List<Widget> options = [];
    Quiz quiz = _quizzes[_currentIndex];

    // Combine respuestas correctas e incorrectas
    List<String> opciones = [];
    opciones.add(quiz.respuestaCorrecta.toString());
    opciones.addAll(quiz.respuestasIncorrectas!);

    // Ordenar alfabéticamente
    opciones.sort();

    opciones.forEach((option) {
      options.add(
        ListTile(
          title: Text(option),
          leading: Radio<String>(
            value: option,
            groupValue: quiz.respuestaSeleccionada.toString(),
            onChanged: (value) {
              setState(() {
                quiz.respuestaSeleccionada = value!;
              });
            },
          ),
        ),
      );
    });

    return options;
  }

  void _handleNextQuestion() {
    _timer?.cancel();
    // Avanzar a la siguiente pregunta que no esté completada
    while (_currentIndex < _quizzes.length - 1 &&
        _quizzes[_currentIndex].estado_test == 'Completado') {
      _currentIndex++;
    }

    if (_currentIndex < _quizzes.length - 1) {
      setState(() {
        _currentIndex++;
        _startTimerForCurrentQuestion();
      });
    } else {
      _submitQuiz();
    }
  }

  void _handlePreviousQuestion() {
    _timer?.cancel();
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
        _startTimerForCurrentQuestion();
      });
    }
  }

  void _submitQuiz() {
    // Preparar datos para enviar a ResultadoQuizScreen
    List<PreguntaYRespuesta> resultados = [];
    _quizzes.forEach((quiz) {
      resultados.add(PreguntaYRespuesta(
        idpreguntas: quiz.idpreguntas.toString(),
        pregunta: quiz.pregunta.toString(),
        respuestaSeleccionada: quiz.respuestaSeleccionada ?? 'No respondida',
        tiempoTardado: quiz.tiempoTardado.toString(),
        estadoTest: quiz.estado_test ??
            'Completado', // Asegúrate de manejar adecuadamente el valor por defecto
      ));
    });

    // Navegar a ResultadoQuizScreen y pasar resultados
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResultadoQuizScreen(
          sesion: widget.sesion,
          resultados: resultados,
          quiz: widget.quiz,
        ),
      ),
    );
  }
}
