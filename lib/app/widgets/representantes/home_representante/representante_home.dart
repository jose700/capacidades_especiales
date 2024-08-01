import 'package:capacidades_especiales/app/utils/resources/app_colors.dart';
import 'package:capacidades_especiales/app/screens/representantes/assignature_students/graphic_student_screen.dart';
import 'package:capacidades_especiales/app/screens/representantes/assignature_students/mis_estudiantes_con_asiganturas.dart';
import 'package:flutter/material.dart';
import 'package:capacidades_especiales/app/models/tutor/login_model.dart';
import 'package:capacidades_especiales/app/models/tutor/notifications_model.dart';
import 'package:capacidades_especiales/app/widgets/representantes/home_representante/navigations_representante.dart';
import 'package:capacidades_especiales/app/widgets/representantes/home_representante/settings_representante.dart';
import 'package:capacidades_especiales/app/screens/representantes/notificacations_represent/notificacacones_representantes_screen.dart';
import 'package:capacidades_especiales/app/services/tutor/notificaciones_service.dart';
import 'package:jwt_decode/jwt_decode.dart';

class RepresentanteScreen extends StatefulWidget {
  final Sesion sesion;

  const RepresentanteScreen({Key? key, required this.sesion}) : super(key: key);

  @override
  _RepresentanteScreenState createState() => _RepresentanteScreenState();
}

class _RepresentanteScreenState extends State<RepresentanteScreen> {
  List<Notificacion> _notificaciones = [];
  int _selectedIndex = 0;
  bool _hasNotifications = false;

  @override
  void initState() {
    super.initState();
    _cargarNotificaciones();
  }

  Future<void> _cargarNotificaciones() async {
    try {
      List<Notificacion> notificaciones =
          await NotificacionesService.obtenerNotificacionesPorRepresentante(
              widget.sesion.usuario.toString(), widget.sesion.token);

      setState(() {
        _notificaciones = notificaciones;
        _hasNotifications =
            _notificaciones.any((notificacion) => !notificacion.leida);
      });
    } catch (e) {
      print('Error al cargar notificaciones: $e');
      setState(() {});
    }
  }

  Future<void> _marcarNotificacionComoLeida(int idNotificacion) async {
    try {
      await NotificacionesService.marcarNotificacionComoLeida(
          widget.sesion.usuario.toString(),
          idNotificacion,
          widget.sesion.token);

      setState(() {
        _notificaciones.forEach((notificacion) {
          if (notificacion.idnotificacion == idNotificacion) {
            notificacion.leida = true;
          }
        });

        _hasNotifications =
            _notificaciones.any((notificacion) => !notificacion.leida);
      });
    } catch (e) {
      print('Error al marcar notificación como leída: $e');
    }
  }

  int obtenerIdRepresentanteDesdeToken(String token) {
    Map<String, dynamic> payload = Jwt.parseJwt(token);
    int? idrepresentante = payload['idrepresentante'];
    return idrepresentante ?? 0;
  }

  void _onTabSelected(int index) {
    setState(() {
      _selectedIndex = index;
      if (index == 3) {
        if (_notificaciones.isNotEmpty) {
          _marcarNotificacionComoLeida(_notificaciones[0].idnotificacion);
        }
        _cargarNotificaciones();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    //int idrepresentante = obtenerIdRepresentanteDesdeToken(widget.sesion.token);

    return Scaffold(
      body: _buildBody(),
      bottomNavigationBar: NavigationsBarRepresentante(
        onTabSelected: _onTabSelected,
        selectedIndex: _selectedIndex,
        hasNotifications: _hasNotifications,
        iconColor: AppColors.contentColorBlue,
      ),
    );
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return MiEstudianteScreen(
            widget.sesion.usuario.toString(), widget.sesion);
      // Aquí se muestra la pantalla de datos del estudiante
      case 1:
        return SettingsProfileRepresentante(widget.sesion.idrepresentante ?? 0,
            usuario: widget.sesion.usuario.toString(), sesion: widget.sesion);
      // Aquí se muestra la configuración
      case 2:
        return GraphisScreenStudent(
            widget.sesion.usuario.toString(), widget.sesion);

      // Aquí se muestra la pantalla de estadísticas
      case 3:
        return NotificacaconesRepresentantesScreen(
          widget.sesion.usuario.toString(),
          sesion: widget.sesion,
        );
      // Aquí se muestra la pantalla de notificaciones
      default:
        return Container();
    }
  }
}
