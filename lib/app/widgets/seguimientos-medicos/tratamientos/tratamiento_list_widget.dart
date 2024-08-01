import 'dart:io';

import 'package:capacidades_especiales/app/models/seguimientos-medicos/tratamientos/treatment_model.dart';
import 'package:capacidades_especiales/app/models/tutor/login_model.dart';
import 'package:capacidades_especiales/app/utils/resources/app_colors.dart';
import 'package:capacidades_especiales/app/screens/seguimientos-medicos/tratamientos/edit_tratamiento_screen.dart';

import 'package:capacidades_especiales/app/services/seguimientos-medicos/tratamiento/service_tratamiento.dart';
import 'package:capacidades_especiales/app/widgets/search/no_results_widgets.dart';
import 'package:capacidades_especiales/app/widgets/tutor/Home/messages/dialogs/login_message.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TratamientoList extends StatefulWidget {
  final Sesion sesion;
  final List<Tratamiento> filteredTratamientos;
  final List<Tratamiento> tratamientos;
  final Future<List<Tratamiento>> Function() fetchTratamientos;
  final BuildContext context;
  final ServicioTratamiento servicioTratamiento;

  TratamientoList({
    required this.filteredTratamientos,
    required this.tratamientos,
    required this.fetchTratamientos,
    required this.context,
    required this.servicioTratamiento,
    required this.sesion,
  });

  @override
  _TratamientoListState createState() => _TratamientoListState();
}

class _TratamientoListState extends State<TratamientoList> {
  late Future<List<Tratamiento>> futureTratamientos;

  @override
  void initState() {
    super.initState();
    futureTratamientos = widget.fetchTratamientos();
  }

  @override
  Widget build(BuildContext context) {
    return _buildTratamientosList();
  }

  Widget _buildTratamientosList() {
    return FutureBuilder<List<Tratamiento>>(
      future: futureTratamientos,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData) {
          if (widget.filteredTratamientos.isEmpty) {
            return NoResultsWidget();
          }
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: const [
                DataColumn(label: Text('Foto')),
                DataColumn(label: Text('Nombres y Apellidos')),
                DataColumn(label: Text('Cédula')),
                DataColumn(label: Text('Tipo de discapaciddad')),
                DataColumn(label: Text('Descripcion del tratamiento')),
                DataColumn(label: Text('Fecha de registro')),
                DataColumn(label: Text('Opinión del paciente')),
                DataColumn(label: Text('Tratamiento Psicológico')),
                DataColumn(label: Text('Tratamiento Físico')),
                DataColumn(label: Text('Duración del tratamiento')),
                DataColumn(label: Text('Resultado')),
                DataColumn(label: Text('Acciones')),
              ],
              rows: widget.filteredTratamientos
                  .map((tratamiento) => DataRow(cells: [
                        DataCell(
                          CircleAvatar(
                            radius: 20.0,
                            backgroundImage: tratamiento.estudiante_imagen !=
                                    null
                                ? FileImage(File(
                                    tratamiento.estudiante_imagen.toString()))
                                : null,
                            child: tratamiento.estudiante_imagen == null
                                ? const Icon(Icons.person, size: 20.0)
                                : null,
                          ),
                        ),
                        DataCell(Text(
                            '${tratamiento.estudiante_nombres} ${tratamiento.estudiante_apellidos}')),
                        DataCell(
                            Text(tratamiento.estudiante_cedula.toString())),
                        DataCell(Text(tratamiento.clasediscapacidad)),
                        DataCell(
                          Text(tratamiento.descripcionconsulta),
                        ),
                        DataCell(Text(DateFormat('dd/MM/yyyy EEEE')
                            .format(tratamiento.fechaconsulta))),
                        DataCell(Text(tratamiento.opinionpaciente)),
                        DataCell(Text(tratamiento.tratamientopsicologico)),
                        DataCell(Text(tratamiento.tratamientofisico)),
                        DataCell(
                            Text(tratamiento.duraciontratamiento.toString())),
                        DataCell(Text(tratamiento.resultado)),
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
                                        EditarTratamientoScreen(tratamiento,
                                            sesion: widget.sesion),
                                  ),
                                );
                                if (cambiosRealizados == true) {
                                  // Si se realizaron cambios, actualiza la lista.
                                  await widget.fetchTratamientos();
                                }
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete,
                                  color: AppColors.contentColorRed),
                              onPressed: () {
                                _showDeleteConfirmationDialog(tratamiento);
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

  void _showDeleteConfirmationDialog(Tratamiento tratamiento) {
    showAdaptiveDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Eliminar'),
          content: const Text('¿Estás seguro de eliminar este tratamiento?'),
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
                  await widget.servicioTratamiento.eliminarTratamiento(
                      tratamiento.idtratamiento.toString(),
                      widget.sesion.token);
                  Dialogs.showSnackbar(
                      context, 'Se ha eliminado el tratamiento correctamente');
                  Navigator.pop(context);

                  setState(() {
                    widget.tratamientos.remove(tratamiento);
                    widget.filteredTratamientos.remove(tratamiento);

                    widget.filteredTratamientos.add(tratamiento);
                    widget.tratamientos.add(tratamiento);
                  });
                } catch (e) {
                  Dialogs.showSnackbarError(
                      context, 'Error al eliminar el tratamiento');
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
