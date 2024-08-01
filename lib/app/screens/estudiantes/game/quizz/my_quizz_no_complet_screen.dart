import 'package:capacidades_especiales/app/screens/estudiantes/game/quizz/resolver_quiz_screen.dart';
import 'package:capacidades_especiales/app/widgets/tutor/Home/messages/dialogs/login_message.dart';
import 'package:flutter/material.dart';
import 'package:capacidades_especiales/app/models/estudiantes/quizz/quitz_model.dart';
import 'package:capacidades_especiales/app/services/estudiante/quizz/quizz_service.dart';
import 'package:capacidades_especiales/app/models/tutor/login_model.dart';

class MyQuizzNoCompleteEstudianteScreen extends StatefulWidget {
  final Sesion sesion;
  MyQuizzNoCompleteEstudianteScreen({Key? key, required this.sesion})
      : super(key: key);

  @override
  _MyQuizzNoCompleteEstudianteScreenState createState() =>
      _MyQuizzNoCompleteEstudianteScreenState();
}

class _MyQuizzNoCompleteEstudianteScreenState
    extends State<MyQuizzNoCompleteEstudianteScreen>
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

      // Filtrar solo los quizzes no completados
      List<Quiz> incompleteQuizzes =
          quizzes.where((quiz) => quiz.estado_test != 'Completado').toList();

      // Filtrar para mostrar solo una instancia de cada materia
      Map<String, Quiz> uniqueQuizzesMap = {};
      incompleteQuizzes.forEach((quiz) {
        // Usar el nombre de la materia como clave en el mapa para garantizar unicidad
        uniqueQuizzesMap[quiz.nombreMateria ?? ''] = quiz;
      });

      // Convertir de nuevo a lista después de eliminar duplicados por nombre de materia
      List<Quiz> uniqueQuizzes = uniqueQuizzesMap.values.toList();

      setState(() {
        _quizzes = uniqueQuizzes;
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
                          'No hay cuestionarios disponibles',
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
    Color estadoColor = _getEstadoColor(quiz.estado_test);
    String estadoTexto = _getEstadoTexto(quiz.estado_test);
    String tiempoLimite =
        'Tiempo límite: ${quiz.tiempoLimite ?? 'No definido'}';

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
            title: Text(quiz.nombreMateria ?? 'Materia desconocida'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Estado: ${estadoTexto}',
                    style: TextStyle(color: estadoColor)),
                Row(
                  children: [
                    Text(tiempoLimite),
                    SizedBox(width: 4),
                    Icon(Icons.access_time),
                  ],
                ),
                Text('Categoría: ${quiz.categoria ?? 'No definida'}'),
                Text('Dificultad: ${quiz.dificultad ?? 'No definida'}'),
              ],
            ),
            onTap: () {
              if (quiz.estado_test == 'Completado') {
                // Mostrar un mensaje indicando que el quiz está completado
                Dialogs.showSnackbar(
                    context, 'Esta prueba ya ha sido completada.');
              } else {
                // Navegar a la pantalla ResolverQuizScreen
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

  Color _getEstadoColor(String? estado) {
    switch (estado) {
      case 'Test':
        return Colors.blue;
      case 'En progreso':
        return Colors.orange;
      case 'No Completado':
        return Colors.red;
      case 'Completado':
        return Colors.green;
      default:
        return Colors.red; // Rojo por defecto para estado nulo o no reconocido
    }
  }

  String _getEstadoTexto(String? estado) {
    switch (estado) {
      case 'Test':
        return 'En espera';
      case 'En progreso':
        return 'En progreso';
      case 'No Completado':
        return 'No Completado';
      case 'Completado':
        return 'Completado';
      default:
        return 'No completado'; // Texto por defecto para estado nulo o no reconocido
    }
  }
}
