import 'package:flutter/material.dart';
import 'package:capacidades_especiales/app/models/estudiantes/tareas/add_tasks_model.dart';
import 'package:capacidades_especiales/app/models/tutor/login_model.dart';
import 'package:capacidades_especiales/app/models/seguimientos-academicos/materias/assignature_model.dart';
import 'package:capacidades_especiales/app/services/seguimientos-academicos/materia/materia_service.dart';
import 'package:capacidades_especiales/app/services/estudiante/tasks/tasks_students_service.dart';
import 'package:capacidades_especiales/app/widgets/tutor/Home/messages/dialogs/login_message.dart';

class AddTaskScreen extends StatefulWidget {
  final String usuario;
  final Sesion sesion;

  AddTaskScreen({Key? key, required this.usuario, required this.sesion})
      : super(key: key);

  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final ServicioProgresoEstudiante servicioProgresoEstudiante =
      ServicioProgresoEstudiante();
  final TextEditingController idInscripcionController = TextEditingController();
  final TextEditingController TituloTareaController = TextEditingController();
  final TextEditingController informacionTareaController =
      TextEditingController();

  final ServicioMateria servicioMateria = ServicioMateria();
  late Future<List<Materia>> materias;
  String? _selectedMateria;
  bool tareaCumplida = false;

  @override
  void initState() {
    super.initState();
    materias = fetchMaterias();
  }

  Future<List<Materia>> fetchMaterias() async {
    try {
      final fetchMaterias = await servicioMateria.obtenerMateriasTutor(
          widget.usuario, widget.sesion.token);
      return fetchMaterias;
    } catch (e) {
      return [];
    }
  }

  String? requiredValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Este campo es obligatorio';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crear tareas'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FutureBuilder<List<Materia>>(
              future: materias,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Text('No hay materias disponibles');
                } else {
                  final materiasList = snapshot.data!;
                  return DropdownButtonFormField<String>(
                    value: _selectedMateria,
                    decoration: InputDecoration(
                      labelText: 'Seleccione materia',
                      prefixIcon: Icon(Icons.subject),
                    ),
                    items: materiasList.map((materia) {
                      return DropdownMenuItem<String>(
                        value: materia.idmateria.toString(),
                        child: Text(materia.nombreMateria),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedMateria = value;
                      });
                    },
                    validator: requiredValidator,
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                    dropdownColor: Theme.of(context).scaffoldBackgroundColor,
                  );
                }
              },
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: TituloTareaController,
              decoration: InputDecoration(
                  labelText: 'Título de la Tarea',
                  prefixIcon: Icon(Icons.assignment)),
              validator: requiredValidator,
              maxLines: 1,
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: informacionTareaController,
              decoration: InputDecoration(
                  labelText: 'Información de la Tarea',
                  prefixIcon: Icon(Icons.info)),
              validator: requiredValidator,
              maxLines: null,
            ),
            SizedBox(height: 20),
            Container(
              alignment: Alignment.center,
              child: ElevatedButton(
                onPressed: () async {
                  if (_selectedMateria == null ||
                      TituloTareaController.text.isEmpty ||
                      informacionTareaController.text.isEmpty) {
                    Dialogs.showSnackbarError(
                        context, 'Todos los campos son obligatorios');
                    return;
                  }

                  try {
                    final progreso = TasksStudents(
                      idmateria: int.parse(_selectedMateria!),
                      usuarioTutor: widget.usuario,
                      tituloTarea: TituloTareaController.text,
                      informacionTarea: informacionTareaController.text,
                      tareaCumplida: false,
                    );

                    await servicioProgresoEstudiante.crearProgresoEstudiante(
                        progreso, widget.sesion.token);

                    Dialogs.showSnackbar(
                        context, 'Se han creado las tareas correctamente');
                  } catch (e) {
                    Dialogs.showSnackbarError(
                        context, 'Error al crear las tareas');
                  }
                },
                child: Text('Crear tareas'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
