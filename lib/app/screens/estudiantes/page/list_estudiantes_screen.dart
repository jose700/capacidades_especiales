import 'dart:async';
import 'package:capacidades_especiales/app/models/tutor/login_model.dart';
import 'package:capacidades_especiales/app/screens/estudiantes/page/agregar_estudiantes_screen.dart';
import 'package:capacidades_especiales/app/widgets/estudiantes/student_list_widget.dart';
import 'package:capacidades_especiales/app/models/estudiantes/student_model.dart';

import 'package:capacidades_especiales/app/services/estudiante/service_estudiantes.dart';
import 'package:capacidades_especiales/app/screens/estudiantes/pdf/PdfPreviewScreen.dart';
import 'package:capacidades_especiales/app/widgets/tutor/Home/messages/dialogs/login_message.dart';
import 'package:capacidades_especiales/app/widgets/search/search_text_field_widget.dart';
import 'package:flutter/material.dart';

class ListaEstudiantesScreen extends StatefulWidget {
  final int idTutor;
  final String usuario;
  final Sesion sesion;
  const ListaEstudiantesScreen({
    Key? key,
    required this.idTutor,
    required this.usuario,
    required this.sesion,
  }) : super(key: key);

  @override
  _ListaEstudiantesScreenState createState() => _ListaEstudiantesScreenState();
}

class _ListaEstudiantesScreenState extends State<ListaEstudiantesScreen> {
  final ServicioEstudiante servicioEstudiante = ServicioEstudiante();
  late Future<List<Estudiante>> futureEstudiantes;
  final TextEditingController _searchController = TextEditingController();
  List<Estudiante> estudiantes = [];
  List<Estudiante> filteredEstudiantes = [];
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    futureEstudiantes = _fetchEstudiantes();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  Future<List<Estudiante>> _fetchEstudiantes() async {
    try {
      final fetchedEstudiantes = await servicioEstudiante
          .obtenerEstudiantesTutor(widget.usuario, widget.sesion.token);
      setState(() {
        estudiantes = fetchedEstudiantes;
        filteredEstudiantes = List.from(estudiantes);
      });
      return fetchedEstudiantes;
    } catch (e) {
      return [];
    }
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      filterEstudiantes(_searchController.text);
    });
  }

  void filterEstudiantes(String query) {
    setState(() {
      filteredEstudiantes = estudiantes
          .where((estudiante) =>
              estudiante.nombres!.toLowerCase().contains(query.toLowerCase()) ||
              estudiante.apellidos!
                  .toLowerCase()
                  .contains(query.toLowerCase()) ||
              estudiante.cedula!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _onExportToPdf() {
    if (filteredEstudiantes.isEmpty) {
      Dialogs.showSnackbar(context, 'Lo sentimos, aún no hay datos.');
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              PdfPreviewScreen(estudiantes: filteredEstudiantes),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de estudiante'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          _buildDownloadOptions(),
          SearchTextField(searchController: _searchController),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _fetchEstudiantes,
              child: StudentList(
                filteredEstudiantes: filteredEstudiantes,
                estudiantes: estudiantes,
                fetchEstudiantes: _fetchEstudiantes,
                context: context,
                servicioEstudiante: servicioEstudiante,
                sesion: widget.sesion,
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AgregarEstudianteScreen(
                sesion: widget.sesion,
                idTutor: widget.idTutor,
                usuario: widget.usuario,
                idEstudiante: 1,
              ),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildDownloadOptions() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          const Text('Ver en Formato:'),
          IconButton(
            onPressed: _onExportToPdf,
            icon: const Icon(Icons.picture_as_pdf),
            tooltip: 'Exportar a PDF',
          ),
        ],
      ),
    );
  }
}
