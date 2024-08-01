import 'package:capacidades_especiales/app/screens/estudiantes/game/quizz/resolver_quiz_screen.dart';
import 'package:capacidades_especiales/app/widgets/tutor/Home/messages/dialogs/login_message.dart';
import 'package:flutter/material.dart';
import 'package:capacidades_especiales/app/models/estudiantes/quizz/quitz_model.dart';
import 'package:capacidades_especiales/app/services/estudiante/quizz/quizz_service.dart';
import 'package:capacidades_especiales/app/models/tutor/login_model.dart';

class MyQuizzEstudianteScreen extends StatefulWidget {
  final Sesion sesion;
  MyQuizzEstudianteScreen({Key? key, required this.sesion}) : super(key: key);

  @override
  _MyQuizzEstudianteScreenState createState() =>
      _MyQuizzEstudianteScreenState();
}

class _MyQuizzEstudianteScreenState extends State<MyQuizzEstudianteScreen>
    with TickerProviderStateMixin {
  final QuizService _quizService = QuizService();
  late List<Quiz> _quizzes;
  bool _isLoading = false;
  late AnimationController _listAnimationController;
  late Animation<double> _listAnimation;

  @override
  void initState() {
    super.initState();
    _quizzes = [];
    _fetchQuizzes();

    _listAnimationController = AnimationController(
      vsync: this,
      duration:
          Duration(milliseconds: 500), // Reducido para una respuesta más rápida
    );

    _listAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _listAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    _listAnimationController.forward();
  }

  @override
  void dispose() {
    _listAnimationController.dispose();
    super.dispose();
  }

  Future<void> _fetchQuizzes() async {
    setState(() {
      _isLoading = true;
    });

    try {
      List<Quiz> quizzes = await _quizService.getQuizzesByCedulaEstudiante(
        widget.sesion.cedula.toString(),
        widget.sesion.token,
      );

      // Filtrar solo los quizzes completados y únicos por asignatura
      Set<String> seenSubjects = Set();
      List<Quiz> completedQuizzes = [];

      for (var quiz in quizzes) {
        if (quiz.estado_test == 'Completado' &&
            !seenSubjects.contains(quiz.nombreMateria)) {
          completedQuizzes.add(quiz);
          seenSubjects.add(quiz.nombreMateria.toString());
        }
      }

      setState(() {
        _quizzes = completedQuizzes;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _handleRefresh() async {
    await _fetchQuizzes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : _quizzes.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize
                          .min, // Ajusta el tamaño del Column al contenido
                      mainAxisAlignment: MainAxisAlignment
                          .center, // Centra el contenido verticalmente
                      children: [
                        Icon(
                          Icons
                              .info_outline, // Cambia el ícono según tus necesidades
                          // Ajusta el color del ícono
                          size:
                              50, // Ajusta el tamaño del ícono si es necesario
                        ),
                        SizedBox(
                            height: 8), // Espacio entre el ícono y el texto
                        Text(
                          'No hay cuestionarios realizados',
                          style: TextStyle(
                            // Ajusta el color del texto
                            fontSize: 16, // Ajusta el tamaño de la fuente
                          ),
                        ),
                      ],
                    ),
                  )
                : FadeTransition(
                    opacity: _listAnimation,
                    child: ListView.builder(
                      itemCount: _quizzes.length,
                      itemBuilder: (context, index) {
                        return _buildQuizCard(index);
                      },
                    ),
                  ),
      ),
    );
  }

  Widget _buildQuizCard(int index) {
    Quiz quiz = _quizzes[index];
    Color estadoColor = _getEstadoColor(quiz.estado_test.toString());
    String tiempoLimite = 'Tiempo límite: ${quiz.tiempoLimite}';
    String calificacionText = '';

    if (quiz.estado_test == 'Completado') {
      calificacionText =
          'Calificación: ${quiz.calificacion != null ? quiz.calificacion!.toStringAsFixed(2) : "Sin calificar"}';
    } else {
      calificacionText = 'Aún por calificar';
    }

    return FadeTransition(
      opacity: _listAnimation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: Offset(0, 0.5),
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: _listAnimationController,
          curve: Interval(
            (index + 1) / _quizzes.length,
            1.0,
            curve: Curves.easeInOut,
          ),
        )),
        child: Card(
          elevation: 2,
          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: ListTile(
            title: Text(quiz.nombreMateria ?? ''),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Estado: ${quiz.estado_test ?? ''}',
                    style: TextStyle(color: estadoColor)),
                Row(
                  children: [
                    Text(tiempoLimite),
                    SizedBox(width: 4),
                    Icon(Icons.access_time),
                  ],
                ),
                Text(calificacionText),
                Text('Categoría: ${quiz.categoria}'),
                Text('Dificultad: ${quiz.dificultad}'),
              ],
            ),
            onTap: () {
              if (quiz.estado_test == 'Completado') {
                Dialogs.showSnackbar(
                    context, 'Esta prueba ya ha sido completada.');
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ResolverQuizScreen(
                      sesion: widget.sesion,
                      materia: quiz.nombreMateria ?? '',
                      cedulaEstudiante: widget.sesion.cedula.toString(),
                      quiz: quiz,
                    ),
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }

  Color _getEstadoColor(String estado) {
    switch (estado) {
      case 'Test':
        return Colors.blue;
      case 'Completado':
        return Colors.green;
      case 'En progreso':
        return Colors.orange;
      case 'No Completado':
        return Colors.red;
      default:
        return Colors.grey; // Color por defecto para cualquier otro estado
    }
  }
}
