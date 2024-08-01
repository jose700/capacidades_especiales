import 'dart:async';
import 'package:capacidades_especiales/app/models/seguimientos-academicos/materias/assignature_model.dart';
import 'package:capacidades_especiales/app/models/tutor/login_model.dart';
import 'package:capacidades_especiales/app/screens/seguimientos-academicos/materias/agregar_asignaturas_screen.dart';
import 'package:capacidades_especiales/app/services/seguimientos-academicos/materia/materia_service.dart';
import 'package:capacidades_especiales/app/widgets/seguimientos-academicos/materias/materia_list_widget.dart';
import 'package:capacidades_especiales/app/widgets/search/search_text_field_widget.dart';
import 'package:flutter/material.dart';

class ListaAsignaturasScreen extends StatefulWidget {
  final String usuario;
  final Sesion sesion;
  const ListaAsignaturasScreen(
      {Key? key, required this.usuario, required this.sesion})
      : super(key: key);

  @override
  ListaAsignaturasScreenState createState() => ListaAsignaturasScreenState();
}

class ListaAsignaturasScreenState extends State<ListaAsignaturasScreen> {
  final ServicioMateria servicioMateria = ServicioMateria();
  late Future<List<Materia>> futureMaterias;
  final TextEditingController _searchController = TextEditingController();
  List<Materia> materias = [];
  List<Materia> filteredMaterias = [];
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    futureMaterias = _fetchMaterias();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  Future<List<Materia>> _fetchMaterias() async {
    try {
      final fetchedMaterias = await servicioMateria.obtenerMateriasTutor(
          widget.usuario, widget.sesion.token);
      setState(() {
        materias = fetchedMaterias;
        filteredMaterias = List.from(materias);
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
      filteredMaterias = materias
          .where((materia) =>
              materia.nombreMateria
                  .toLowerCase()
                  .contains(query.toLowerCase()) ||
              materia.descripcion.toLowerCase().contains(query.toLowerCase()) ||
              materia.curso.toLowerCase().contains(query.toLowerCase()) ||
              materia.institucion.toLowerCase().contains(query.toLowerCase()) ||
              materia.jornada.toLowerCase().contains(query.toLowerCase()) ||
              materia.paralelo.toLowerCase().contains(query.toLowerCase()) ||
              materia.nivel.toLowerCase().contains(query.toLowerCase()) ||
              materia.creditos
                  .toString()
                  .toLowerCase()
                  .contains(query.toLowerCase()))
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
              onRefresh: _fetchMaterias,
              child: MateriaList(
                filteredMaterias: filteredMaterias,
                materias: materias,
                fetchMaterias: _fetchMaterias,
                context: context,
                servicioMateria: servicioMateria,
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
              builder: (context) => AgregarMateriasScreen(
                sesion: widget.sesion,
                usuario: widget.usuario,
                idmateria: 1,
              ),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
