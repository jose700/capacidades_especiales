import 'package:flutter/material.dart';
import 'package:capacidades_especiales/app/models/tutor/login_model.dart';
import 'package:capacidades_especiales/app/models/tutor/tutor_model.dart';
import 'package:capacidades_especiales/app/utils/providers/fuente_providers.dart';
import 'package:capacidades_especiales/app/widgets/tutor/settings/image_profile.dart';
import 'package:capacidades_especiales/app/services/tutor/service_register_login.dart';
import 'package:capacidades_especiales/app/widgets/tutor/settings/settings_widgets.dart';
import 'package:provider/provider.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SettingsProfileRepresentante extends StatefulWidget {
  final int idrepresentante;
  final String usuario;
  final Sesion sesion;

  const SettingsProfileRepresentante(this.idrepresentante,
      {Key? key, required this.usuario, required this.sesion})
      : super(key: key);

  @override
  _SettingsProfileTutorState createState() => _SettingsProfileTutorState();
}

class _SettingsProfileTutorState extends State<SettingsProfileRepresentante> {
  Tutor? tutorData;
  final registerLoginService = RegisterLoginService();
  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
    buildSignature: 'Unknown',
    installerStore: 'Unknown',
  );

  bool _obscureText =
      true; // Estado para controlar la visibilidad de la contraseña

  @override
  void initState() {
    super.initState();
    _initPackageInfo();
  }

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<FontSelectionModel>(context, listen: false).loadSelectedFont();
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ProfileImageWidget(
                  usuario: widget.usuario.toString(),
                ),
                const SizedBox(height: 20),
                _buildUsernameInput(widget.usuario.toString()),
                const SizedBox(height: 20),
                _buildPasswordInput(
                    widget.sesion.pass.toString()), // Adding password input
                const SizedBox(height: 20),
                buildThemeSelection(context),
                buildFontSelection(context),
                buildInfo(context, _packageInfo),
                buildLogaut(context),
              ],
            ),
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
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordInput(String password) {
    TextEditingController _passwordController =
        TextEditingController(text: password);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: Stack(
              children: [
                TextField(
                  controller: _passwordController,
                  // disable editing directly in this field
                  decoration: InputDecoration(
                    labelText: 'Contraseña',
                    prefixIcon: Icon(Icons.lock, color: Colors.grey),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureText ? Icons.visibility : Icons.visibility_off,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                    ),
                  ),
                  style: TextStyle(fontSize: 16),
                  obscureText:
                      _obscureText, // controla la visibilidad del texto
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
