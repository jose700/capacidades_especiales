import 'dart:async';
import 'package:capacidades_especiales/app/models/seguimientos-academicos/materias/approved_assignatura_model.dart';
import 'package:capacidades_especiales/app/models/tutor/login_model.dart';
import 'package:capacidades_especiales/app/services/seguimientos-academicos/materia/materia_reprobada_service.dart';
import 'package:capacidades_especiales/app/widgets/seguimientos-academicos/materias/materia_reprobadas_list_widget.dart';
import 'package:capacidades_especiales/app/widgets/search/search_text_field_widget.dart';
import 'package:flutter/material.dart';

class ListaAsignaturasReprobadasScreen extends StatefulWidget {
  final String usuario;
  final Sesion sesion;
  const ListaAsignaturasReprobadasScreen(
      {Key? key, required this.usuario, required this.sesion})
      : super(key: key);

  @override
  ListaAsignaturasScreenState createState() => ListaAsignaturasScreenState();
}

class ListaAsignaturasScreenState
    extends State<ListaAsignaturasReprobadasScreen> {
  final MateriaReprobadaService servicioMateriaReprobada =
      MateriaReprobadaService();
  late Future<List<MateriaAprobada>> futureMateriasReprobadas;
  final TextEditingController _searchController = TextEditingController();
  List<MateriaAprobada> reprobadas = [];
  List<MateriaAprobada> filteredMateriasReprobadas = [];
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    futureMateriasReprobadas = _fetchMateriasReprobadas();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  Future<List<MateriaAprobada>> _fetchMateriasReprobadas() async {
    try {
      final fetchedMateriasReprobadas = await servicioMateriaReprobada
          .obtenerMateriasReprobadasTutor(widget.usuario, widget.sesion.token);
      setState(() {
        reprobadas = fetchedMateriasReprobadas;
        filteredMateriasReprobadas = List.from(reprobadas);
      });
      print('Materias reprobadas obtenidas correctamente en el widget');
      return fetchedMateriasReprobadas;
    } catch (e) {
      print('Error al obtener las materias aprobadas en el widget: $e');
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
      filteredMateriasReprobadas = reprobadas
          .where((reprobada) =>
              reprobada.nombreMateria!
                  .toLowerCase()
                  .contains(query.toLowerCase()) ||
              reprobada.apellidos!
                  .toLowerCase()
                  .contains(query.toLowerCase()) ||
              reprobada.nombres!.toLowerCase().contains(query.toLowerCase()) ||
              reprobada.cedula!.toLowerCase().contains(query.toLowerCase()) ||
              reprobada.observacion.toLowerCase().contains(query.toLowerCase()))
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
              onRefresh: _fetchMateriasReprobadas,
              child: MateriaReprobadasList(
                filteredMateriasReprobadas: filteredMateriasReprobadas,
                reprobadas: reprobadas,
                fetchMateriasReprobadas: _fetchMateriasReprobadas,
                context: context,
                servicioMateriaReprobada: servicioMateriaReprobada,
                sesion: widget.sesion,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
