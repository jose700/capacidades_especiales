import 'package:cached_network_image/cached_network_image.dart';
import 'package:capacidades_especiales/app/models/estudiantes/playing/animals/animals_item_model.dart';
import 'package:capacidades_especiales/app/utils/resources/app_colors.dart';
import 'package:capacidades_especiales/app/screens/estudiantes/game/animals/pages/info_page.dart';

import 'package:flutter/material.dart';

class Animogi extends StatelessWidget {
  final Animal animal;

  const Animogi({
    Key? key,
    required this.animal,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => InfoPage(animal: animal),
            ),
          );
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: CachedNetworkImage(
            imageUrl: animal.imagen,
            fit: BoxFit.fill,
            placeholder: (context, url) => Container(
              height: 65,
              width: 65,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(width: 2, color: AppColors.midnightGreen),
                image: DecorationImage(
                  image: AssetImage(
                      'assets/img/cp.png'), // Imagen por defecto mientras se carga
                  fit: BoxFit.fill,
                ),
              ),
            ),
            errorWidget: (context, url, error) => Container(
              height: 65,
              width: 65,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(width: 2, color: AppColors.midnightGreen),
                image: DecorationImage(
                  image: AssetImage(
                      'assets/img/default.png'), // Imagen por defecto en caso de error
                  fit: BoxFit.fill,
                ),
              ),
            ),
            imageBuilder: (context, imageProvider) => Container(
              height: 65,
              width: 65,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(width: 2, color: AppColors.midnightGreen),
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
        ));
  }
}
