import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;
import 'dart:ui';
import 'package:capacidades_especiales/app/models/estudiantes/playing/puzzle/ImageNode.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class PuzzleMagic {
  ui.Image? image;
  double? eachWidth;
  Size? screenSize;
  double? baseX;
  double? baseY;
  int? level;
  double? eachBitmapWidth;

  Future<ui.Image> init(String path, Size size, int level) async {
    print('Initializing puzzle with path: $path');
    await getImage(path);

    screenSize = size;
    this.level = level;
    eachWidth = screenSize!.width * 0.8 / level;
    baseX = screenSize!.width * 0.1;
    baseY = (screenSize!.height - screenSize!.width) * 0.5;

    eachBitmapWidth = (image!.width / level);
    print('Puzzle initialized successfully');
    return image!;
  }

  Future<void> getImage(String path) async {
    Completer<void> completer = Completer();

    try {
      if (path.startsWith('http') || path.startsWith('https')) {
        // Si la ruta es una URL
        final Uri resolved = Uri.parse(path);
        final HttpClientRequest request = await HttpClient().getUrl(resolved);
        final HttpClientResponse response = await request.close();
        final Uint8List bytes =
            await consolidateHttpClientResponseBytes(response);
        final ui.Codec codec = await ui.instantiateImageCodec(bytes);
        final ui.Image image = (await codec.getNextFrame()).image;
        this.image = image;
      } else {
        // Si la ruta es un archivo local
        File file = File(path);
        Uint8List bytes = await file.readAsBytes();
        final ui.Codec codec = await ui.instantiateImageCodec(bytes);
        final ui.Image image = (await codec.getNextFrame()).image;
        this.image = image;
      }
      completer.complete();
    } catch (e) {
      print('Error al cargar la imagen: $e');
      completer.completeError(e);
    }

    return completer.future;
  }

  List<ImageNode> doTask() {
    print('Generating puzzle pieces');
    List<ImageNode> list = [];
    for (int j = 0; j < level!; j++) {
      for (int i = 0; i < level!; i++) {
        if (j * level! + i < level! * level! - 1) {
          ImageNode node = ImageNode();
          node.rect = getOkRectF(i, j);
          node.index = j * level! + i;
          makeBitmap(node);
          list.add(node);
        }
      }
    }
    print('Puzzle pieces generated successfully');
    return list;
  }

  Rect getOkRectF(int i, int j) {
    return Rect.fromLTWH(baseX! + eachWidth! * i, baseY! + eachWidth! * j,
        eachWidth!, eachWidth!);
  }

  void makeBitmap(ImageNode node) async {
    int i = node.getXIndex(level ?? 0);
    int j = node.getYIndex(level ?? 0);

    Rect rect = getShapeRect(i, j, eachBitmapWidth!);
    rect = rect.shift(Offset(
        eachBitmapWidth!.toDouble() * i, eachBitmapWidth!.toDouble() * j));

    PictureRecorder recorder = PictureRecorder();
    double ww = eachBitmapWidth!.toDouble();
    Canvas canvas = Canvas(recorder, Rect.fromLTWH(0.0, 0.0, ww, ww));

    Rect rect2 = Rect.fromLTRB(0.0, 0.0, rect.width, rect.height);

    Paint paint = Paint();
    canvas.drawImageRect(image!, rect, rect2, paint);
    node.image = await recorder.endRecording().toImage(ww.floor(), ww.floor());
    node.rect = getOkRectF(i, j);
  }

  Rect getShapeRect(int i, int j, double width) {
    return Rect.fromLTRB(0.0, 0.0, width, width);
  }
}
