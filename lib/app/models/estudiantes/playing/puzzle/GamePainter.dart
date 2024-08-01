import 'dart:ui' as ui;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:capacidades_especiales/app/models/estudiantes/playing/puzzle/ImageNode.dart';
import 'package:capacidades_especiales/app/screens/estudiantes/game/Rompe_Cabezas/page/GamePage.dart';

class GamePainter extends CustomPainter {
  Paint? mypaint;
  Path? path;
  final int level;
  final List<ImageNode> nodes;
  final ImageNode? hitNode;
  final bool needdraw;
  final double downX, downY, newX, newY;
  final List<ImageNode> hitNodeList;
  final Direction direction;

  GamePainter({
    required this.nodes,
    required this.level,
    required this.hitNode,
    required this.hitNodeList,
    required this.direction,
    required this.downX,
    required this.downY,
    required this.newX,
    required this.newY,
    required this.needdraw,
  }) {
    mypaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..color = ui.Color.fromARGB(0, 0, 0, 0);

    path = Path();
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (nodes.isNotEmpty) {
      for (int i = 0; i < nodes.length; ++i) {
        ImageNode node = nodes[i];

        // Verificar si node.rect y node.image son null
        if (node.rect == null || node.image == null) continue;

        Rect rect2 = Rect.fromLTRB(
          node.rect!.left,
          node.rect!.top,
          node.rect!.right,
          node.rect!.bottom,
        );

        if (hitNodeList.contains(node)) {
          if (direction == Direction.left || direction == Direction.right) {
            rect2 = node.rect!.shift(Offset(newX - downX, 0.0));
          } else if (direction == Direction.top ||
              direction == Direction.bottom) {
            rect2 = node.rect!.shift(Offset(0.0, newY - downY));
          }
        }

        Rect srcRect = Rect.fromLTRB(
          0.0,
          0.0,
          node.image!.width.toDouble(),
          node.image!.height.toDouble(),
        );

        canvas.drawImageRect(node.image!, srcRect, rect2, Paint());

        if (hitNode != null && node == hitNode) {
          ParagraphBuilder pb = ParagraphBuilder(ParagraphStyle(
            textAlign: TextAlign.center,
            fontWeight: FontWeight.w300,
            fontStyle: FontStyle.normal,
            fontSize: 20.0,
          ));

          pb.pushStyle(ui.TextStyle(color: Color(0xff00ff00)));
          pb.addText('${node.index ?? 0 + 1}');
          ParagraphConstraints pc =
              ParagraphConstraints(width: node.rect!.width);
          Paragraph paragraph = pb.build()..layout(pc);

          Offset offset = Offset(
            node.rect!.left,
            node.rect!.top + node.rect!.height / 2 - paragraph.height / 2,
          );

          if (hitNodeList.contains(node)) {
            if (direction == Direction.left || direction == Direction.right) {
              offset = Offset(offset.dx + newX - downX, offset.dy);
            } else if (direction == Direction.top ||
                direction == Direction.bottom) {
              offset = Offset(offset.dx, offset.dy + newY - downY);
            }
          }

          canvas.drawParagraph(paragraph, offset);
        }
      }
    }
  }

  @override
  bool shouldRepaint(GamePainter oldDelegate) {
    return needdraw || oldDelegate.needdraw;
  }
}
