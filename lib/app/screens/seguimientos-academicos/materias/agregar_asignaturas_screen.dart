import 'package:capacidades_especiales/app/models/tutor/login_model.dart';
import 'package:flutter/material.dart';
import 'package:capacidades_especiales/app/models/seguimientos-academicos/materias/assignature_model.dart';
import 'package:capacidades_especiales/app/services/seguimientos-academicos/materia/materia_service.dart';
import 'package:capacidades_especiales/app/widgets/tutor/Home/messages/dialogs/login_message.dart';

class AgregarMateriasScreen extends StatefulWidget {
  final String usuario;
  final int idmateria;
  final Sesion sesion;

  const AgregarMateriasScreen({
    Key? key,
    required this.usuario,
    required this.idmateria,
    required this.sesion,
  }) : super(key: key);

  @override
  _AgregarMateriasScreenState createState() => _AgregarMateriasScreenState();
}

class _AgregarMateriasScreenState extends State<AgregarMateriasScreen> {
  final ServicioMateria _servicioMateria = ServicioMateria();
  final _formKey = GlobalKey<FormState>();

  late String _nombreMateria;
  late String _institucion;
  late String _curso;
  late String _nivel;
  late String _paralelo;
  late String _jornada;
  late String _descripcion;
  late int _creditos;

  String? requiredValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Este campo es obligatorio';
    }
    return null;
  }

  void _showErrorSnackbar() {
    Dialogs.showSnackbarError(context,
        'Error al registrar la asignatura, ya existe la signatura en ese mismo paralelo, elige un paralelo diferente');
  }

  void _showSuccessSnackbar() {
    Dialogs.showSnackbar(context, 'Se ha creado la asignatura correctamente');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agregar asignaturas'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Nombre de la asignatura',
                  hintText: 'Ingrese el nombre de la asignatura',
                  prefixIcon: Icon(Icons.assignment),
                ),
                validator: requiredValidator,
                onSaved: (value) {
                  _nombreMateria = value!;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Institución',
                  hintText: 'Ingrese la institución',
                  prefixIcon: Icon(Icons.school),
                ),
                validator: requiredValidator,
                onSaved: (value) {
                  _institucion = value!;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Curso',
                  hintText: 'Ingrese el curso',
                  prefixIcon: Icon(Icons.book),
                ),
                validator: requiredValidator,
                onSaved: (value) {
                  _curso = value!;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Nivel',
                  hintText: 'Ingrese el nivel',
                  prefixIcon: Icon(Icons.grade),
                ),
                validator: requiredValidator,
                onSaved: (value) {
                  _nivel = value!;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Paralelo',
                  hintText: 'Ingrese el paralelo',
                  prefixIcon: Icon(Icons.abc),
                ),
                validator: requiredValidator,
                onSaved: (value) {
                  _paralelo = value!;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Jornada',
                  hintText: 'Ingrese la jornada',
                  prefixIcon: Icon(Icons.access_time),
                ),
                validator: requiredValidator,
                onSaved: (value) {
                  _jornada = value!;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Descripción',
                  hintText: 'Ingrese la descripción',
                  prefixIcon: Icon(Icons.description),
                ),
                maxLines: null,
                validator: requiredValidator,
                onSaved: (value) {
                  _descripcion = value!;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Créditos',
                  hintText: 'Ingrese los créditos',
                  prefixIcon: Icon(Icons.monetization_on),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Este campo es obligatorio';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Por favor ingrese un número válido';
                  }
                  return null;
                },
                onSaved: (value) {
                  _creditos = int.parse(value!);
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();

                    Materia nuevaMateria = Materia(
                      idmateria: widget.idmateria,
                      usuarioTutor: widget.usuario,
                      nombreMateria: _nombreMateria,
                      institucion: _institucion,
                      curso: _curso,
                      nivel: _nivel,
                      paralelo: _paralelo,
                      jornada: _jornada,
                      descripcion: _descripcion,
                      creditos: _creditos,
                    );

                    _servicioMateria
                        .crearMateria(nuevaMateria, widget.sesion.token)
                        .then((_) {
                      _showSuccessSnackbar();
                    }).catchError((error) {
                      _showErrorSnackbar();
                    });
                  }
                },
                child: Text('Guardar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
