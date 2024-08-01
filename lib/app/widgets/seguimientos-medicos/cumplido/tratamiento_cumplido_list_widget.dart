import 'dart:io';

import 'package:capacidades_especiales/app/models/seguimientos-medicos/tratamientos/compliment_model.dart';
import 'package:capacidades_especiales/app/models/tutor/login_model.dart';
import 'package:capacidades_especiales/app/utils/resources/app_colors.dart';
import 'package:capacidades_especiales/app/screens/seguimientos-medicos/cumplidos/editar_tratamientos_cumplidos_screen%20.dart';
import 'package:capacidades_especiales/app/services/seguimientos-medicos/tratamiento/service_cumplido.dart';
import 'package:capacidades_especiales/app/widgets/search/no_results_widgets.dart';
import 'package:capacidades_especiales/app/widgets/tutor/Home/messages/dialogs/login_message.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TratamientoCumplidoList extends StatefulWidget {
  final Sesion sesion;
  final List<TratamientoCumplido> filteredTratamientosCumplidos;
  final List<TratamientoCumplido> tratamientosCumplidos;
  final Future<List<TratamientoCumplido>> Function() fetchTratamientosCumplidos;
  final BuildContext context;
  final ServicioTratamientoCumplido servicioTratamientoCumplidos;

  TratamientoCumplidoList({
    required this.filteredTratamientosCumplidos,
    required this.tratamientosCumplidos,
    required this.fetchTratamientosCumplidos,
    required this.context,
    required this.servicioTratamientoCumplidos,
    required this.sesion,
  });

  @override
  _TratamientoListState createState() => _TratamientoListState();
}

class _TratamientoListState extends State<TratamientoCumplidoList> {
  late Future<List<TratamientoCumplido>> futureTratamientosCumplidos;

  @override
  void initState() {
    super.initState();
    futureTratamientosCumplidos = widget.fetchTratamientosCumplidos();
  }

  @override
  Widget build(BuildContext context) {
    return _buildTratamientosList();
  }

  Widget _buildTratamientosList() {
    return FutureBuilder<List<TratamientoCumplido>>(
      future: futureTratamientosCumplidos,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData) {
          if (widget.filteredTratamientosCumplidos.isEmpty) {
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
              rows: widget.filteredTratamientosCumplidos
                  .map((cumplidos) => DataRow(cells: [
                        DataCell(
                          cumplidos.cumplimiento == true
                              ? CircleAvatar(
                                  radius: 20.0,
                                  backgroundImage:
                                      cumplidos.estudiante_imagen != null
                                          ? FileImage(File(cumplidos
                                              .estudiante_imagen
                                              .toString()))
                                          : null,
                                  child: cumplidos.estudiante_imagen == null
                                      ? const Icon(Icons.person, size: 20.0)
                                      : null,
                                )
                              : SizedBox(), // Aquí se muestra un SizedBox si cumplimiento es false
                        ),
                        DataCell(
                          cumplidos.cumplimiento == true
                              ? Text(
                                  '${cumplidos.estudiante_nombres} ${cumplidos.estudiante_apellidos}')
                              : SizedBox(), // Aquí se muestra un SizedBox si cumplimiento es false
                        ),
                        DataCell(
                          cumplidos.cumplimiento == true
                              ? Checkbox(
                                  value: cumplidos.cumplimiento ?? false,
                                  onChanged: (bool? value) {},
                                  checkColor: AppColors.contentColorWhite,
                                  activeColor: cumplidos.cumplimiento == true
                                      ? AppColors.contentColorGreen
                                      : AppColors.contentColorRed,
                                  tristate: false,
                                )
                              : SizedBox(), // Aquí se muestra un SizedBox si cumplimiento es false
                        ),
                        DataCell(
                          Text(cumplidos.observacion),
                        ),
                        DataCell(
                          cumplidos.cumplimiento == true
                              ? Row(
                                  children: [
                                    Icon(Icons.access_time),
                                    SizedBox(
                                        width:
                                            4), // Espacio entre el icono y el texto
                                    Text(
                                      DateFormat(
                                              'dd MMM \'del\' yyyy \'Empezó a las \' HH:mm:ss a')
                                          .format(cumplidos.fechainicio),
                                    ),
                                  ],
                                )
                              : SizedBox(), // Muestra un SizedBox si cumplimiento es false
                        ),
                        DataCell(
                          cumplidos.cumplimiento == true
                              ? Row(
                                  children: [
                                    Icon(Icons.access_time),
                                    SizedBox(
                                        width:
                                            4), // Espacio entre el icono y el texto
                                    Text(
                                      DateFormat(
                                              'dd MMM \'del\' yyyy \'Duración\' HH:mm:ss a')
                                          .format(cumplidos.fechafin),
                                    ),
                                  ],
                                )
                              : SizedBox(), // Muestra un SizedBox si cumplimiento es false
                        ),
                        DataCell(
                          cumplidos.cumplimiento == true
                              ? Row(
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
                                                ActualizarTratamientosCumplidosScreen(
                                                    sesion: widget.sesion,
                                                    cumplidos),
                                          ),
                                        );
                                        if (cambiosRealizados == true) {
                                          // Si se realizaron cambios, actualiza la lista.
                                          await widget
                                              .fetchTratamientosCumplidos();
                                        }
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete,
                                          color: AppColors.contentColorRed),
                                      onPressed: () {
                                        _showDeleteConfirmationDialog(
                                            cumplidos);
                                      },
                                    ),
                                  ],
                                )
                              : SizedBox(), // Aquí se muestra un SizedBox si cumplimiento es false
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

  void _showDeleteConfirmationDialog(TratamientoCumplido tratamientoCumplidos) {
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
                  await widget.servicioTratamientoCumplidos
                      .eliminarTratamientoCumplido(
                          tratamientoCumplidos.idcumplido.toString(),
                          widget.sesion.token);
                  Dialogs.showSnackbar(
                      context, 'Se ha eliminado el tratamiento correctamente');
                  Navigator.pop(context);

                  setState(() {
                    widget.tratamientosCumplidos.remove(tratamientoCumplidos);
                    widget.filteredTratamientosCumplidos
                        .remove(tratamientoCumplidos);
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
