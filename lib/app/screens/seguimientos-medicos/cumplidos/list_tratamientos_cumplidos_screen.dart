import 'dart:async';
import 'package:capacidades_especiales/app/models/seguimientos-medicos/tratamientos/compliment_model.dart';
import 'package:capacidades_especiales/app/models/tutor/login_model.dart';
import 'package:capacidades_especiales/app/screens/seguimientos-medicos/cumplidos/agregar_tratamientos_cumplidos_screen.dart';
import 'package:capacidades_especiales/app/services/seguimientos-medicos/tratamiento/service_cumplido.dart';
import 'package:capacidades_especiales/app/widgets/search/search_text_field_widget.dart';

import 'package:flutter/material.dart';

import '../../../widgets/seguimientos-medicos/cumplido/tratamiento_cumplido_list_widget.dart';

class ListaTratamientosCumplidosScreen extends StatefulWidget {
  final String usuario;
  final Sesion sesion;
  const ListaTratamientosCumplidosScreen(
      {Key? key, required this.usuario, required this.sesion})
      : super(key: key);

  @override
  ListaTratamientosCumplidosScreenState createState() =>
      ListaTratamientosCumplidosScreenState();
}

class ListaTratamientosCumplidosScreenState
    extends State<ListaTratamientosCumplidosScreen> {
  final ServicioTratamientoCumplido servicioTratamientoCumplidos =
      ServicioTratamientoCumplido();
  late Future<List<TratamientoCumplido>> futureTratamientosCumplidos;
  final TextEditingController _searchController = TextEditingController();
  List<TratamientoCumplido> tratamientosCumplidos = [];
  List<TratamientoCumplido> filteredTratamientosCumplidos = [];
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    futureTratamientosCumplidos = _fetchTratamientosCumplidos();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  Future<List<TratamientoCumplido>> _fetchTratamientosCumplidos() async {
    try {
      final fetchedTratamientosCumplidos =
          await servicioTratamientoCumplidos.obtenerTratamientosCumplidosTutor(
              widget.usuario, widget.sesion.token);
      setState(() {
        tratamientosCumplidos = fetchedTratamientosCumplidos;
        filteredTratamientosCumplidos = List.from(tratamientosCumplidos);
      });
      return fetchedTratamientosCumplidos;
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
      filteredTratamientosCumplidos = tratamientosCumplidos
          .where((tratamientoCumplidos) =>
              tratamientoCumplidos.usuariotutor
                  .toLowerCase()
                  .contains(query.toLowerCase()) ||
              tratamientoCumplidos.estudiante_nombres!
                  .toLowerCase()
                  .contains(query.toLowerCase()) ||
              tratamientoCumplidos.estudiante_apellidos!
                  .toLowerCase()
                  .contains(query.toLowerCase()) ||
              tratamientoCumplidos.estudiante_cedula!
                  .toLowerCase()
                  .contains(query.toLowerCase()) ||
              tratamientoCumplidos.observacion
                  .toLowerCase()
                  .contains(query.toLowerCase()) ||
              tratamientoCumplidos.usuariotutor
                  .toLowerCase()
                  .contains(query.toLowerCase()) ||
              tratamientoCumplidos.idtratamiento
                  .toString()
                  .toLowerCase()
                  .contains(query.toLowerCase()) ||
              tratamientoCumplidos.idcumplido
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
              onRefresh: _fetchTratamientosCumplidos,
              child: TratamientoCumplidoList(
                filteredTratamientosCumplidos: filteredTratamientosCumplidos,
                tratamientosCumplidos: tratamientosCumplidos,
                fetchTratamientosCumplidos: _fetchTratamientosCumplidos,
                context: context,
                servicioTratamientoCumplidos: servicioTratamientoCumplidos,
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
              builder: (context) => AgregarTratamientosCumplidosScreen(
                sesion: widget.sesion,
                usuario: widget.usuario,
                idtratamiento: 1,
                idcumplido: 1,
                idnocumplido: 1,
              ),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
