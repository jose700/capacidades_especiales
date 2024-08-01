import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:capacidades_especiales/app/models/estudiantes/playing/animals/animals_item_model.dart';
import 'package:capacidades_especiales/app/screens/estudiantes/game/animals/pages/info_page.dart';

class MyCard extends StatelessWidget {
  final Animal animal;

  MyCard({
    Key? key,
    required this.animal,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 350,
      width: 250,
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 2),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => InfoPage(animal: animal),
            ),
          );
        },
        child: Hero(
          tag: 'imagen_animal_${animal.nombre}',
          child: Card(
            color: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 8,
            child: Stack(
              fit: StackFit.expand,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: CachedNetworkImage(
                    imageUrl: animal.imagen,
                    fit: BoxFit.cover,
                    errorWidget:
                        (BuildContext context, String url, dynamic error) {
                      return Image.asset(
                        'assets/img/cp.png',
                        fit: BoxFit
                            .cover, // Usamos BoxFit.cover para que la imagen de error tenga el mismo ajuste
                      );
                    },
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Theme.of(context).brightness == Brightness.light
                        ? Colors.white.withOpacity(0.2)
                        : Colors.black.withOpacity(0.4),
                  ),
                ),
                Positioned(
                  bottom: 10,
                  left: 10,
                  child: Text(
                    animal.nombre,
                    style: TextStyle(
                      fontSize: 24,
                      letterSpacing: 1,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).brightness == Brightness.light
                          ? Colors.black
                          : Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
