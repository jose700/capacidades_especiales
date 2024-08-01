import 'package:capacidades_especiales/app/widgets/tutor/Home/home.dart';
import 'package:capacidades_especiales/app/widgets/representantes/home_representante/representante_home.dart';
import 'package:capacidades_especiales/app/widgets/tutor/Home/messages/dialogs/login_message.dart';
import 'package:capacidades_especiales/app/services/tutor/service_register_login.dart';
import 'package:capacidades_especiales/app/widgets/tutor/login_silver_appbar/custom_sliver_appbar.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final RegisterLoginService _loginService = RegisterLoginService();
  late String _username;
  late String _password;
  bool _showPassword = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return CustomScrollView(
            slivers: <Widget>[
              const CustomSliverAppBar(),
              SliverPadding(
                padding: const EdgeInsets.all(20.0),
                sliver: SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      const Text(
                        'Iniciar Sesión',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 30),
                      ),
                      Form(
                        key: _formKey,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: constraints.maxWidth > 600
                                ? constraints.maxWidth * 0.2
                                : 0,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              const SizedBox(height: 20),
                              _buildUsernameTextField(),
                              const SizedBox(height: 20),
                              _buildPasswordTextField(),
                              const SizedBox(height: 30),
                              ElevatedButton(
                                onPressed: () => _submit(context),
                                child: const Text('Iniciar Sesión'),
                              ),
                              const SizedBox(height: 20),
                              _buildRegisterButton(context),
                              const SizedBox(height: 20),
                              _buildStudentsButton(context),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildUsernameTextField() {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: 'Usuario',
        hintText: 'Ingrese su nombre de usuario',
        prefixIcon: Icon(Icons.account_circle),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor ingresa tu usuario';
        }
        return null;
      },
      onSaved: (value) {
        _username = value!;
      },
    );
  }

  Widget _buildPasswordTextField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Contraseña',
        hintText: 'Ingrese su contraseña',
        prefixIcon: const Icon(Icons.lock),
        suffixIcon: GestureDetector(
          onTap: () {
            setState(() {
              _showPassword = !_showPassword;
            });
          },
          child: Icon(_showPassword ? Icons.visibility : Icons.visibility_off),
        ),
      ),
      obscureText: !_showPassword,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor ingresa tu contraseña';
        }
        return null;
      },
      onSaved: (value) {
        _password = value!;
      },
    );
  }

  Widget _buildRegisterButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.pushReplacementNamed(context, '/register');
      },
      child: const Text('Registrarse'),
    );
  }

  void _submit(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      _iniciarSesion(context);
    }
  }

  void _showErrorSnackbar() {
    Dialogs.showSnackbarError(context, 'Error al iniciar sesión');
  }

  void _showSuccessSnackbar(sesion) {
    Dialogs.showSnackbar(context, 'Has iniciado sesión');

    // Verificar el rol de la sesión
    if (sesion.rol == 'tutor') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(
            sesion: sesion,
          ),
        ),
      );
    } else if (sesion.rol == 'representante') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => RepresentanteScreen(
            sesion: sesion,
          ),
        ),
      );
    } else {
      // Manejar cualquier otro caso de rol aquí, si es necesario
      // Por ejemplo, si hay un error o un rol desconocido
    }
  }

  Widget _buildStudentsButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.pushReplacementNamed(context, '/students');
      },
      child: const Text('Soy estudiante'),
    );
  }

  Future<void> _iniciarSesion(BuildContext context) async {
    try {
      final sesion = await _loginService.iniciarSesion(_username, _password);
      _showSuccessSnackbar(sesion);
    } catch (e) {
      _showErrorSnackbar();
    }
  }
}
