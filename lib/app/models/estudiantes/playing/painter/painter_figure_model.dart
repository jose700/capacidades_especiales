import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class MyPainter extends CustomPainter {
  final ui.Image image;
  final List<List<Offset>> pointsList;
  final List<List<Paint>> paintList;
  final Color color;

  MyPainter(this.image, this.pointsList, this.color, this.paintList);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 8.0;

    // Dibujar la imagen de fondo con el tamaño de la pantalla
    canvas.drawImageRect(
      image,
      Rect.fromPoints(
          Offset.zero, Offset(image.width.toDouble(), image.height.toDouble())),
      Rect.fromPoints(Offset.zero, Offset(size.width, size.height)),
      paint,
    );

    // Dibujar líneas pintadas por el usuario
    // Dibujar líneas pintadas por el usuario
    for (int i = 0; i < pointsList.length; i++) {
      for (int j = 0; j < pointsList[i].length - 1; j++) {
        // ignore: unnecessary_null_comparison
        if (pointsList[i][j] != null && pointsList[i][j + 1] != null) {
          canvas.drawLine(
            pointsList[i][j],
            pointsList[i][j + 1],
            paintList[i][0], // Usamos el paint correspondiente al trazo
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
