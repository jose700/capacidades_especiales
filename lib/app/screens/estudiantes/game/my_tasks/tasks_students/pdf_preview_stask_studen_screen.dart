import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class PDFViewScreen extends StatelessWidget {
  final String filePath;

  PDFViewScreen({required this.filePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vista previa del PDF'),
      ),
      body: PDFView(
        filePath: filePath,
      ),
    );
  }
}
