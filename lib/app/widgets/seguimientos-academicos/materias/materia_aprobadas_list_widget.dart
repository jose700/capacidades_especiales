import 'package:capacidades_especiales/app/models/seguimientos-academicos/materias/approved_assignatura_model.dart';
import 'package:capacidades_especiales/app/models/tutor/login_model.dart';
import 'package:capacidades_especiales/app/utils/resources/app_colors.dart';
import 'package:capacidades_especiales/app/screens/seguimientos-academicos/materias/materias_aprobadas/editar_asignaturas_aprobadas_screen.dart';
import 'package:capacidades_especiales/app/services/seguimientos-academicos/materia/materia_aprobada_service.dart';
import 'package:capacidades_especiales/app/widgets/search/no_results_widgets.dart';

import 'package:capacidades_especiales/app/widgets/tutor/Home/messages/dialogs/login_message.dart';
import 'package:flutter/material.dart';

class MateriaAprobadasList extends StatefulWidget {
  final Sesion sesion;
  final List<MateriaAprobada> filteredMateriasAprobadas;
  final List<MateriaAprobada> aprobadas;
  final Future<List<MateriaAprobada>> Function() fetchMateriasAprobadas;
  final BuildContext context;
  final MateriaAprobadaService servicioMateriaAprobada;

  MateriaAprobadasList({
    required this.sesion,
    required this.filteredMateriasAprobadas,
    required this.aprobadas,
    required this.fetchMateriasAprobadas,
    required this.context,
    required this.servicioMateriaAprobada,
  });

  @override
  _MateriaListState createState() => _MateriaListState();
}

class _MateriaListState extends State<MateriaAprobadasList> {
  late Future<List<MateriaAprobada>> futureMateriasAprobadas;

  @override
  void initState() {
    super.initState();
    futureMateriasAprobadas = widget.fetchMateriasAprobadas();
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
          if (widget.filteredMateriasAprobadas.isEmpty) {
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
                DataColumn(label: Text('Aprobado')),
                DataColumn(label: Text('Acciones')),
              ],
              rows: widget.filteredMateriasAprobadas
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
                          aprobado.aprobado == true
                              ? Checkbox(
                                  value: aprobado.aprobado ?? false,
                                  onChanged: (bool? value) {},
                                  checkColor: AppColors.contentColorWhite,
                                  activeColor: aprobado.aprobado == true
                                      ? AppColors.contentColorGreen
                                      : AppColors.contentColorRed,
                                  tristate: false,
                                )
                              : SizedBox(), // Aquí se muestra un SizedBox si cumplimiento es false
                        ),
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
                                      builder: (context) =>
                                          EditarMateriasAprobadasScreen(
                                              sesion: widget.sesion, aprobado),
                                    ),
                                  );
                                  if (cambiosRealizados == true) {
                                    // Si se realizaron cambios, actualiza la lista.
                                    await widget.fetchMateriasAprobadas();
                                  }
                                }),
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
                  await widget.servicioMateriaAprobada.eliminarMateriaAprobada(
                      aprobado.idaprobada.toString(), widget.sesion.token);
                  Dialogs.showSnackbar(context,
                      'Se ha eliminado la asignatura aprobada correctamente');
                  Navigator.pop(context);

                  setState(() {
                    widget.aprobadas.remove(aprobado);
                    widget.filteredMateriasAprobadas.remove(aprobado);
                  });
                } catch (e) {
                  Dialogs.showSnackbarError(
                      context, 'Error al eliminar la asignatura aprobadaa');
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
