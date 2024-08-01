import 'dart:io';
import 'package:capacidades_especiales/app/models/seguimientos-medicos/tratamientos/compliment_model.dart';
import 'package:capacidades_especiales/app/models/tutor/login_model.dart';
import 'package:capacidades_especiales/app/utils/resources/app_colors.dart';
import 'package:capacidades_especiales/app/screens/seguimientos-medicos/nocumplidos/editar_tratamientos_nocumplidos_screen%20.dart';
import 'package:capacidades_especiales/app/services/seguimientos-medicos/tratamiento/service_no_cumplido.dart';
import 'package:capacidades_especiales/app/widgets/search/no_results_widgets.dart';
import 'package:capacidades_especiales/app/widgets/tutor/Home/messages/dialogs/login_message.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TratamientoNoCumplidoList extends StatefulWidget {
  final Sesion sesion;
  final List<TratamientoCumplido> filteredTratamientosNoCumplidos;
  final List<TratamientoCumplido> tratamientosNoCumplidos;
  final Future<List<TratamientoCumplido>> Function()
      fetchTratamientosNoCumplidos;
  final BuildContext context;
  final ServicioTratamientoNoCumplido servicioTratamientoNoCumplidos;

  TratamientoNoCumplidoList({
    required this.filteredTratamientosNoCumplidos,
    required this.tratamientosNoCumplidos,
    required this.fetchTratamientosNoCumplidos,
    required this.context,
    required this.servicioTratamientoNoCumplidos,
    required this.sesion,
  });

  @override
  _TratamientoListState createState() => _TratamientoListState();
}

class _TratamientoListState extends State<TratamientoNoCumplidoList> {
  late Future<List<TratamientoCumplido>> futureTratamientosNoCumplidos;

  @override
  void initState() {
    super.initState();
    futureTratamientosNoCumplidos = widget.fetchTratamientosNoCumplidos();
  }

  @override
  Widget build(BuildContext context) {
    return _buildTratamientosList();
  }

  Widget _buildTratamientosList() {
    return FutureBuilder<List<TratamientoCumplido>>(
      future: futureTratamientosNoCumplidos,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData) {
          if (widget.filteredTratamientosNoCumplidos.isEmpty) {
            return NoResultsWidget();
          }
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: const [
                DataColumn(label: Text('Foto ')),
                DataColumn(label: Text('Nombres y apellidos')),
                DataColumn(label: Text('Cumplió con el tratamiento')),
                DataColumn(label: Text('Observacion')),
                DataColumn(label: Text('Fecha Inicio')),
                DataColumn(label: Text('Fecha Fin')),
                DataColumn(label: Text('Acciones')),
              ],
              rows: widget.filteredTratamientosNoCumplidos
                  .map((nocumplidos) => DataRow(cells: [
                        DataCell(
                          CircleAvatar(
                            radius: 20.0,
                            backgroundImage: nocumplidos.estudiante_imagen !=
                                    null
                                ? FileImage(File(
                                    nocumplidos.estudiante_imagen.toString()))
                                : null,
                            child: nocumplidos.estudiante_imagen == null
                                ? const Icon(Icons.person, size: 20.0)
                                : null,
                          ),
                        ),
                        DataCell(
                          Text(
                              '${nocumplidos.estudiante_nombres} ${nocumplidos.estudiante_apellidos}'),
                        ),
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
                        DataCell(
                          Text(nocumplidos.observacion),
                        ),
                        DataCell(Row(
                          children: [
                            Icon(Icons.access_time),
                            SizedBox(
                                width: 4), // Espacio entre el icono y el texto
                            Text(
                              DateFormat(
                                      'dd MMM \'del\' yyyy \'Empezó a las \' HH:mm:ss a')
                                  .format(nocumplidos.fechainicio),
                            ),
                          ],
                        )
                            // Muestra un SizedBox si cumplimiento es false
                            ),
                        DataCell(Row(
                          children: [
                            Icon(Icons.access_time),
                            SizedBox(
                                width: 4), // Espacio entre el icono y el texto
                            Text(
                              DateFormat(
                                      'dd MMM \'del\' yyyy \'Duración\' HH:mm:ss a')
                                  .format(nocumplidos.fechafin),
                            ),
                          ],
                        )
                            // Muestra un SizedBox si cumplimiento es false
                            ),
                        DataCell(
                          Row(
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
                                          ActualizarTratamientosNoCumplidosScreen(
                                              nocumplidos,
                                              sesion: widget.sesion),
                                    ),
                                  );
                                  if (cambiosRealizados == true) {
                                    // Si se realizaron cambios, actualiza la lista.
                                    await widget.fetchTratamientosNoCumplidos();
                                  }
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete,
                                    color: AppColors.contentColorRed),
                                onPressed: () {
                                  _showDeleteConfirmationDialog(nocumplidos);
                                },
                              ),
                            ],
                          ),
                        ),
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

  void _showDeleteConfirmationDialog(
      TratamientoCumplido tratamientoNoCumplidos) {
    showAdaptiveDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Eliminar'),
          content: const Text(
              '¿Estás seguro de eliminar este tratamiento cumplido?'),
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
                  await widget.servicioTratamientoNoCumplidos
                      .eliminarTratamientoNoCumplido(
                          tratamientoNoCumplidos.idnocumplido.toString(),
                          widget.sesion.token);
                  Dialogs.showSnackbar(
                      context, 'Se ha eliminado el tratamiento correctamente');
                  Navigator.pop(context);

                  setState(() {
                    widget.tratamientosNoCumplidos
                        .remove(tratamientoNoCumplidos);
                    widget.filteredTratamientosNoCumplidos
                        .remove(tratamientoNoCumplidos);
                  });
                } catch (e) {
                  Dialogs.showSnackbarError(
                      context, 'Error al eliminar el tratamiento cumplido');
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
