import 'package:capacidades_especiales/app/models/estudiantes/tareas/list_item_students_task_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class DetalleTareaEstudianteScreen extends StatefulWidget {
  final TareaEstudiante tarea;

  DetalleTareaEstudianteScreen({required this.tarea});

  @override
  _DetalleTareaEstudianteScreenState createState() =>
      _DetalleTareaEstudianteScreenState();
}

class _DetalleTareaEstudianteScreenState
    extends State<DetalleTareaEstudianteScreen> {
  String? _localFilePath;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadFile();
  }

  Future<void> _loadFile() async {
    final url = widget.tarea.archivo_url;

    // Debug print for URL
    print('URL del archivo: $url');

    if (url == null || url.isEmpty) {
      setState(() {
        _errorMessage = 'URL del archivo no proporcionada';
        _isLoading = false;
      });
      return;
    }

    try {
      final response = await http.get(Uri.parse(url));

      // Debug print for HTTP response
      print('Código de estado de la respuesta: ${response.statusCode}');
      print(
          'Respuesta del cuerpo: ${response.body.substring(0, 100)}'); // Print first 100 chars of response

      if (response.statusCode == 200) {
        final directory = await getTemporaryDirectory();
        final file =
            File('${directory.path}/${Uri.parse(url).pathSegments.last}');

        // Debug print for file path
        print('Ruta local del archivo: ${file.path}');

        await file.writeAsBytes(response.bodyBytes);

        setState(() {
          _localFilePath = file.path;
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage =
              'Error al descargar el archivo. Código de estado: ${response.statusCode}';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error al guardar el archivo: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalle de la Tarea'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : _errorMessage != null
                ? Center(child: Text(_errorMessage!))
                : _buildFilePreview(context),
      ),
    );
  }

  Widget _buildFilePreview(BuildContext context) {
    if (_localFilePath == null) {
      return Center(child: Text('No se ha proporcionado una ruta del archivo'));
    } else if (_localFilePath!.endsWith('.pdf')) {
      return PDFView(
        filePath: _localFilePath!,
        enableSwipe: true,
        swipeHorizontal: true,
        autoSpacing: false,
        pageFling: true,
        pageSnap: true,
        defaultPage: 0,
        fitPolicy: FitPolicy.BOTH,
      );
    } else if (_localFilePath!.endsWith('.jpg') ||
        _localFilePath!.endsWith('.jpeg') ||
        _localFilePath!.endsWith('.png')) {
      return Center(
        child: Image.file(File(_localFilePath!)),
      );
    } else {
      return Center(
        child: ElevatedButton(
          child: Text('Abrir archivo'),
          onPressed: () {
            _launchURL();
          },
        ),
      );
    }
  }

  void _launchURL() async {
    final url = widget.tarea.archivo_url;

    // Debug print for URL
    print('Lanzando URL: $url');

    if (url == null || url.isEmpty) {
      throw 'No se pudo abrir la URL';
    }

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'No se pudo abrir la URL $url';
    }
  }
}
