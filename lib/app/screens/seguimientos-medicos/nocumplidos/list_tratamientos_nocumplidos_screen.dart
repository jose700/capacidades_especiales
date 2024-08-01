import 'dart:async';
import 'package:capacidades_especiales/app/models/seguimientos-medicos/tratamientos/compliment_model.dart';
import 'package:capacidades_especiales/app/models/tutor/login_model.dart';
import 'package:capacidades_especiales/app/services/seguimientos-medicos/tratamiento/service_no_cumplido.dart';
import 'package:capacidades_especiales/app/widgets/seguimientos-medicos/nocumplido/tratamiento_nocumplido_list_widget.dart';
import 'package:capacidades_especiales/app/widgets/search/search_text_field_widget.dart';
import 'package:flutter/material.dart';

class ListaTratamientosNoCumplidosScreen extends StatefulWidget {
  final String usuario;
  final Sesion sesion;
  const ListaTratamientosNoCumplidosScreen(
      {Key? key, required this.usuario, required this.sesion})
      : super(key: key);

  @override
  ListaTratamientosCumplidosNoScreenState createState() =>
      ListaTratamientosCumplidosNoScreenState();
}

class ListaTratamientosCumplidosNoScreenState
    extends State<ListaTratamientosNoCumplidosScreen> {
  final ServicioTratamientoNoCumplido servicioTratamientoNoCumplidos =
      ServicioTratamientoNoCumplido();
  late Future<List<TratamientoCumplido>> futureTratamientosNoCumplidos;
  final TextEditingController _searchController = TextEditingController();
  List<TratamientoCumplido> tratamientosNoCumplidos = [];
  List<TratamientoCumplido> filteredTratamientosNoCumplidos = [];
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    futureTratamientosNoCumplidos = _fetchTratamientosNoCumplidos();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  Future<List<TratamientoCumplido>> _fetchTratamientosNoCumplidos() async {
    try {
      final fetchedTratamientosNoCumplidos =
          await servicioTratamientoNoCumplidos
              .obtenerTratamientosNoCumplidosTutor(
                  widget.usuario, widget.sesion.token);
      setState(() {
        tratamientosNoCumplidos = fetchedTratamientosNoCumplidos;
        filteredTratamientosNoCumplidos = List.from(tratamientosNoCumplidos);
      });

      return fetchedTratamientosNoCumplidos;
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
      filteredTratamientosNoCumplidos = tratamientosNoCumplidos
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
              tratamientoCumplidos.idnocumplido
                  .toString()
                  .toLowerCase()
                  .contains(query.toLowerCase()))
          .toList();

      print('Tratamientos filtrados por búsqueda "$query":');
      filteredTratamientosNoCumplidos.forEach((tratamiento) {
        print(
            'ID: ${tratamiento.idnocumplido}, Estudiante: ${tratamiento.estudiante_nombres} ${tratamiento.estudiante_apellidos}');
      });
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
            onRefresh: _fetchTratamientosNoCumplidos,
            child: TratamientoNoCumplidoList(
              filteredTratamientosNoCumplidos: filteredTratamientosNoCumplidos,
              tratamientosNoCumplidos: tratamientosNoCumplidos,
              fetchTratamientosNoCumplidos: _fetchTratamientosNoCumplidos,
              context: context,
              servicioTratamientoNoCumplidos: servicioTratamientoNoCumplidos,
              sesion: widget.sesion,
            ),
          ),
        ),
      ],
    ));
  }
}
