import 'package:capacidades_especiales/app/models/seguimientos-academicos/materias/assignature_model.dart';
import 'package:capacidades_especiales/app/models/tutor/login_model.dart';
import 'package:capacidades_especiales/app/utils/resources/app_colors.dart';
import 'package:capacidades_especiales/app/screens/seguimientos-academicos/materias/editar_asignatura_screen.dart';
import 'package:capacidades_especiales/app/services/seguimientos-academicos/materia/materia_service.dart';
import 'package:capacidades_especiales/app/widgets/search/no_results_widgets.dart';
import 'package:capacidades_especiales/app/widgets/tutor/Home/messages/dialogs/login_message.dart';
import 'package:flutter/material.dart';

class MateriaList extends StatefulWidget {
  final Sesion sesion;
  final List<Materia> filteredMaterias;
  final List<Materia> materias;
  final Future<List<Materia>> Function() fetchMaterias;
  final BuildContext context;
  final ServicioMateria servicioMateria;

  MateriaList({
    required this.filteredMaterias,
    required this.materias,
    required this.fetchMaterias,
    required this.context,
    required this.servicioMateria,
    required this.sesion,
  });

  @override
  _MateriaListState createState() => _MateriaListState();
}

class _MateriaListState extends State<MateriaList> {
  late Future<List<Materia>> futureMaterias;

  @override
  void initState() {
    super.initState();
    futureMaterias = widget.fetchMaterias();
  }

  @override
  Widget build(BuildContext context) {
    return _buildMateriasList();
  }

  Widget _buildMateriasList() {
    return FutureBuilder<List<Materia>>(
      future: futureMaterias,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData) {
          if (widget.filteredMaterias.isEmpty) {
            return NoResultsWidget();
          }
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: const [
                DataColumn(label: Text('Asignatura')),
                DataColumn(label: Text('Institución')),
                DataColumn(label: Text('Nivel')),
                DataColumn(label: Text('Curso')),
                DataColumn(label: Text('Paralelo')),
                DataColumn(label: Text('Jornada')),
                DataColumn(label: Text('Créditos')),
                DataColumn(label: Text('Descripción del curso')),
                DataColumn(label: Text('Acciones')),
              ],
              rows: widget.filteredMaterias
                  .map((materia) => DataRow(cells: [
                        DataCell(Text(materia.nombreMateria)),
                        DataCell(Text(materia.institucion)),
                        DataCell(Text(materia.nivel)),
                        DataCell(Text(materia.curso)),
                        DataCell(Text(materia.paralelo)),
                        DataCell(Text(materia.jornada)),
                        DataCell(Text(materia.creditos.toString())),
                        DataCell(Text(materia.descripcion)),
                        DataCell(Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit,
                                  color: AppColors.contentColorBlue),
                              onPressed: () async {
                                final cambiosRealizados =
                                    await Navigator.push<bool>(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EditarMateriasScreen(
                                        materia, widget.sesion),
                                  ),
                                );
                                if (cambiosRealizados == true) {
                                  // Si se realizaron cambios, actualiza la lista.
                                  await widget.fetchMaterias();
                                }
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete,
                                  color: AppColors.contentColorRed),
                              onPressed: () {
                                _showDeleteConfirmationDialog(materia);
                              },
                            ),
                          ],
                        )),
                      ]))
                  .toList(),
            ),
          );
        } else {
          return NoTDataWidget();
        }
      },
    );
  }

  void _showDeleteConfirmationDialog(Materia materia) {
    showAdaptiveDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Eliminar'),
          content: const Text('¿Estás seguro de eliminar esta asignatura?'),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.contentColorRed,
              ),
              onPressed: () async {
                try {
                  await widget.servicioMateria.eliminarMateria(
                      materia.idmateria.toString(), widget.sesion.token);
                  Dialogs.showSnackbar(
                      context, 'Se ha eliminado la asignatura correctamente');
                  Navigator.pop(context);

                  setState(() {
                    widget.materias.remove(materia);
                    widget.filteredMaterias.remove(materia);
                  });
                } catch (e) {
                  Dialogs.showSnackbarError(
                      context, 'Error al eliminar la asigantura');
                  Navigator.pop(context);
                }
              },
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );
  }
}
