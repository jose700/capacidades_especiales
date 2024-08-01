import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:capacidades_especiales/app/models/estudiantes/playing/animals/animals_item_model.dart';
import 'package:flutter_flip_card/flipcard/gesture_flip_card.dart';
import 'package:flutter_flip_card/modal/flip_side.dart';

class InfoPage extends StatelessWidget {
  final Animal animal;

  InfoPage({Key? key, required this.animal}) : super(key: key);

  final List<Color> iconColors = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.orange,
    Colors.purple,
    Colors.teal,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(animal.nombre),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image section with FlipCard and Hero animation
            Hero(
              tag: 'imagen_animal_${animal.nombre}',
              child: GestureFlipCard(
                animationDuration: const Duration(milliseconds: 300),
                axis: FlipAxis.horizontal,
                frontWidget: _buildImageWidget(animal.imagen),
                backWidget: _buildImageWidget(animal
                    .imagen), // Cambia la imagen o contenido de la parte trasera si es necesario
              ),
            ),
            // Information section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle(animal.nombre),
                  const SizedBox(height: 16),
                  _buildInfoRow(
                    Icons.pets,
                    'Especie:',
                    animal.especie,
                    iconColors[0],
                  ),
                  const SizedBox(height: 8),
                  _buildInfoRow(
                    Icons.terrain,
                    'Hábitat:',
                    animal.habitat,
                    iconColors[1],
                  ),
                  const SizedBox(height: 8),
                  _buildInfoRow(
                    Icons.restaurant,
                    'Alimentación:',
                    animal.alimentacion,
                    iconColors[2],
                  ),
                  const SizedBox(height: 16),
                  _buildSectionTitle('Información Adicional'),
                  const SizedBox(height: 8),
                  _buildInfoRow(
                    Icons.timeline,
                    'Promedio de vida:',
                    animal.informacionAdicional.promedioVida,
                    iconColors[3],
                  ),
                  const SizedBox(height: 8),
                  _buildInfoRow(
                    Icons.eco,
                    'Estado de conservación:',
                    animal.informacionAdicional.estadoConservacion,
                    iconColors[4],
                  ),
                  const SizedBox(height: 8),
                  _buildInfoRow(
                    Icons.map,
                    'Localización:',
                    animal.informacionAdicional.distribucion,
                    iconColors[5],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageWidget(String imageUrl) {
    return Container(
      height: 300,
      width: double.infinity,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        clipBehavior: Clip.antiAlias,
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          fit: BoxFit.fill,
          placeholder: (context, url) => Center(
            child:
                CircularProgressIndicator(), // Indicador de carga mientras se obtiene la imagen
          ),
          errorWidget: (context, url, error) => Image.asset(
            'assets/img/cp.png', // Imagen por defecto en caso de error
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String info, Color color) {
    return Row(
      children: [
        Icon(icon, color: color),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            '$label $info',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
