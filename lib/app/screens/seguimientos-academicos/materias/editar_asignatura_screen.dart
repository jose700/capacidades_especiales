import 'package:capacidades_especiales/app/models/tutor/login_model.dart';
import 'package:capacidades_especiales/app/services/seguimientos-academicos/materia/materia_service.dart';
import 'package:capacidades_especiales/app/widgets/tutor/Home/messages/dialogs/login_message.dart';
import 'package:flutter/material.dart';
import 'package:capacidades_especiales/app/models/seguimientos-academicos/materias/assignature_model.dart';

class EditarMateriasScreen extends StatefulWidget {
  late final Materia materia;
  final Sesion sesion;
  EditarMateriasScreen(this.materia, this.sesion);

  @override
  _EditarMateriasScreenState createState() => _EditarMateriasScreenState();
}

class _EditarMateriasScreenState extends State<EditarMateriasScreen> {
  late TextEditingController _nombreController;
  late TextEditingController _institucionController;
  late TextEditingController _cursoController;
  late TextEditingController _nivelController;
  late TextEditingController _paraleloController;
  late TextEditingController _jornadaController;
  late TextEditingController _descripcionController;
  late TextEditingController _creditosController;
  final ServicioMateria servicioMateria = ServicioMateria();
  @override
  void initState() {
    super.initState();
    _nombreController =
        TextEditingController(text: widget.materia.nombreMateria);
    _institucionController =
        TextEditingController(text: widget.materia.institucion);
    _cursoController = TextEditingController(text: widget.materia.curso);
    _nivelController = TextEditingController(text: widget.materia.nivel);
    _paraleloController = TextEditingController(text: widget.materia.paralelo);
    _jornadaController = TextEditingController(text: widget.materia.jornada);
    _descripcionController =
        TextEditingController(text: widget.materia.descripcion);
    _creditosController =
        TextEditingController(text: widget.materia.creditos.toString());
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _institucionController.dispose();
    _cursoController.dispose();
    _nivelController.dispose();
    _paraleloController.dispose();
    _jornadaController.dispose();
    _descripcionController.dispose();
    _creditosController.dispose();
    super.dispose();
  }

  void _showErrorSnackbar() {
    Dialogs.showSnackbarError(context,
        'Error al actualizar la asignatura,ya existe la signatura en ese mismo paralelo, elige un paralelo diferente');
  }

  void _showSuccessSnackbar() {
    Dialogs.showSnackbar(context, 'Asignatura actualizada correctamente');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar asignatura'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            TextFormField(
              controller: _nombreController,
              decoration: InputDecoration(
                  labelText: 'Nombre de la asignatura',
                  prefixIcon: Icon(Icons.assignment)),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _institucionController,
              decoration: InputDecoration(
                  labelText: 'Institución', prefixIcon: Icon(Icons.school)),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _cursoController,
              decoration: InputDecoration(
                  labelText: 'Curso', prefixIcon: Icon(Icons.book)),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _nivelController,
              decoration: InputDecoration(
                  labelText: 'Nivel', prefixIcon: Icon(Icons.grade)),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _paraleloController,
              decoration: InputDecoration(
                  labelText: 'Paralelo', prefixIcon: Icon(Icons.abc)),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _jornadaController,
              decoration: InputDecoration(
                  labelText: 'Jornada', prefixIcon: Icon(Icons.access_time)),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _descripcionController,
              decoration: InputDecoration(
                  labelText: 'Descripción',
                  prefixIcon: Icon(Icons.description)),
              maxLines: null,
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _creditosController,
              decoration: InputDecoration(
                  labelText: 'Créditos',
                  prefixIcon: Icon(Icons.monetization_on)),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                actualizarMateria();
              },
              child: Text('Guardar cambios'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> actualizarMateria() async {
    try {
      Materia updatedMateria = Materia(
        idmateria: widget.materia.idmateria,
        usuarioTutor: widget.materia.usuarioTutor,
        nombreMateria: _nombreController.text,
        institucion: _institucionController.text,
        curso: _cursoController.text,
        nivel: _nivelController.text,
        paralelo: _paraleloController.text,
        jornada: _jornadaController.text,
        descripcion: _descripcionController.text,
        creditos: int.parse(_creditosController.text),
      );

      // Actualizamos la materia en el servicio
      await servicioMateria.actualizarMateria(
        widget.materia.idmateria,
        updatedMateria,
        widget.sesion.token,
      );

      // Mostramos el mensaje de éxito después de actualizar widget.materia
      _showSuccessSnackbar();
    } catch (e) {
      // Mostramos el mensaje de error en caso de excepción
      _showErrorSnackbar();
      print('Excepción al actualizar la materia: $e');
    }
  }
}
