import 'package:capacidades_especiales/app/models/estudiantes/quizz/quitz_model.dart';
import 'package:flutter/material.dart';
import 'package:capacidades_especiales/app/models/seguimientos-academicos/materias/assignature_model.dart';
import 'package:capacidades_especiales/app/models/tutor/login_model.dart';
import 'package:capacidades_especiales/app/services/estudiante/quizz/quizz_service.dart';
import 'package:capacidades_especiales/app/services/seguimientos-academicos/materia/materia_service.dart';
import 'package:capacidades_especiales/app/widgets/tutor/Home/messages/dialogs/login_message.dart';

class CrearQuizScreen extends StatefulWidget {
  final int idpreguntas;
  final int idTutor;
  final Sesion sesion;

  CrearQuizScreen({
    required this.idpreguntas,
    required this.idTutor,
    required this.sesion,
  });

  @override
  _CrearQuizScreenState createState() => _CrearQuizScreenState();
}

class _CrearQuizScreenState extends State<CrearQuizScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final QuizService quizService = QuizService();
  final ServicioMateria servicioMateria = ServicioMateria();
  late Future<List<Materia>> materias;
  String? _selectedMateria;
  String? _selectedTipo;
  String? _selectedDificultad;
  final TextEditingController preguntaController = TextEditingController();
  final TextEditingController categoriaController = TextEditingController();
  final TextEditingController respuestaCorrectaController =
      TextEditingController();
  final TextEditingController respuestasIncorrectasController =
      TextEditingController();
  final TextEditingController tiempoLimiteController = TextEditingController();
  String estado_test = 'No Completado';

  @override
  void initState() {
    super.initState();
    materias = fetchMaterias();
  }

  Future<List<Materia>> fetchMaterias() async {
    try {
      final fetchMaterias = await servicioMateria.obtenerMateriasTutor(
        widget.sesion.usuario.toString(),
        widget.sesion.token,
      );
      return fetchMaterias;
    } catch (e) {
      _showErrorSnackbar();
      return [];
    }
  }

  void _showErrorSnackbar() {
    Dialogs.showSnackbarError(context, 'Error al cargar materias');
  }

  String? requiredValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Este campo es obligatorio';
    }
    return null;
  }

  void enviarQuiz() async {
    if (_formKey.currentState!.validate()) {
      try {
        List<String> respuestasIncorrectas = respuestasIncorrectasController
            .text
            .split('\n')
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty)
            .toList();

        if (respuestasIncorrectas.isEmpty) {
          throw Exception('Debe ingresar al menos una respuesta incorrecta');
        }

        Quiz nuevoQuiz = Quiz(
          idpreguntas: widget.idpreguntas,
          idtutor: widget.idTutor,
          idmateria: int.parse(_selectedMateria!),
          categoria: categoriaController.text,
          tipo: _selectedTipo!,
          dificultad: _selectedDificultad!,
          pregunta: preguntaController.text,
          respuestaCorrecta: respuestaCorrectaController.text,
          respuestasIncorrectas: respuestasIncorrectas,
          respuestaSeleccionada: 'Ninguna',
          estado_test: estado_test,
          tiempoLimite: tiempoLimiteController.text,
        );

        Map<String, dynamic> quizMap = nuevoQuiz.toJson();

        // Llamar al servicio para crear el quiz
        await quizService.crearQuiz(quizMap);

        // Mostrar un mensaje de éxito al usuario
        Dialogs.showSnackbar(context, 'Quiz creado exitosamente');
      } catch (e) {
        print('Error al crear quiz: $e');
        _showErrorSnackbar();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crear Quiz'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FutureBuilder<List<Materia>>(
                  future: materias,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Text('No hay materias disponibles');
                    } else {
                      final materiasList = snapshot.data!;
                      return DropdownButtonFormField<String>(
                        value: _selectedMateria,
                        decoration: InputDecoration(
                          labelText: 'Seleccione materia',
                          prefixIcon: Icon(Icons.subject),
                        ),
                        items: materiasList.map((materia) {
                          return DropdownMenuItem<String>(
                            value: materia.idmateria.toString(),
                            child: Text(materia.nombreMateria),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedMateria = value;
                          });
                        },
                        validator: requiredValidator,
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                        ),
                        dropdownColor:
                            Theme.of(context).scaffoldBackgroundColor,
                      );
                    }
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: categoriaController,
                  decoration: InputDecoration(
                      labelText: 'Escriba la categoria',
                      prefixIcon: Icon(Icons.category)),
                  validator: requiredValidator,
                  maxLines: null,
                ),
                SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  value: _selectedTipo,
                  decoration: InputDecoration(
                      labelText: 'Seleccione tipo',
                      prefixIcon: Icon(Icons.type_specimen)),
                  items: ['Seleccionar', 'Multiple', 'Verdadero/Falso']
                      .map((tipo) {
                    return DropdownMenuItem<String>(
                      value: tipo,
                      child: Text(tipo),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedTipo = value;
                    });
                  },
                  validator: requiredValidator,
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                  dropdownColor: Theme.of(context).scaffoldBackgroundColor,
                ),
                SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  value: _selectedDificultad,
                  decoration: InputDecoration(
                      labelText: 'Seleccione dificultad',
                      prefixIcon: Icon(Icons.leaderboard)),
                  items: ['Fácil', 'Medio', 'Difícil'].map((dificultad) {
                    return DropdownMenuItem<String>(
                      value: dificultad,
                      child: Text(dificultad),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedDificultad = value;
                    });
                  },
                  validator: requiredValidator,
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                  dropdownColor: Theme.of(context).scaffoldBackgroundColor,
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: preguntaController,
                  decoration: InputDecoration(
                      labelText: 'Pregunta',
                      prefixIcon: Icon(Icons.question_answer_sharp)),
                  validator: requiredValidator,
                  maxLines: null,
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: respuestaCorrectaController,
                  decoration: InputDecoration(
                      labelText: 'Respuesta Correcta',
                      prefixIcon: Icon(Icons.check_box)),
                  validator: requiredValidator,
                  maxLines: null,
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: respuestasIncorrectasController,
                  decoration: InputDecoration(
                      labelText: 'Respuestas Incorrectas (una por línea)',
                      prefixIcon: Icon(Icons.cancel)),
                  validator: requiredValidator,
                  maxLines: null,
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: tiempoLimiteController,
                  decoration: InputDecoration(
                      labelText: 'Tiempo Límite (ej. 60 minutos)',
                      prefixIcon: Icon(Icons.access_time)),
                  validator: requiredValidator,
                  maxLines: null,
                ),
                SizedBox(height: 20),
                Container(
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    onPressed: enviarQuiz,
                    child: Text('Crear Quiz'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
