import 'package:capacidades_especiales/app/screens/estudiantes/game/memory/level_memory_screen.dart';
import 'package:flutter/material.dart';

class CategorySelectionScreen extends StatefulWidget {
  @override
  State<CategorySelectionScreen> createState() =>
      _CategorySelectionScreenState();
}

class _CategorySelectionScreenState extends State<CategorySelectionScreen> {
  final List<String> categories = [
    'Frutas',
    'Animales',
    'Transporte',
    'Emojis',
    'Banderas'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Selecciona una categoría'),
      ),
      body: GridView.builder(
        padding: EdgeInsets.all(16.0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 20.0,
          crossAxisSpacing: 20.0,
          childAspectRatio: 1.5,
        ),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      LevelSelectionScreen(category: categories[index]),
                ),
              );
            },
            child: Card(
              elevation: 5.0,
              child: Center(
                child: Text(
                  categories[index],
                  style: TextStyle(fontSize: 20.0),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
