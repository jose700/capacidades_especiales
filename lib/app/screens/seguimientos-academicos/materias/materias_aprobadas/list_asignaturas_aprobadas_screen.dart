import 'dart:async';
import 'package:capacidades_especiales/app/models/seguimientos-academicos/materias/approved_assignatura_model.dart';
import 'package:capacidades_especiales/app/models/tutor/login_model.dart';
import 'package:capacidades_especiales/app/screens/seguimientos-academicos/materias/materias_aprobadas/agregar_asignaturas_aprobadas_screen.dart';
import 'package:capacidades_especiales/app/services/seguimientos-academicos/materia/materia_aprobada_service.dart';
import 'package:capacidades_especiales/app/widgets/seguimientos-academicos/materias/materia_aprobadas_list_widget.dart';
import 'package:capacidades_especiales/app/widgets/search/search_text_field_widget.dart';
import 'package:flutter/material.dart';

class ListaAsignaturasAprobadasScreen extends StatefulWidget {
  final String usuario;
  final Sesion sesion;
  const ListaAsignaturasAprobadasScreen(
      {Key? key, required this.usuario, required this.sesion})
      : super(key: key);

  @override
  ListaAsignaturasScreenState createState() => ListaAsignaturasScreenState();
}

class ListaAsignaturasScreenState
    extends State<ListaAsignaturasAprobadasScreen> {
  final MateriaAprobadaService servicioMateriaAprobada =
      MateriaAprobadaService();
  late Future<List<MateriaAprobada>> futureMateriasAprobadas;
  final TextEditingController _searchController = TextEditingController();
  List<MateriaAprobada> aprobadas = [];
  List<MateriaAprobada> filteredMateriasAprobadas = [];
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    futureMateriasAprobadas = _fetchMateriasAprobadas();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  Future<List<MateriaAprobada>> _fetchMateriasAprobadas() async {
    try {
      final fetchedMateriasAprobadas = await servicioMateriaAprobada
          .obtenerMateriasAprobadasTutor(widget.usuario, widget.sesion.token);
      setState(() {
        aprobadas = fetchedMateriasAprobadas;
        filteredMateriasAprobadas = List.from(aprobadas);
      });
      print('Materias aprobadas obtenidas correctamente en el widget');
      return fetchedMateriasAprobadas;
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
      filteredMateriasAprobadas = aprobadas
          .where((aprobada) =>
              aprobada.nombreMateria!
                  .toLowerCase()
                  .contains(query.toLowerCase()) ||
              aprobada.apellidos!.toLowerCase().contains(query.toLowerCase()) ||
              aprobada.nombres!.toLowerCase().contains(query.toLowerCase()) ||
              aprobada.cedula!.toLowerCase().contains(query.toLowerCase()) ||
              aprobada.observacion.toLowerCase().contains(query.toLowerCase()))
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
              onRefresh: _fetchMateriasAprobadas,
              child: MateriaAprobadasList(
                sesion: widget.sesion,
                filteredMateriasAprobadas: filteredMateriasAprobadas,
                aprobadas: aprobadas,
                fetchMateriasAprobadas: _fetchMateriasAprobadas,
                context: context,
                servicioMateriaAprobada: servicioMateriaAprobada,
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
              builder: (context) => AgregarMateriasAprobadasScreen(
                sesion: widget.sesion,
                usuario: widget.usuario,
                idaprobada: 1,
              ),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
