import 'package:capacidades_especiales/app/models/tutor/login_model.dart';
import 'package:capacidades_especiales/app/widgets/search/no_results_widgets.dart';
import 'package:flutter/material.dart';
import 'package:capacidades_especiales/app/models/tutor/notifications_model.dart';
import 'package:capacidades_especiales/app/services/tutor/notificaciones_service.dart';
import 'package:capacidades_especiales/app/utils/providers/theme/theme_provider.dart';
import 'package:capacidades_especiales/app/widgets/tutor/Home/messages/dialogs/login_message.dart';

class NotificationsScreen extends StatefulWidget {
  final int idTutor;
  final String usuario;
  final Sesion sesion;
  const NotificationsScreen(this.idTutor,
      {Key? key, required this.usuario, required this.sesion})
      : super(key: key);

  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<Notificacion> _notificaciones = [];
  NotificacionesService serviceNotificacion = NotificacionesService();
  bool _isLoading = true;
  late ThemeProvider _themeProvider;

  @override
  void initState() {
    super.initState();
    _themeProvider = ThemeProvider();
    _cargarNotificaciones();
  }

  Future<void> _cargarNotificaciones() async {
    try {
      List<Notificacion> notificaciones =
          await NotificacionesService.obtenerNotificacionesPorUsuario(
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
              onRefresh: _cargarNotificaciones,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: _notificaciones.isEmpty
                    ? buildNoNotificationsWidget()
                    : ListView.builder(
                        itemCount: _notificaciones.length,
                        itemBuilder: (context, index) {
                          final notificacion = _notificaciones[index];
                          return Dismissible(
                            key: Key(notificacion.idnotificacion.toString()),
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
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                color:
                                    _themeProvider.inputBackgroundOpacityColor,
                                child: _buildNotificacionItem(notificacion),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ),
    );
  }

  Widget _buildNotificacionItem(Notificacion notificacion) {
    return ListTile(
      contentPadding: EdgeInsets.all(16),
      title: Text(
        'Para: ${notificacion.representanteNombres ?? ''} ${notificacion.representanteApellidos ?? ''}',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (notificacion.tituloEvento != null &&
              notificacion.tituloEvento!.isNotEmpty)
            Text('Tema a tratar: ${notificacion.tituloEvento}'),
          SizedBox(height: 4),
          Text('Descripción: ${notificacion.mensaje}'),
          SizedBox(height: 4),
          Text(
            'Enviado a las ${notificacion.horaEvento!.hourOfPeriod}:${notificacion.horaEvento!.minute} ${notificacion.horaEvento!.hour >= 12 ? 'pm' : 'am'}',
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
        ],
      ),
      trailing: Icon(
        notificacion.leida ? Icons.mark_email_read : Icons.mark_email_unread,
        color: notificacion.leida ? Colors.green : Colors.grey,
      ),
    );
  }
}
