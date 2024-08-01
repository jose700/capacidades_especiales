import 'dart:async';
import 'package:capacidades_especiales/app/models/tutor/login_model.dart';
import 'package:capacidades_especiales/app/widgets/estudiantes/tasks_students_widget/list_tasks_students_widget.dart';
import 'package:capacidades_especiales/app/widgets/search/no_results_widgets.dart';
import 'package:flutter/material.dart';
import 'package:capacidades_especiales/app/models/tutor/tutor_task_model.dart';
import 'package:capacidades_especiales/app/services/estudiante/tasks/tasks_students_service.dart';
import 'package:capacidades_especiales/app/screens/estudiantes/game/my_tasks/tasks_students/crud/add_task_screen.dart';
import 'package:capacidades_especiales/app/widgets/search/search_text_field_widget.dart';

class TareasEstudiantesScreen extends StatefulWidget {
  final String usuarioTutor;
  final Sesion sesion;
  TareasEstudiantesScreen(
      {Key? key, required this.usuarioTutor, required this.sesion})
      : super(key: key);

  @override
  _TareasEstudiantesScreen createState() => _TareasEstudiantesScreen();
}

class _TareasEstudiantesScreen extends State<TareasEstudiantesScreen> {
  final ServicioProgresoEstudiante _servicio = ServicioProgresoEstudiante();
  List<DatosTutor> _datosTutores = [];
  List<DatosTutor> _filteredDatosTutores = [];
  bool _isLoading = false;
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _cargarDatos();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _cargarDatos() async {
    setState(() {
      _isLoading = true;
    });

    try {
      List<DatosTutor> datos = await _servicio.obtenerTareasEstudiantesPorTutor(
          widget.usuarioTutor, widget.sesion.token);
      setState(() {
        _datosTutores = datos;
        _filteredDatosTutores = List.from(datos);
        _isLoading = false;
      });
    } catch (e) {
      print('Error al cargar los datos: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      filterTareas(_searchController.text);
    });
  }

  void filterTareas(String query) {
    setState(() {
      _filteredDatosTutores = _datosTutores.where((tutor) {
        return tutor.tareas.any((tarea) => tarea.containsQuery(query));
      }).toList();
    });
  }

  bool get _mostrarMensajeNoResultados =>
      !_isLoading && _filteredDatosTutores.isEmpty;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SearchTextField(searchController: _searchController),
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : _mostrarMensajeNoResultados
                    ? NoResultsWidget()
                    : TareasEstudiantesDataTableWidget(
                        datosTutores: _filteredDatosTutores,
                        sesion: widget.sesion),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddTaskScreen(
                  usuario: widget.usuarioTutor, sesion: widget.sesion),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
