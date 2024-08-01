import 'package:flutter/material.dart';
import 'package:capacidades_especiales/app/models/estudiantes/tareas/list_item_students_task_model.dart';
import 'package:capacidades_especiales/app/models/seguimientos-academicos/materias/assignature_model.dart';
import 'package:capacidades_especiales/app/models/tutor/login_model.dart';
import 'package:capacidades_especiales/app/services/seguimientos-academicos/materia/materia_service.dart';
import 'package:capacidades_especiales/app/services/estudiante/tasks/tasks_students_service.dart';
import 'package:capacidades_especiales/app/widgets/tutor/Home/messages/dialogs/login_message.dart';

class EditarTareaEstudianteScreen extends StatefulWidget {
  final TareaEstudiante tarea;
  final Sesion sesion;

  const EditarTareaEstudianteScreen(
      {Key? key, required this.tarea, required this.sesion})
      : super(key: key);

  @override
  _EditarTareaEstudianteScreenState createState() =>
      _EditarTareaEstudianteScreenState();
}

class _EditarTareaEstudianteScreenState
    extends State<EditarTareaEstudianteScreen> {
  final ServicioProgresoEstudiante servicioProgresoEstudiante =
      ServicioProgresoEstudiante();
  late TextEditingController tituloTareaController;
  late TextEditingController comentarioController;
  late TextEditingController informacionTareaController;
  final ServicioMateria servicioMateria = ServicioMateria();
  late Future<List<Materia>> materias;
  String? _selectedMateria;
  double? calificacion; // Ajustado a double según tu modelo

  @override
  void initState() {
    super.initState();
    materias = fetchMaterias();
    tituloTareaController =
        TextEditingController(text: widget.tarea.titulo_tarea ?? '');
    informacionTareaController =
        TextEditingController(text: widget.tarea.informacionTarea);
    comentarioController =
        TextEditingController(text: widget.tarea.comentarios ?? '');
    calificacion = widget
        .tarea.calificacion; // Asignado directamente a la variable calificacion
  }

  @override
  void dispose() {
    tituloTareaController.dispose();
    informacionTareaController.dispose();
    comentarioController.dispose();
    super.dispose();
  }

  Future<List<Materia>> fetchMaterias() async {
    try {
      final fetchMaterias = await servicioMateria.obtenerMateriasTutor(
          widget.sesion.usuario.toString(), widget.sesion.token);
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
        title: Text('Editar Tarea de Estudiante'),
      ),
      body: SingleChildScrollView(
        child: Padding(
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
                controller: tituloTareaController,
                decoration: InputDecoration(
                  labelText: 'Título de la Tarea',
                  prefixIcon: Icon(Icons.assignment),
                ),
                validator: requiredValidator,
                maxLines: 1,
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: informacionTareaController,
                decoration: InputDecoration(
                  labelText: 'Información de la Tarea',
                  prefixIcon: Icon(Icons.info),
                ),
                validator: requiredValidator,
                maxLines: null,
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: TextEditingController(
                    text: calificacion?.toStringAsFixed(2) ?? ''),
                decoration: InputDecoration(
                  labelText: 'Calificación',
                  prefixIcon: Icon(Icons.star),
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                onChanged: (value) {
                  setState(() {
                    calificacion = double.tryParse(value);
                  });
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: comentarioController,
                decoration: InputDecoration(
                  labelText: 'Comentario',
                  prefixIcon: Icon(Icons.comment),
                ),
                maxLines: null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  try {
                    TareaEstudiante tareaActualizada = TareaEstudiante(
                        idTarea: widget.tarea.idTarea,
                        idMateria: widget.tarea.idMateria,
                        titulo_tarea: tituloTareaController.text,
                        informacionTarea: informacionTareaController.text,
                        calificacion: calificacion,
                        comentarios: comentarioController.text,
                        cedulaEstudiante: widget.tarea.cedulaEstudiante);

                    await servicioProgresoEstudiante.actualizarTareaPorTutor(
                      tareaActualizada.idTarea ?? 0,
                      tareaActualizada,
                      widget.sesion.token,
                    );

                    Dialogs.showSnackbar(
                        context, 'Se ha actualizado la tarea correctamente');

                    Navigator.pop(context);
                  } catch (e) {
                    Dialogs.showSnackbarError(
                        context, 'Error al actualizar la tarea');
                  }
                },
                child: Text('Actualizar Tarea'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
