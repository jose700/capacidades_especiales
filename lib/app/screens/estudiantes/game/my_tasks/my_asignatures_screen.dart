import 'package:capacidades_especiales/app/widgets/tutor/Home/messages/dialogs/login_message.dart';
import 'package:flutter/material.dart';
import 'package:capacidades_especiales/app/models/tutor/login_model.dart';
import 'package:capacidades_especiales/app/models/seguimientos-academicos/inscripcion/inscription_assignatura_model.dart';
import 'package:capacidades_especiales/app/screens/estudiantes/game/my_tasks/tasks_students/my_task_screen.dart';
import 'package:capacidades_especiales/app/services/seguimientos-academicos/inscripcion/inscripcion_materia_service.dart';

class MateriasEstudianteScreen extends StatefulWidget {
  final Sesion sesion;

  MateriasEstudianteScreen({Key? key, required this.sesion}) : super(key: key);

  @override
  _MateriasEstudianteScreenState createState() =>
      _MateriasEstudianteScreenState();
}

class _MateriasEstudianteScreenState extends State<MateriasEstudianteScreen>
    with TickerProviderStateMixin {
  final ServicioInscripcionMateria _servicioInscripcion =
      ServicioInscripcionMateria();
  late List<InscripcionMateria> _materias;
  bool _isLoading = false;
  late GlobalKey<RefreshIndicatorState> _refreshIndicatorKey;
  late AnimationController _listAnimationController;
  late Animation<double> _listAnimation;

  @override
  void initState() {
    super.initState();
    _materias = [];
    _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
    _fetchMateriasEstudiante();

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

  Future<void> _fetchMateriasEstudiante() async {
    setState(() {
      _isLoading = true;
    });

    try {
      List<InscripcionMateria> materias =
          await _servicioInscripcion.obtenerInscripcionesEstudiantes(
              widget.sesion.cedula.toString(), widget.sesion.token);

      setState(() {
        _materias = materias;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      Dialogs.showSnackbarError(context, 'Error al cargar las materias');
    }
  }

  Future<void> _handleRefresh() async {
    await _fetchMateriasEstudiante();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: _handleRefresh,
        child: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : _materias.isEmpty
                ? Center(
                    child: Text('No hay materias inscritas'),
                  )
                : FadeTransition(
                    opacity: _listAnimation,
                    child: ListView.builder(
                      itemCount: _materias.length,
                      itemBuilder: (context, index) {
                        return _buildMateriaCard(index);
                      },
                    ),
                  ),
      ),
    );
  }

  Widget _buildMateriaCard(int index) {
    InscripcionMateria materia = _materias[index];
    return FadeTransition(
      opacity: _listAnimation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: Offset(0, 0.5),
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: _listAnimationController,
          curve: Interval(
            (index + 1) / _materias.length,
            1.0,
            curve: Curves.easeInOut,
          ),
        )),
        child: Card(
          elevation: 2,
          margin: EdgeInsets.symmetric(
            vertical: 8,
            horizontal: 16,
          ),
          child: ListTile(
            title: Text(materia.nombreMateria ?? ''),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Créditos: ${materia.creditos ?? ''}'),
                Text('Jornada: ${materia.jornada ?? ''}'),
                Text('Curso: ${materia.curso ?? ''}'),
              ],
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MisTareasEstudiantesScreen(
                    materia: materia,
                    sesion: widget.sesion,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
