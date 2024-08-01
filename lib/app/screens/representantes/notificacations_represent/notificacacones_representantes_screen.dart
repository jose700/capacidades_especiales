import 'package:capacidades_especiales/app/models/tutor/login_model.dart';
import 'package:capacidades_especiales/app/utils/providers/theme/theme_provider.dart';
import 'package:capacidades_especiales/app/widgets/search/no_results_widgets.dart';
import 'package:flutter/material.dart';
import 'package:capacidades_especiales/app/widgets/tutor/Home/messages/dialogs/login_message.dart';
import 'package:capacidades_especiales/app/models/tutor/notifications_model.dart';
import 'package:capacidades_especiales/app/services/tutor/notificaciones_service.dart';

class NotificacaconesRepresentantesScreen extends StatefulWidget {
  final String usuario;
  final Sesion sesion;
  const NotificacaconesRepresentantesScreen(
    this.usuario, {
    Key? key,
    required this.sesion,
  }) : super(key: key);

  @override
  _NotificacaconesRepresentantesScreenState createState() =>
      _NotificacaconesRepresentantesScreenState();
}

class _NotificacaconesRepresentantesScreenState
    extends State<NotificacaconesRepresentantesScreen> {
  List<Notificacion> _notificaciones = [];
  NotificacionesService serviceNotificacion = NotificacionesService();
  bool _isLoading = true;
  late ThemeProvider _themeProvider; // Instancia de ThemeProvider

  @override
  void initState() {
    super.initState();
    _themeProvider = ThemeProvider();
    _cargarNotificaciones();
  }

  Future<void> _cargarNotificaciones() async {
    try {
      List<Notificacion> notificaciones =
          await NotificacionesService.obtenerNotificacionesPorRepresentante(
              widget.usuario, widget.sesion.token);

      setState(() {
        _notificaciones = notificaciones;
        _isLoading = false;
      });
    } catch (e) {
      print('Error al cargar notificaciones: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _actualizarNotificaciones() async {
    try {
      List<Notificacion> notificaciones =
          await NotificacionesService.obtenerNotificacionesPorRepresentante(
              widget.usuario, widget.sesion.token);

      setState(() {
        _notificaciones = notificaciones;
      });
    } catch (e) {
      print('Error al actualizar notificaciones: $e');
    }
  }

  Future<void> _eliminarNotificacion(int index) async {
    try {
      await serviceNotificacion.eliminarNotificacion(
          _notificaciones[index].idnotificacion.toString(),
          widget.sesion.token);

      setState(() {
        _notificaciones.removeAt(index);
        Dialogs.showSnackbar(context, 'Se ha eliminado la notificación');
      });
    } catch (e) {
      Dialogs.showSnackbarError(context, 'Error al eliminar notificación');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notificaciones'),
        automaticallyImplyLeading: false,
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : RefreshIndicator(
              onRefresh: _actualizarNotificaciones,
              child: _notificaciones.isEmpty
                  ? buildNoNotificationsWidget()
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: ListView.builder(
                        itemCount: _notificaciones.length,
                        itemBuilder: (context, index) {
                          return Dismissible(
                            key: Key(_notificaciones[index]
                                .idnotificacion
                                .toString()),
                            direction: DismissDirection.endToStart,
                            background: Container(
                              alignment: Alignment.centerRight,
                              color: Colors.red,
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20.0),
                                child: Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            onDismissed: (direction) {
                              _eliminarNotificacion(index);
                            },
                            child: AnimatedContainer(
                              curve: Curves.easeInCirc,
                              duration:
                                  Duration(milliseconds: 300 + (index * 200)),
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 16.0),
                              decoration: BoxDecoration(
                                color:
                                    _themeProvider.inputBackgroundOpacityColor,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 4,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: ListTile(
                                title: Text(
                                    'De: ${_notificaciones[index].usuarioTutor}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    )),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Tema a tratar: ${_notificaciones[index].tituloEvento}',
                                    ),
                                    Text(
                                        'Descripción: ${_notificaciones[index].mensaje}'),
                                    Text(
                                      'Enviado a las ${_notificaciones[index].horaEvento!.hourOfPeriod}:${_notificaciones[index].horaEvento!.minute} ${_notificaciones[index].horaEvento!.hour >= 12 ? 'pm' : 'am'}',
                                      style: TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                                trailing: GestureDetector(
                                  onTap: () => _eliminarNotificacion(index),
                                  child: Icon(
                                    Icons.delete,
                                    color: Colors.redAccent,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
            ),
    );
  }
}
