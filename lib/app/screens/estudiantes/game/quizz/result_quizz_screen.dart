import 'package:capacidades_especiales/app/models/estudiantes/quizz/quitz_model.dart';
import 'package:capacidades_especiales/app/models/tutor/login_model.dart';
import 'package:capacidades_especiales/app/screens/estudiantes/game/game_screen.dart';
import 'package:capacidades_especiales/app/services/estudiante/quizz/quizz_service.dart';
import 'package:capacidades_especiales/app/widgets/tutor/Home/messages/dialogs/login_message.dart';
import 'package:flutter/material.dart';

class ResultadoQuizScreen extends StatefulWidget {
  final List<PreguntaYRespuesta> resultados;
  final Quiz quiz;
  final Sesion sesion;

  ResultadoQuizScreen({
    required this.resultados,
    required this.sesion,
    required this.quiz,
  });

  @override
  State<ResultadoQuizScreen> createState() => _ResultadoQuizScreenState();
}

class _ResultadoQuizScreenState extends State<ResultadoQuizScreen> {
  final QuizService _service = QuizService();
  final String completado = "Completado";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Resultados del Quiz'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Resultados:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 1),
                    ),
                    columnSpacing: 16,
                    columns: [
                      DataColumn(label: Text('#')),
                      DataColumn(label: Text('Preguntas')),
                      DataColumn(label: Text('Respuesta')),
                      DataColumn(label: Text('Tiempo tardado')),
                    ],
                    rows: widget.resultados
                        .map(
                          (resultado) => DataRow(
                            cells: [
                              DataCell(Text(resultado.idpreguntas)),
                              DataCell(Text(resultado.pregunta)),
                              DataCell(Text(resultado.respuestaSeleccionada)),
                              DataCell(Text(resultado.tiempoTardado)),
                            ],
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Container(
              alignment: Alignment.center,
              child: ElevatedButton(
                onPressed: () {
                  _enviarRespuestas();
                },
                child: Text('Enviar respuestas'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _enviarRespuestas() async {
    print('Iniciando envío de respuestas...');

    try {
      // Lista para enviar al servidor
      List<Map<String, dynamic>> respuestasList = [];
      widget.resultados.forEach((resultado) {
        respuestasList.add({
          'idpreguntas': resultado.idpreguntas,
          'idmateria': widget.quiz.idmateria,
          'respuesta_seleccionada': resultado.respuestaSeleccionada,
          'tiempo_tardado': resultado.tiempoTardado,
          'estado_test': completado,
        });
      });

      print('Datos a enviar: $respuestasList');

      // Enviar la solicitud al servidor
      await _service.actualizarQuizzPorCedulaEstudiante(
        widget.sesion.cedula.toString(),
        respuestasList,
        widget.sesion.token,
      );

      Dialogs.showSnackbar(context, 'Respuestas enviadas correctamente');
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => GameScreen(sesion: widget.sesion),
        ),
      );
    } catch (error) {
      print('Error al enviar respuestas: $error');
      Dialogs.showSnackbarError(context, 'Error al enviar respuestas');
    }
  }
}

class PreguntaYRespuesta {
  final String idpreguntas;
  final String pregunta;
  final String respuestaSeleccionada;
  final String tiempoTardado;
  final String estadoTest;

  PreguntaYRespuesta({
    required this.idpreguntas,
    required this.pregunta,
    required this.respuestaSeleccionada,
    required this.tiempoTardado,
    required this.estadoTest,
  });

  factory PreguntaYRespuesta.fromMap(Map<String, dynamic> map) {
    return PreguntaYRespuesta(
      idpreguntas: map['idpreguntas'] ?? '',
      pregunta: map['pregunta'] ?? '',
      respuestaSeleccionada: map['respuesta_seleccionada'] ?? '',
      tiempoTardado: map['tiempo_tardado'] ?? '',
      estadoTest: map['estado_test'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'pregunta': pregunta,
      'respuesta_seleccionada': respuestaSeleccionada,
      'tiempo_tardado': tiempoTardado,
      'estado_test': estadoTest,
    };
  }
}
