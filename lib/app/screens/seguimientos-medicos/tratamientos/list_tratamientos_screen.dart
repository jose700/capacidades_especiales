import 'dart:async';
import 'package:capacidades_especiales/app/models/seguimientos-medicos/tratamientos/treatment_model.dart';
import 'package:capacidades_especiales/app/models/tutor/login_model.dart';
import 'package:capacidades_especiales/app/screens/seguimientos-medicos/tratamientos/agregar_tratamientos_screen.dart';
import 'package:capacidades_especiales/app/services/seguimientos-medicos/tratamiento/service_tratamiento.dart';
import 'package:capacidades_especiales/app/widgets/search/search_text_field_widget.dart';
import 'package:capacidades_especiales/app/widgets/seguimientos-medicos/tratamientos/tratamiento_list_widget.dart';
import 'package:flutter/material.dart';

class ListaTratamientosScreen extends StatefulWidget {
  final String usuario;
  final Sesion sesion;
  const ListaTratamientosScreen(
      {Key? key, required this.usuario, required this.sesion})
      : super(key: key);

  @override
  ListaTratamientosScreenState createState() => ListaTratamientosScreenState();
}

class ListaTratamientosScreenState extends State<ListaTratamientosScreen> {
  final ServicioTratamiento servicioTratamiento = ServicioTratamiento();
  late Future<List<Tratamiento>> futureTratamientos;
  final TextEditingController _searchController = TextEditingController();
  List<Tratamiento> tratamientos = [];
  List<Tratamiento> filteredTratamientos = [];
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    futureTratamientos = _fetchTratamientos();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  Future<List<Tratamiento>> _fetchTratamientos() async {
    try {
      final fetchedTratamientos = await servicioTratamiento
          .obtenerTratamientosTutor(widget.usuario, widget.sesion.token);
      setState(() {
        tratamientos = fetchedTratamientos;
        filteredTratamientos = List.from(tratamientos);
      });
      return fetchedTratamientos;
    } catch (e) {
      return [];
    }
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      filterRepresentantes(_searchController.text);
    });
  }

  void filterRepresentantes(String query) {
    setState(() {
      filteredTratamientos = tratamientos
          .where((tratamiento) =>
              tratamiento.clasediscapacidad
                  .toLowerCase()
                  .contains(query.toLowerCase()) ||
              tratamiento.estudiante_nombres!
                  .toLowerCase()
                  .contains(query.toLowerCase()) ||
              tratamiento.estudiante_apellidos!
                  .toLowerCase()
                  .contains(query.toLowerCase()) ||
              tratamiento.estudiante_cedula!
                  .toLowerCase()
                  .contains(query.toLowerCase()) ||
              tratamiento.descripcionconsulta
                  .toLowerCase()
                  .contains(query.toLowerCase()) ||
              tratamiento.usuariotutor
                  .toLowerCase()
                  .contains(query.toLowerCase()) ||
              tratamiento.opinionpaciente
                  .toLowerCase()
                  .contains(query.toLowerCase()) ||
              tratamiento.tratamientopsicologico
                  .toLowerCase()
                  .contains(query.toLowerCase()) ||
              tratamiento.tratamientofisico
                  .toLowerCase()
                  .contains(query.toLowerCase()) ||
              tratamiento.resultado.toLowerCase().contains(query.toLowerCase()))
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
              onRefresh: _fetchTratamientos,
              child: TratamientoList(
                filteredTratamientos: filteredTratamientos,
                tratamientos: tratamientos,
                fetchTratamientos: _fetchTratamientos,
                context: context,
                servicioTratamiento: servicioTratamiento,
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
              builder: (context) => AgregarTratamientosScreen(
                sesion: widget.sesion,
                usuario: widget.usuario,
                idestudiante: 1,
                idtratamiento: 1,
              ),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
