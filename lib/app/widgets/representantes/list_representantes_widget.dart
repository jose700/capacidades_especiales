import 'dart:io';
import 'package:flutter/material.dart';
import 'package:capacidades_especiales/app/screens/representantes/registrar_representante_screen.dart';
import 'package:capacidades_especiales/app/screens/tutor/notifications/crud/agregar_notificaciones_screen.dart';
import 'package:capacidades_especiales/app/services/representante/service_representantes.dart';
import 'package:capacidades_especiales/app/widgets/tutor/Home/messages/dialogs/login_message.dart';
import 'package:capacidades_especiales/app/utils/resources/app_colors.dart';
import 'package:capacidades_especiales/app/screens/representantes/detalle_representante_screen.dart';
import 'package:capacidades_especiales/app/screens/representantes/editar_representantes_screen.dart';
import 'package:capacidades_especiales/app/screens/tutor/notifications/crud/agregar_notificaciones_por_representantes_screen.dart';
import 'package:capacidades_especiales/app/widgets/search/no_results_widgets.dart';
import 'package:capacidades_especiales/app/models/representantes/representative_model.dart';

class RepresentanteListScreen extends StatefulWidget {
  final sesion;
  final Future<List<Representante>> futureRepresentantes;
  final List<Representante> filteredRepresentantes;
  final Function(bool) updateRepresentantes;

  RepresentanteListScreen({
    required this.sesion,
    required this.futureRepresentantes,
    required this.filteredRepresentantes,
    required this.updateRepresentantes,
  });

  @override
  _RepresentanteListScreenState createState() =>
      _RepresentanteListScreenState();
}

class _RepresentanteListScreenState extends State<RepresentanteListScreen> {
  final Set<Representante> _selectedRepresentantes = {};
  final ServicioRepresentante servicioRepresentante = ServicioRepresentante();

  void _onSelectRepresentante(Representante representante, bool isSelected) {
    setState(() {
      if (isSelected) {
        _selectedRepresentantes.add(representante);
      } else {
        _selectedRepresentantes.remove(representante);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Representante>>(
      future: widget.futureRepresentantes,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData) {
          if (widget.filteredRepresentantes.isEmpty) {
            return Scaffold(
              body: Center(child: NoResultsWidget()),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RegistroEstudiante(
                        sesion: widget.sesion,
                        usuario: widget.sesion.usuario,
                      ),
                    ),
                  );
                },
                child: const Icon(Icons.add),
                tooltip: 'Agregar Representante',
              ),
            );
          }
          final representantes = snapshot.data!;
          return Scaffold(
            body: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Representando a estudiante')),
                  DataColumn(label: Text('Foto del representante')),
                  DataColumn(label: Text('Nombres')),
                  DataColumn(label: Text('Apellidos')),
                  DataColumn(label: Text('Cédula')),
                  DataColumn(label: Text('Correo')),
                  DataColumn(label: Text('Teléfono')),
                  DataColumn(label: Text('Ocupación')),
                  DataColumn(label: Text('Estado civil')),
                  DataColumn(label: Text('Enviar notificación')),
                  DataColumn(label: Text('Acciones')),
                ],
                rows: representantes.map((representante) {
                  final isSelected =
                      _selectedRepresentantes.contains(representante);
                  return DataRow(
                    selected: isSelected,
                    onSelectChanged: (isSelected) {
                      _onSelectRepresentante(
                          representante, isSelected ?? false);
                    },
                    cells: [
                      DataCell(Text(
                          '${representante.representandoNombres} ${representante.representandoApellidos}')),
                      DataCell(
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    DetalleRepresentanteScreen(
                                        representante, widget.sesion),
                              ),
                            );
                          },
                          child: Hero(
                            tag: 'representante_${representante.idestudiante}',
                            child: CircleAvatar(
                              radius: 20.0,
                              backgroundImage: representante.imagen != null
                                  ? FileImage(File(representante.imagen!))
                                  : null,
                              child: representante.imagen == null
                                  ? const Icon(Icons.person, size: 20.0)
                                  : null,
                            ),
                          ),
                        ),
                      ),
                      DataCell(Text(representante.nombres ?? '')),
                      DataCell(Text(representante.apellidos ?? '')),
                      DataCell(Text(representante.cedula ?? '')),
                      DataCell(Text(representante.correo ?? '')),
                      DataCell(Text(representante.numberphone ?? '')),
                      DataCell(Text(representante.ocupacion ?? '')),
                      DataCell(Text(representante.estadocivil ?? '')),
                      DataCell(
                        IconButton(
                          icon: const Icon(Icons.notification_add,
                              color: AppColors.contentColorGreen),
                          onPressed: () {
                            if (_selectedRepresentantes.length > 1) {
                              Dialogs.showSnackbarError(context,
                                  'Error, no puedes enviar notificaciones a varios representantes a la vez.');
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      AgregarNotificacionPorRepresentanteScreen(
                                    sesion: widget.sesion,
                                    representante,
                                    usuario:
                                        representante.usuariotutor.toString(),
                                    idnotificacion: 1,
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                      ),
                      DataCell(
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit,
                                  color: AppColors.contentColorBlue),
                              onPressed: () {
                                if (_selectedRepresentantes.length > 1) {
                                  Dialogs.showSnackbarError(context,
                                      'Lo sentimos, no puedes editar más de dos datos a la vez.');
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          EditarRepresentantesScreen(
                                              representante,
                                              sesion: widget.sesion),
                                    ),
                                  );
                                }
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete,
                                  color: AppColors.contentColorRed),
                              onPressed: () {
                                if (_selectedRepresentantes.length > 1) {
                                  Dialogs.showSnackbarError(context,
                                      'Error, no puedes eliminar varios representantes a la vez.');
                                } else {
                                  showDeleteConfirmationDialog(representante);
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                if (_selectedRepresentantes.isNotEmpty) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AgregarNotificacionScreen(
                        widget.sesion.idtutor,
                        sesion: widget.sesion,
                        representantes: _selectedRepresentantes.toList(),
                        usuario: widget.sesion.usuario.toString(),
                        idnotificacion: 1,
                      ),
                    ),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RegistroEstudiante(
                        sesion: widget.sesion,
                        usuario: widget.sesion.usuario,
                      ),
                    ),
                  );
                }
              },
              child: Icon(
                _selectedRepresentantes.isNotEmpty
                    ? Icons.notification_add
                    : Icons.add,
              ),
              tooltip: _selectedRepresentantes.isNotEmpty
                  ? 'Enviar Notificación'
                  : 'Agregar Representante',
            ),
          );
        } else {
          return Scaffold(
            body: Center(child: NoTDataWidget()),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RegistroEstudiante(
                      sesion: widget.sesion,
                      usuario: widget.sesion.usuario,
                    ),
                  ),
                );
              },
              child: const Icon(Icons.add),
              tooltip: 'Agregar Representante',
            ),
          );
        }
      },
    );
  }

  void showDeleteConfirmationDialog(Representante representante) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar Eliminación'),
          content: const Text(
              '¿Estás seguro de que deseas eliminar este representante?'),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
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
                  await servicioRepresentante.eliminarRepresentante(
                      representante.idrepresentante.toString(),
                      widget.sesion.token);
                  Dialogs.showSnackbar(
                      context, 'Representante eliminado exitosamente.');
                  Navigator.pop(context);
                  widget.updateRepresentantes(true);

                  setState(() {
                    widget.filteredRepresentantes.remove(representante);
                    widget.filteredRepresentantes.remove(representante);
                  });
                } catch (e) {
                  Dialogs.showSnackbarError(
                      context, 'Error al eliminar el representante.');
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
