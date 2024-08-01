import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class FruitsAnimation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Lottie.asset(
      'assets/lotties/fruits.json', // Ruta al archivo JSON de tu animación Lottie
      fit: BoxFit.fill,
      width: double.infinity,
      height: double.infinity,
    );
  }
}
