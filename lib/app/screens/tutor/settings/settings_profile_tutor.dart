import 'dart:developer';
import 'package:capacidades_especiales/app/models/tutor/tutor_model.dart';
import 'package:capacidades_especiales/app/utils/providers/fuente_providers.dart';
import 'package:capacidades_especiales/app/screens/tutor/settings/editar_profile_tutor_screen.dart';
import 'package:capacidades_especiales/app/widgets/tutor/settings/image_profile.dart';
import 'package:capacidades_especiales/app/services/tutor/service_register_login.dart';
import 'package:capacidades_especiales/app/widgets/tutor/settings/settings_widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SettingsProfileTutor extends StatefulWidget {
  final int idTutor;
  final String usuario;
  const SettingsProfileTutor(this.idTutor, {Key? key, required this.usuario})
      : super(key: key);

  @override
  _SettingsProfileTutorState createState() => _SettingsProfileTutorState();
}

class _SettingsProfileTutorState extends State<SettingsProfileTutor> {
  Tutor? tutorData;
  final registerLoginService = RegisterLoginService();
  late PackageInfo _packageInfo;

  @override
  void initState() {
    super.initState();
    _packageInfo = PackageInfo(
      appName: 'Unknown',
      packageName: 'Unknown',
      version: 'Unknown',
      buildNumber: 'Unknown',
      buildSignature: 'Unknown',
      installerStore: 'Unknown',
    );
    _initPackageInfo();
    cargarPerfilTutor();
    Provider.of<FontSelectionModel>(context, listen: false).loadSelectedFont();
  }

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  Future<void> cargarPerfilTutor() async {
    try {
      final tutor = await registerLoginService.obtenerTutor(widget.idTutor);
      setState(() {
        tutorData = tutor;
      });
    } catch (e) {
      log('Error al cargar el perfil del tutor: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      body: tutorData == null ? _buildLoading() : _buildProfile(),
    );
  }

  Widget _buildLoading() {
    return Center(child: CircularProgressIndicator());
  }

  Widget _buildProfile() {
    return SingleChildScrollView(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ProfileImageWidget(usuario: tutorData!.usuario),
              const SizedBox(height: 20),
              _buildUsernameInput(tutorData!.usuario),
              const SizedBox(height: 20),
              buildThemeSelection(context),
              buildFontSelection(context),
              buildInfo(context, _packageInfo),
              buildLogaut(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUsernameInput(String username) {
    TextEditingController _usernameController =
        TextEditingController(text: username);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: Stack(
              children: [
                TextField(
                  controller: _usernameController,
                  enabled: false, // disable editing directly in this field
                  decoration: InputDecoration(
                    labelText: 'Nombre de usuario',
                    prefixIcon: Icon(Icons.person, color: Colors.grey),
                  ),
                  style: TextStyle(fontSize: 16),
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  bottom: 0,
                  child: IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditProfileScreen(
                            widget.idTutor,
                            usuario: widget.usuario,
                          ),
                        ),
                      );
                    },
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
