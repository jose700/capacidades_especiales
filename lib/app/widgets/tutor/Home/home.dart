import 'package:capacidades_especiales/app/models/tutor/login_model.dart';
import 'package:capacidades_especiales/app/models/tutor/tutor_model.dart';
import 'package:capacidades_especiales/app/utils/resources/app_colors.dart';
import 'package:capacidades_especiales/app/screens/tutor/charts/data_chart_screen.dart';
import 'package:capacidades_especiales/app/screens/tutor/notifications/lista_notificaciones_screen.dart';
import 'package:capacidades_especiales/app/screens/tutor/settings/settings_profile_tutor.dart';
import 'package:capacidades_especiales/app/services/tutor/service_register_login.dart';
import 'package:capacidades_especiales/app/widgets/tutor/Home/grid/home_grid.dart';
import 'package:capacidades_especiales/app/widgets/tutor/Home/navigationsBar/navigationsBar.dart';

import 'package:flutter/material.dart';
import 'package:jwt_decode/jwt_decode.dart';

class HomeScreen extends StatefulWidget {
  final Sesion sesion;

  const HomeScreen({Key? key, required this.sesion}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  RegisterLoginService _registerLoginService = RegisterLoginService();

  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  void _onTabSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  int obtenerIdTutorDesdeToken(String token) {
    Map<String, dynamic> payload = Jwt.parseJwt(token);
    int? idTutor = payload['idtutor'];
    return idTutor ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    //int idTutor = obtenerIdTutorDesdeToken(widget.sesion.token);

    return Scaffold(
      body: _buildBody(),
      bottomNavigationBar: NavigationsBar(
        onTabSelected: _onTabSelected,
        selectedIndex: _selectedIndex,
        iconColor: AppColors.contentColorBlue,
      ),
    );
  }

  Widget _buildBody() {
    int idTutor = obtenerIdTutorDesdeToken(widget.sesion.token);
    switch (_selectedIndex) {
      case 0:
        return HomeGrid(
          sesion: widget.sesion,
          usuario: widget.sesion.usuario.toString(),
          token: widget.sesion.token,
        );
      case 1:
        return PieChartSample1(
          usuario: widget.sesion.usuario.toString(),
          sesion: widget.sesion,
        );
      case 2:
        return SettingsProfileTutor(
          idTutor,
          usuario: widget.sesion.usuario.toString(),
        );
      case 3:
        return NotificationsScreen(
          sesion: widget.sesion,
          idTutor,
          usuario: widget.sesion.usuario.toString(),
        );
      default:
        return Container();
    }
  }

  Future<Tutor?> obtenerTutorPorId(int idTutor) async {
    try {
      final tutor = await _registerLoginService.obtenerTutor(idTutor);
      return tutor;
    } catch (e) {
      print('Error al obtener el tutor por ID: $e');
      return null;
    }
  }
}
