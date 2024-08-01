import 'dart:io';

import 'package:flutter/material.dart';

class ImageViewScreen extends StatelessWidget {
  final String imagePath;

  ImageViewScreen({required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vista previa de la imagen'),
      ),
      body: Center(
        child: Image.file(File(imagePath)),
      ),
    );
  }
}
