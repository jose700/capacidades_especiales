import 'dart:convert';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:capacidades_especiales/app/screens/estudiantes/game/painter/painter_image_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'package:capacidades_especiales/app/models/estudiantes/playing/painter/painter_item_model.dart';

class PainterScreen extends StatefulWidget {
  @override
  _PainterScreenState createState() => _PainterScreenState();
}

class _PainterScreenState extends State<PainterScreen> {
  late List<PainterItem> painterList;
  final ScrollController _controller = ScrollController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    painterList = [];
    _controller.addListener(_listener);
    loadPainterData();
  }

  void _listener() {
    final maxScroll = _controller.position.maxScrollExtent;
    final minScroll = _controller.position.minScrollExtent;

    if (_controller.offset >= maxScroll) {
      setState(() {});
    }

    if (_controller.offset <= minScroll) {
      setState(() {});
    }
  }

  Future<void> loadPainterData() async {
    try {
      String jsonString =
          await rootBundle.loadString('assets/json/painter_data.json');
      final jsonData = jsonDecode(jsonString);
      List<dynamic> jsonList = jsonData['colores'];
      setState(() {
        painterList = jsonList.map((e) => PainterItem.fromJson(e)).toList();
      });
    } catch (e) {
      print('Error al cargar datos: $e');
      // Puedes mostrar un mensaje de error al usuario aquí
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Seleccione una imagen'),
      ),
      body: Container(
        padding: EdgeInsets.all(8.0),
        child: _galeria(),
      ),
    );
  }

  Widget _galeria() {
    return RefreshIndicator(
      onRefresh: obtenerNuevasImagenes,
      child: MasonryGridView.count(
        controller: _controller,
        crossAxisCount: 2,
        itemCount: min(painterList.length, 15),
        itemBuilder: (BuildContext context, int index) {
          PainterItem item = painterList[index];
          return GestureDetector(
            onTap: () {
              print('Tapped on image with index: $index');
              String imageUrl = item.image;
              print('Image URL: $imageUrl');
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PintarImagenScreen(imageUrl),
                ),
              );
            },
            child: Hero(
              tag: index, // Ajusta según tus necesidades
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: CachedNetworkImage(
                  imageUrl: item.image,
                  height: index.isEven ? 200 : 240,
                  fit: BoxFit.fill,
                  placeholder: (context, url) => Image.asset(
                    'assets/gif/loading.gif',
                    fit: BoxFit.cover,
                  ),
                  errorWidget: (context, url, error) => Image.asset(
                    'assets/img/cp.png', // Imagen local por defecto en caso de error
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          );
        },
        mainAxisSpacing: 10,
        crossAxisSpacing: 20,
      ),
    );
  }

  Future<void> obtenerNuevasImagenes() async {
    final random = Random();
    Set<int> usedIndexes = {};
    List<PainterItem> newItems = [];

    while (newItems.length < 15 && newItems.length < painterList.length) {
      int randomIndex = random.nextInt(painterList.length);
      if (!usedIndexes.contains(randomIndex)) {
        newItems.add(painterList[randomIndex]);
        usedIndexes.add(randomIndex);
      }
    }

    setState(() {
      painterList = List.from(
          newItems); // Actualizar la lista con nuevos elementos aleatorios
    });
  }
}
