import 'dart:async';
import 'package:capacidades_especiales/app/screens/estudiantes/game/my_tasks/tasks_students/subir_tasks_screen.dart';
import 'package:capacidades_especiales/app/widgets/search/no_results_widgets.dart';
import 'package:flutter/material.dart';
import 'package:capacidades_especiales/app/models/estudiantes/tareas/data_task_model.dart';
import 'package:capacidades_especiales/app/models/seguimientos-academicos/inscripcion/inscription_assignatura_model.dart';
import 'package:capacidades_especiales/app/models/tutor/login_model.dart';
import 'package:capacidades_especiales/app/widgets/estudiantes/tasks_students_widget/my_list_tasks_students_widget.dart';
import 'package:capacidades_especiales/app/services/estudiante/tasks/tasks_students_service.dart';
import 'package:capacidades_especiales/app/widgets/search/search_text_field_widget.dart';

class MisTareasEstudiantesScreen extends StatefulWidget {
  final Sesion sesion;
  final InscripcionMateria materia;
  MisTareasEstudiantesScreen(
      {Key? key, required this.sesion, required this.materia})
      : super(key: key);

  @override
  _TareasEstudiantesScreenState createState() =>
      _TareasEstudiantesScreenState();
}

class _TareasEstudiantesScreenState extends State<MisTareasEstudiantesScreen> {
  final ServicioProgresoEstudiante _servicio = ServicioProgresoEstudiante();
  List<DatosTareasEstudiantes> _datosTutores = [];
  List<DatosTareasEstudiantes> _filteredDatosTutores = [];
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
      List<DatosTareasEstudiantes> datos =
          await _servicio.obtenerTareasEstudiante(
              widget.sesion.cedula.toString(),
              widget.materia.idmateria.toString(),
              widget.sesion.token);
      setState(() {
        _datosTutores = datos;
        _filteredDatosTutores = List.from(datos);
        _isLoading = false;
      });
      print('Datos cargados: $_datosTutores');
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
        // Filtrar solo si la materia tiene tareas que coincidan con la búsqueda
        return tutor.tareas.any((tarea) => tarea.containsQuery(query));
      }).toList();
    });
  }

  void _navigateToSubirTareaScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SubirTareaScreen(
          sesion: widget.sesion,
          materia: widget.materia,
          tareas: _datosTutores.first,
        ),
      ),
    ).then((_) {
      _cargarDatos(); // Recargar datos después de regresar del screen de subir tarea
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mis tareas'),
      ),
      body: Column(
        children: [
          if (_datosTutores
              .isNotEmpty) // Mostrar el campo de búsqueda solo si hay tareas
            SearchTextField(searchController: _searchController),
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : _filteredDatosTutores.isEmpty &&
                        _searchController.text.isNotEmpty
                    ? NoResultsWidget()
                    : _filteredDatosTutores.isEmpty
                        ? NoTasksAssignedWidget()
                        : ListView.builder(
                            itemCount: _filteredDatosTutores.length,
                            itemBuilder: (context, index) {
                              final datosTutor = _filteredDatosTutores[index];
                              return MisTareasEstudiantesDataTableWidget(
                                datosTutores: [datosTutor],
                              );
                            },
                          ),
          ),
        ],
      ),
      floatingActionButton: _datosTutores.any((datosTutor) {
        return datosTutor.tareas
            .any((tarea) => tarea.tarea_cumplida_subida != true);
      })
          ? FloatingActionButton(
              onPressed: _navigateToSubirTareaScreen,
              child: Icon(Icons.add),
            )
          : null,
    );
  }
}
