import 'dart:async';
import 'package:capacidades_especiales/app/models/representantes/representative_model.dart';
import 'package:capacidades_especiales/app/models/tutor/login_model.dart';

import 'package:capacidades_especiales/app/services/representante/service_representantes.dart';
import 'package:capacidades_especiales/app/widgets/representantes/list_representantes_widget.dart';
import 'package:capacidades_especiales/app/widgets/search/search_text_field_widget.dart';
import 'package:flutter/material.dart';

class ListaRepresentantesScreen extends StatefulWidget {
  final String usuario;
  final Sesion sesion;
  const ListaRepresentantesScreen(
      {Key? key, required this.usuario, required this.sesion})
      : super(key: key);

  @override
  _ListaRepresentantesScreenState createState() =>
      _ListaRepresentantesScreenState();
}

class _ListaRepresentantesScreenState extends State<ListaRepresentantesScreen> {
  final ServicioRepresentante servicioRepresentante = ServicioRepresentante();
  late Future<List<Representante>> futureRepresentantes;
  final TextEditingController _searchController = TextEditingController();
  List<Representante> representantes = [];
  List<Representante> filteredRepresentantes = [];
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    futureRepresentantes = _fetchRepresentantes();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  Future<List<Representante>> _fetchRepresentantes() async {
    try {
      final fetchedRepresentantes = await servicioRepresentante
          .obtenerRepresentantesTutor(widget.usuario, widget.sesion.token);
      setState(() {
        representantes = fetchedRepresentantes;
        filteredRepresentantes = List.from(representantes);
      });
      return fetchedRepresentantes;
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
      filteredRepresentantes = representantes
          .where((representante) =>
              representante.representandoNombres!
                  .toLowerCase()
                  .contains(query.toLowerCase()) ||
              representante.representandoApellidos!
                  .toLowerCase()
                  .contains(query.toLowerCase()) ||
              representante.nombres!
                  .toLowerCase()
                  .contains(query.toLowerCase()) ||
              representante.apellidos!
                  .toLowerCase()
                  .contains(query.toLowerCase()) ||
              representante.correo!
                  .toLowerCase()
                  .contains(query.toLowerCase()) ||
              representante.numberphone!
                  .toLowerCase()
                  .contains(query.toLowerCase()) ||
              representante.cedula!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de representantes'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          SearchTextField(searchController: _searchController),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _fetchRepresentantes,
              child: RepresentanteListScreen(
                sesion: widget.sesion,
                futureRepresentantes: futureRepresentantes,
                filteredRepresentantes: filteredRepresentantes,
                updateRepresentantes: (changed) async {
                  if (changed) {
                    await _fetchRepresentantes();
                  }
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
