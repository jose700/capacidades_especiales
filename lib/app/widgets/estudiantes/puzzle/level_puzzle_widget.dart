import 'package:capacidades_especiales/app/utils/resources/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:capacidades_especiales/app/screens/estudiantes/game/Rompe_Cabezas/page/GamePage.dart';

class LevelSelectionPage extends StatelessWidget {
  final Size size;
  final String imgPath;

  LevelSelectionPage(this.size, this.imgPath);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Seleccionar Nivel'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: 5, // Número de niveles disponibles
          itemBuilder: (context, index) {
            int displayLevel = index + 1; // Mostrar como Nivel 1, Nivel 2, etc.
            int actualLevel = index + 2; // El nivel real a pasar a GamePage

            return Card(
              elevation: 4,
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              child: ListTile(
                contentPadding: const EdgeInsets.all(16.0),
                leading: Icon(
                  Icons.star,
                  color: AppColors.contentColorYellow,
                  size: 40,
                ),
                title: Text(
                  'Nivel $displayLevel', // Muestra Nivel 1, Nivel 2, etc.
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  'Descubre nuevos desafíos en este nivel.',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
                trailing: Icon(
                  Icons.arrow_forward,
                  color: Colors.teal,
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GamePage(
                          size, imgPath, actualLevel), // Pasa el nivel real
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
