import 'package:capacidades_especiales/app/screens/estudiantes/game/memory/memory__screen.dart';
import 'package:flutter/material.dart';

class LevelSelectionScreen extends StatelessWidget {
  final String category;

  LevelSelectionScreen({required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Selecciona un nivel para $category'),
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: EdgeInsets.all(16.0),
        children: ['Fácil', 'Medio', 'Difícil'].map((level) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      MemoryGameScreen(category: category, level: level),
                ),
              );
            },
            child: Card(
              elevation: 5.0,
              child: Center(
                child: Text(
                  level,
                  style: TextStyle(fontSize: 20.0),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
