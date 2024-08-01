import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LearningAnimation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Lottie.asset(
      'assets/lotties/learning.json', // Ruta al archivo JSON de tu animación Lottie
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
    );
  }
}
