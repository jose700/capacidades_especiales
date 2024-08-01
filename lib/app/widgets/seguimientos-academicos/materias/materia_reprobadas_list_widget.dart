import 'package:capacidades_especiales/app/models/seguimientos-academicos/materias/approved_assignatura_model.dart';
import 'package:capacidades_especiales/app/models/tutor/login_model.dart';
import 'package:capacidades_especiales/app/utils/resources/app_colors.dart';
import 'package:capacidades_especiales/app/services/seguimientos-academicos/materia/materia_reprobada_service.dart';
import 'package:capacidades_especiales/app/widgets/search/no_results_widgets.dart';

import 'package:capacidades_especiales/app/widgets/tutor/Home/messages/dialogs/login_message.dart';
import 'package:flutter/material.dart';

class MateriaReprobadasList extends StatefulWidget {
  final Sesion sesion;
  final List<MateriaAprobada> filteredMateriasReprobadas;
  final List<MateriaAprobada> reprobadas;
  final Future<List<MateriaAprobada>> Function() fetchMateriasReprobadas;
  final BuildContext context;
  final MateriaReprobadaService servicioMateriaReprobada;

  MateriaReprobadasList({
    required this.filteredMateriasReprobadas,
    required this.reprobadas,
    required this.fetchMateriasReprobadas,
    required this.context,
    required this.servicioMateriaReprobada,
    required this.sesion,
  });

  @override
  _MateriaListState createState() => _MateriaListState();
}

class _MateriaListState extends State<MateriaReprobadasList> {
  late Future<List<MateriaAprobada>> futureMateriasAprobadas;

  @override
  void initState() {
    super.initState();
    futureMateriasAprobadas = widget.fetchMateriasReprobadas();
  }

  @override
  Widget build(BuildContext context) {
    return _buildMateriasAprobadasList();
  }

  Widget _buildMateriasAprobadasList() {
    return FutureBuilder<List<MateriaAprobada>>(
      future: futureMateriasAprobadas,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData) {
          if (widget.filteredMateriasReprobadas.isEmpty) {
            return NoResultsWidget();
          }
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: const [
                DataColumn(label: Text('Asignatura')),
                DataColumn(label: Text('Nombres')),
                DataColumn(label: Text('Apellidos')),
                DataColumn(label: Text('Cédula')),
                DataColumn(label: Text('Observación')),
                DataColumn(label: Text('Primer parcial')),
                DataColumn(label: Text('Segundo parcial')),
                DataColumn(label: Text('Promedio final')),
                DataColumn(label: Text('Reprobado')),
                DataColumn(label: Text('Acciones')),
              ],
              rows: widget.filteredMateriasReprobadas
                  .map((aprobado) => DataRow(cells: [
                        DataCell(Text(aprobado.nombreMateria ?? '')),
                        DataCell(Text(aprobado.nombres ?? '')),
                        DataCell(Text(aprobado.apellidos ?? '')),
                        DataCell(Text(aprobado.cedula ?? '')),
                        DataCell(Text(aprobado.observacion)),
                        DataCell(Text(aprobado.calificacion1.toString())),
                        DataCell(Text(aprobado.calificacion2.toString())),
                        DataCell(Text(aprobado.promedioFinal.toString())),
                        DataCell(
                          Row(
                            children: [
                              Icon(
                                Icons.cancel,
                                color: AppColors.contentColorRed,
                              ),
                            ],
                          ),
                        ),
                        DataCell(Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.delete,
                                  color: AppColors.contentColorRed),
                              onPressed: () {
                                _showDeleteConfirmationDialog(aprobado);
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

  void _showDeleteConfirmationDialog(MateriaAprobada aprobado) {
    showAdaptiveDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Eliminar'),
          content: const Text(
              '¿Estás seguro de eliminar al estudiante que aprobó la asignatura?'),
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
                  await widget.servicioMateriaReprobada
                      .eliminarMateriaReprobada(
                          aprobado.idreprobada.toString(), widget.sesion.token);
                  Dialogs.showSnackbar(context,
                      'Se ha eliminado la asignatura reaprobada correctamente');
                  Navigator.pop(context);

                  setState(() {
                    widget.reprobadas.remove(aprobado);
                    widget.filteredMateriasReprobadas.remove(aprobado);
                  });
                } catch (e) {
                  Dialogs.showSnackbarError(
                      context, 'Error al eliminar la asignatura reprobadaa');
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
