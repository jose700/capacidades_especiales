import 'dart:async';
import 'package:capacidades_especiales/app/models/tutor/login_model.dart';
import 'package:capacidades_especiales/app/screens/estudiantes/game/game_screen.dart';
import 'package:capacidades_especiales/app/services/estudiante/service_estudiantes.dart';
import 'package:capacidades_especiales/app/widgets/tutor/Home/messages/dialogs/login_message.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoginStudentScreen extends StatefulWidget {
  const LoginStudentScreen({Key? key}) : super(key: key);

  @override
  _LoginStudentScreenState createState() => _LoginStudentScreenState();
}

class _LoginStudentScreenState extends State<LoginStudentScreen> {
  String welcomeText = '';
  final TextEditingController _cedulaController = TextEditingController();
  bool isLoading = false;
  final ServicioEstudiante _loginService = ServicioEstudiante();
  Sesion? sesion;
  @override
  void initState() {
    super.initState();
    // Iniciar la animación del texto de bienvenida
    animateWelcomeText();
  }

  // Método para animar el texto de bienvenida letra por letra
  void animateWelcomeText() async {
    const originalText = 'Juega mientras aprendes';
    for (var i = 1; i <= originalText.length; i++) {
      await Future.delayed(const Duration(
          milliseconds: 100)); // Controla la velocidad de la animación
      setState(() {
        welcomeText = originalText.substring(0, i);
      });
    }
    // Una vez completada la animación inicial, repetir el texto de forma infinita
    while (true) {
      for (var i = originalText.length - 1; i >= 0; i--) {
        await Future.delayed(const Duration(milliseconds: 100));
        setState(() {
          welcomeText = originalText.substring(0, i);
        });
      }
      for (var i = 1; i <= originalText.length; i++) {
        await Future.delayed(const Duration(milliseconds: 100));
        setState(() {
          welcomeText = originalText.substring(0, i);
        });
      }
    }
  }

  // Método para iniciar sesión del estudiante
  Future<void> _loginEstudiante() async {
    setState(() {
      isLoading = true;
    });

    final cedula = _cedulaController.text;
    if (cedula.isEmpty) {
      setState(() {
        isLoading = false;
      });
      // Muestra un mensaje de error si la cédula está vacía
      Dialogs.showSnackbarError(
          context, 'Por favor, ingresa tu número de cédula');
      return;
    }

    try {
      final sesion = await _loginService.iniciarSesionEstudiante(cedula);
      Navigator.of(context).push(MaterialPageRoute(builder: (context) {
        return GameScreen(
          sesion: sesion,
        );
      }));
      // Por ahora, solo mostramos un mensaje de éxito simulado
      Dialogs.showSnackbar(context, 'Inicio de sesión exitoso');
    } catch (e) {
      Dialogs.showSnackbarError(context, 'Error al iniciar sesión');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            leading: IconButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/login');
              },
              icon: const Icon(
                Icons.arrow_back,
              ),
            ),
            expandedHeight: 350,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                children: <Widget>[
                  Lottie.asset(
                    'assets/lotties/home.json',
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                  Positioned.fill(
                    bottom: 0,
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.transparent, Colors.white],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Container(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: <Widget>[
                      const SizedBox(height: 20),
                      Text(
                        welcomeText, // Usar el texto de bienvenida dinámico
                        style: const TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Recuerda que debes estar registrado para poder iniciar sesión, caso contrario no puedes iniciar sesión.',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: _cedulaController,
                        decoration: const InputDecoration(
                            labelText: 'Ingrese su número de cédula',
                            hintText: 'Por favor ingrese su número de cédula',
                            prefixIcon: Icon(Icons.credit_card)),
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: isLoading ? null : _loginEstudiante,
                        child: isLoading
                            ? CircularProgressIndicator()
                            : Text('Iniciar Sesión'),
                      ),
                      const SizedBox(height: 10), // Espacio entre los botones
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            return GameScreen(
                              sesion: sesion,
                            );
                          })); // Reemplaza '/home' con la ruta adecuada si es necesario
                        },
                        child: Text('Ingresar como invitado'),
                      ),
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

  @override
  void dispose() {
    _cedulaController.dispose();
    super.dispose();
  }
}
