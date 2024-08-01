import 'package:capacidades_especiales/app/screens/estudiantes/game/my_tasks/tasks_students/pdf_preview_stask_studen_screen.dart';
import 'package:capacidades_especiales/app/screens/estudiantes/game/my_tasks/tasks_students/previed_image_task_student_screen.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:open_file/open_file.dart';

import 'package:capacidades_especiales/app/models/estudiantes/tareas/data_task_model.dart';
import 'package:capacidades_especiales/app/widgets/tutor/Home/messages/dialogs/login_message.dart';
import 'package:capacidades_especiales/app/models/tutor/login_model.dart';
import 'package:capacidades_especiales/app/models/seguimientos-academicos/inscripcion/inscription_assignatura_model.dart';
import 'package:capacidades_especiales/app/services/estudiante/tasks/tasks_students_service.dart';

class SubirTareaScreen extends StatefulWidget {
  final Sesion sesion;
  final InscripcionMateria materia;
  final DatosTareasEstudiantes tareas;

  SubirTareaScreen({
    Key? key,
    required this.sesion,
    required this.materia,
    required this.tareas,
  }) : super(key: key);

  @override
  _SubirTareaScreenState createState() => _SubirTareaScreenState();
}

class _SubirTareaScreenState extends State<SubirTareaScreen> {
  final _formKey = GlobalKey<FormState>();
  final _servicio = ServicioProgresoEstudiante();

  String _archivoNombre = '';
  String? _archivoPath;
  bool _subiendo = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Subir Tarea'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Container(
            alignment: Alignment.center,
            child: Column(
              children: <Widget>[
                if (_archivoPath != null) _buildFilePreview(context),
                SizedBox(height: 20),
                ElevatedButton(
                  child: Text('Seleccionar archivo'),
                  onPressed: _pickFile,
                ),
                SizedBox(height: 20),
                if (_subiendo) CircularProgressIndicator(),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _subiendo ? null : _submitForm,
                  child: Text('Subir Tarea'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFilePreview(BuildContext context) {
    return GestureDetector(
      onTap: () => _openFile(context),
      child: Card(
        child: ListTile(
          leading: Icon(Icons.insert_drive_file),
          title: Text(_archivoNombre),
        ),
      ),
    );
  }

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      var file = result.files.single;
      setState(() {
        _archivoNombre = file.name;
        _archivoPath = file.path;
      });
    } else {
      print('El usuario canceló la selección de archivos');
    }
  }

  void _openFile(BuildContext context) {
    if (_archivoPath != null) {
      if (_archivoPath!.endsWith('.pdf')) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PDFViewScreen(filePath: _archivoPath!),
          ),
        );
      } else if (_archivoPath!.endsWith('.jpg') ||
          _archivoPath!.endsWith('.jpeg') ||
          _archivoPath!.endsWith('.png')) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ImageViewScreen(imagePath: _archivoPath!),
          ),
        );
      } else {
        OpenFile.open(_archivoPath);
      }
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      if (_archivoNombre.isEmpty || _archivoPath == null) {
        Dialogs.showSnackbar(context, 'Por favor, selecciona un archivo');
        return;
      }

      setState(() {
        _subiendo = true;
      });

      Map<String, dynamic> progreso = {
        'idtarea': widget.tareas.idTarea,
        'fecha_envio_tarea': DateTime.now().toIso8601String(),
        'archivo_nombre': _archivoNombre,
        'archivo_mimetype': _archivoNombre, // Tipo MIME como nombre del archivo
        'tarea_cumplida': true,
      };

      _servicio
          .actualizarProgresoEstudiante(
        widget.sesion.cedula.toString(),
        widget.tareas.idTarea.toString(),
        progreso,
        widget.sesion.token, // Incluye el token de autenticación
      )
          .then((_) {
        setState(() {
          _archivoNombre = '';
          _archivoPath = null;
          _subiendo = false;
        });

        Dialogs.showSnackbar(context, 'Su tarea se envió correctamente');
        Navigator.pop(context);
      }).catchError((error) {
        print('Error al subir la tarea: $error');
        setState(() {
          _subiendo = false;
        });
        Dialogs.showSnackbar(
            context, 'Error al subir la tarea. Inténtalo nuevamente.');
      });
    }
  }
}
