import 'dart:async';

import 'package:capacidades_especiales/app/models/tutor/login_model.dart';

import 'package:capacidades_especiales/app/utils/resources/app_colors.dart';
import 'package:capacidades_especiales/app/widgets/estudiantes/game_section/game_section_widget.dart';
import 'package:capacidades_especiales/app/widgets/estudiantes/tabBar/tabBar_task_widget.dart';

import 'package:capacidades_especiales/app/widgets/tutor/Home/alert/logout_dialog_widget.dart';
import 'package:capacidades_especiales/app/widgets/tutor/settings/settings_widgets.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:lottie/lottie.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GameScreen extends StatefulWidget {
  final Sesion? sesion;

  const GameScreen({Key? key, required this.sesion}) : super(key: key);

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  PackageInfo? _packageInfo;
  bool _isMusicEnabled = true;
  final GlobalKey _keySettingsButton = GlobalKey();

  @override
  void initState() {
    super.initState();
    _initPackageInfo();
    _initMusic();
  }

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  Future<void> _initMusic() async {
    if (_isMusicEnabled) {
      await _audioPlayer.setAsset('assets/sounds/jump.mp3');
      _audioPlayer.setLoopMode(LoopMode.one);
      _audioPlayer.play();
    }
  }

  void _toggleMusic() {
    setState(() {
      _isMusicEnabled = !_isMusicEnabled;
      if (_isMusicEnabled) {
        _audioPlayer.play();
      } else {
        _audioPlayer.pause();
      }
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose(); // Liberar recursos del AudioPlayer
    super.dispose();
  }

  void _showSettingsDialog(BuildContext context) {
    showAdaptiveDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text(
                'Configuración',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 25),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (_packageInfo != null) buildInfo(context, _packageInfo!),
                    _buildSettingItem(
                      'Música',
                      Icons.music_note,
                      _toggleMusic,
                      switchWidget: Switch(
                        value: _isMusicEnabled,
                        onChanged: (value) {
                          setState(() {
                            _isMusicEnabled = value;
                            if (_isMusicEnabled) {
                              _audioPlayer.play();
                            } else {
                              _audioPlayer.pause();
                            }
                          });
                        },
                      ),
                    ),
                    _buildSettingItem(
                      'Usuario',
                      Icons.account_circle,
                      () {
                        // Lógica para la configuración de usuario
                      },
                      customTitle: Text(
                        widget.sesion != null
                            ? 'usuario: ${widget.sesion!.cedula}'
                            : 'invitado',
                      ),
                    ),
                    buildThemeSelection(context),
                    buildFontSelection(context),
                    _buildSettingItem('Cerrar sesión', Icons.logout, () {
                      _showLogoutDialog(context);
                    }),
                    ButtonBar(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Cerrar'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildSettingItem(
    String title,
    IconData iconData,
    VoidCallback onPressed, {
    Widget? switchWidget,
    Widget? customTitle,
  }) {
    return ListTile(
      leading: Icon(iconData),
      title: customTitle != null ? customTitle : Text(title),
      trailing: switchWidget,
      onTap: onPressed,
    );
  }

  Future<void> _showLogoutDialog(BuildContext context) async {
    _audioPlayer.pause();
    return showLogoutDialog(context, () => performLogout(context));
  }

  void performLogout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        forceMaterialTransparency: true,
        title: Text(widget.sesion != null
            ? 'Bienvenido: ${widget.sesion!.nombres} ${widget.sesion!.apellidos}'
            : 'Has iniciado como: invitado'),
        actions: [
          if (widget.sesion != null) ...[
            IconButton(
              icon: Icon(
                Icons.assignment,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TabBarTask(sesion: widget.sesion!),
                  ),
                );
              },
            ),
          ],
          IconButton(
            icon: Icon(Icons.settings),
            key: _keySettingsButton,
            onPressed: () {
              _showSettingsDialog(context);
            },
          ),
        ],
      ),
      body: Stack(
        fit: StackFit.passthrough,
        children: <Widget>[
          Lottie.asset(
            'assets/lotties/hello.json',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Opacity(
            opacity: 0.8,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                if (widget.sesion != null) const SizedBox(height: 20),
                Expanded(
                  child: GridView(
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 200,
                    ),
                    children: <Widget>[
                      GameSection('Abecedario', AppColors.contentColorBlue,
                          isLoggedIn: widget.sesion != null),
                      GameSection('Animales', AppColors.contentColorGreen,
                          isLoggedIn: widget.sesion != null),
                      GameSection(
                          'Aprende pintando', AppColors.contentColorPurple,
                          isLoggedIn: widget.sesion != null),
                      GameSection('Memoria', AppColors.contentColorOrange,
                          isLoggedIn: widget.sesion != null),
                      GameSection('Frutas', AppColors.contentColorYellow,
                          isLoggedIn: widget.sesion != null),
                      GameSection('Números', AppColors.contentColorPink,
                          isLoggedIn: widget.sesion != null),
                      GameSection('Palabras', AppColors.contentColorGreen,
                          isLoggedIn: widget.sesion != null),

                      /*GameSection('Vegetales', AppColors.contentColorOrange,
                          isLoggedIn: widget.sesion != null),*/
                      GameSection('Rompecabezas', AppColors.contentColorRedBajo,
                          isLoggedIn: widget.sesion != null),
                      GameSection(
                          'Días de la semana', AppColors.contentColorPurple,
                          isLoggedIn: widget.sesion != null),
                      GameSection('Todos los meses', Colors.cyan,
                          isLoggedIn: widget.sesion != null),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
