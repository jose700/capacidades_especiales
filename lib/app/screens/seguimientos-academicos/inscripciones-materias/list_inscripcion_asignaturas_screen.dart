import 'dart:async';
import 'package:capacidades_especiales/app/models/seguimientos-academicos/inscripcion/inscription_assignatura_model.dart';
import 'package:capacidades_especiales/app/models/tutor/login_model.dart';
import 'package:capacidades_especiales/app/screens/seguimientos-academicos/inscripciones-materias/agregar_inscripcion_materia_screen.dart';
import 'package:capacidades_especiales/app/services/seguimientos-academicos/inscripcion/inscripcion_materia_service.dart';
import 'package:capacidades_especiales/app/widgets/seguimientos-academicos/inscripcion/materia_inscripcion_list_widget.dart';
import 'package:capacidades_especiales/app/widgets/search/search_text_field_widget.dart';
import 'package:flutter/material.dart';

class ListaInscripcionAsignaturasScreen extends StatefulWidget {
  final String usuario;
  final Sesion sesion;
  const ListaInscripcionAsignaturasScreen(
      {Key? key, required this.usuario, required this.sesion})
      : super(key: key);

  @override
  ListaAsignaturasScreenState createState() => ListaAsignaturasScreenState();
}

class ListaAsignaturasScreenState
    extends State<ListaInscripcionAsignaturasScreen> {
  final ServicioInscripcionMateria servicioMateriaInscripcion =
      ServicioInscripcionMateria();
  late Future<List<InscripcionMateria>> futureMateriasInscritas;
  final TextEditingController _searchController = TextEditingController();
  List<InscripcionMateria> inscritas = [];
  List<InscripcionMateria> filteredMateriasInscritas = [];
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    futureMateriasInscritas = _fetchMateriasIncritas();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  Future<List<InscripcionMateria>> _fetchMateriasIncritas() async {
    try {
      final fetchedMaterias = await servicioMateriaInscripcion
          .obtenerInscripcionesTutor(widget.usuario, widget.sesion.token);
      setState(() {
        inscritas = fetchedMaterias;
        filteredMateriasInscritas = List.from(inscritas);
      });
      return fetchedMaterias;
    } catch (e) {
      return [];
    }
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      filterMaterias(_searchController.text);
    });
  }

  void filterMaterias(String query) {
    setState(() {
      filteredMateriasInscritas = inscritas
          .where((materia) =>
              materia.nombreMateria!
                  .toLowerCase()
                  .contains(query.toLowerCase()) ||
              materia.estado.toLowerCase().contains(query.toLowerCase()) ||
              materia.nombres!.toLowerCase().contains(query.toLowerCase()) ||
              materia.apellidos!.toLowerCase().contains(query.toLowerCase()) ||
              materia.correo!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SearchTextField(searchController: _searchController),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _fetchMateriasIncritas,
              child: MateriaInscripcionList(
                filteredMateriasInscritas: filteredMateriasInscritas,
                inscritas: inscritas,
                fetchMateriasIncritas: _fetchMateriasIncritas,
                context: context,
                servicioMateriaInscritas: servicioMateriaInscripcion,
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
              builder: (context) => AgregarInscripcionMateria(
                  sesion: widget.sesion,
                  usuario: widget.usuario,
                  idmateria: 1,
                  idestudiante: 1),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
