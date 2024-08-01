import 'dart:async';
import 'dart:ui' as ui;
import 'package:capacidades_especiales/app/models/estudiantes/playing/painter/painter_figure_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:cached_network_image/cached_network_image.dart';

class PintarImagenScreen extends StatefulWidget {
  final String imageUrl;

  PintarImagenScreen(this.imageUrl);

  @override
  _PintarImagenScreenState createState() => _PintarImagenScreenState();
}

class _PintarImagenScreenState extends State<PintarImagenScreen> {
  List<List<Paint>> paintList = [];
  List<List<Offset>> pointsList = [];
  List<List<Offset>> undonePointsList = [];
  ui.Image? _image;
  Color _selectedColor = Colors.blue; // Color de pincel por defecto
  GlobalKey _key = GlobalKey();

  List<Offset> currentPoints = [];

  @override
  void initState() {
    super.initState();
    _loadImage(widget.imageUrl);
  }

  void _loadImage(String imageUrl) async {
    final Completer<ui.Image> completer = Completer();
    final ImageStream stream =
        CachedNetworkImageProvider(imageUrl).resolve(ImageConfiguration.empty);
    stream.addListener(
      ImageStreamListener((ImageInfo info, bool synchronousCall) {
        completer.complete(info.image);
      }),
    );

    final ui.Image image = await completer.future;
    setState(() {
      _image = image;
    });
  }

  Future<void> _saveImage() async {
    try {
      // Captura solo la capa de pintura sobre la imagen de fondo
      ui.Image image = await _capturePaintLayer();
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();

      final result =
          await ImageGallerySaver.saveImage(Uint8List.fromList(pngBytes));
      print(result);
      // Puedes mostrar un mensaje de éxito aquí
    } catch (e) {
      print(e);
    }
  }

  Future<ui.Image> _capturePaintLayer() async {
    RenderRepaintBoundary boundary =
        _key.currentContext!.findRenderObject() as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage(pixelRatio: 3.0);
    return image;
  }

  void _undoPaint() {
    if (pointsList.isNotEmpty) {
      setState(() {
        undonePointsList.add(pointsList.removeLast());
      });
    }
  }

  void _redoPaint() {
    if (undonePointsList.isNotEmpty) {
      setState(() {
        pointsList.add(undonePointsList.removeLast());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.cleaning_services_sharp),
            onPressed: () {
              setState(() {
                pointsList.clear();
                undonePointsList.clear(); // Limpiar historial deshecho
                paintList.clear();
              });
            },
          ),
          IconButton(
            icon: Icon(
              Icons.undo,
            ),
            onPressed: _undoPaint,
          ),
          IconButton(
            icon: Icon(
              Icons.redo,
            ),
            onPressed: _redoPaint,
          ),
          IconButton(
            icon: Icon(
              Icons.brush,
              color: _selectedColor,
            ),
            onPressed: () {
              // Implementa la selección de color del pincel
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Selecciona un color'),
                  content: SingleChildScrollView(
                    child: BlockPicker(
                      pickerColor: _selectedColor,
                      onColorChanged: (color) {
                        setState(() {
                          _selectedColor = color;
                        });
                      },
                    ),
                  ),
                  actions: <Widget>[
                    ElevatedButton(
                      child: Text('Aceptar'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveImage,
          ),
        ],
      ),
      body: Center(
        child: _image != null
            ? GestureDetector(
                onPanStart: (details) {
                  RenderBox renderBox =
                      _key.currentContext!.findRenderObject() as RenderBox;
                  currentPoints = [];
                  currentPoints
                      .add(renderBox.globalToLocal(details.globalPosition));
                  pointsList.add(currentPoints);
                  paintList.add([
                    Paint()
                      ..color = _selectedColor
                      ..strokeCap = StrokeCap.round
                      ..strokeWidth = 8.0,
                  ]);
                  undonePointsList
                      .clear(); // Limpiar historial deshecho al dibujar nueva línea
                },
                onPanUpdate: (details) {
                  RenderBox renderBox =
                      _key.currentContext!.findRenderObject() as RenderBox;
                  setState(() {
                    currentPoints
                        .add(renderBox.globalToLocal(details.globalPosition));
                  });
                },
                onPanEnd: (details) {
                  setState(() {
                    // ignore: null_check_always_fails
                    currentPoints.add(null!); // Marca el final de la línea
                  });
                },
                child: RepaintBoundary(
                  key: _key,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: Center(
                      child: Container(
                        child: CustomPaint(
                          painter: MyPainter(
                              _image!, pointsList, _selectedColor, paintList),
                          size: Size(
                            MediaQuery.of(context).size.width,
                            MediaQuery.of(context).size.height,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            : CircularProgressIndicator(),
      ),
    );
  }
}
