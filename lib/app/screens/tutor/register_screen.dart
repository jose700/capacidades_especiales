import 'package:capacidades_especiales/app/widgets/tutor/login_silver_appbar/custom_sliver_appbar.dart';
import 'package:flutter/material.dart';
import 'package:capacidades_especiales/app/widgets/tutor/Home/messages/dialogs/login_message.dart';
import 'package:capacidades_especiales/app/services/tutor/service_register_login.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nombresController = TextEditingController();
  final TextEditingController _apellidosController = TextEditingController();
  final TextEditingController _cedulaController = TextEditingController();
  final TextEditingController _correoController = TextEditingController();
  final TextEditingController _usuarioController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  String rol = "tutor";
  bool _obscureText = true;
  final _formKey = GlobalKey<FormState>();

  void _showErrorSnackbar() {
    Dialogs.showSnackbarError(context, 'El número de cédula ya está en uso');
  }

  void _showSuccessSnackbar() {
    Dialogs.showSnackbar(context, 'Registro exitoso');
  }

  void _showGenericErrorSnackbar() {
    Dialogs.showSnackbarError(
        context, 'Ocurrió un error inesperado. Por favor, inténtelo de nuevo.');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: CustomScrollView(
        slivers: <Widget>[
          const CustomSliverAppBar(),
          SliverPadding(
            padding: const EdgeInsets.all(8.0),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  const Text(
                    'Registrarse',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 30),
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        _buildTextFieldWithIcon(
                          controller: _nombresController,
                          labelText: 'Nombres',
                          hintText: 'Ingrese sus nombres',
                          icon: Icons.person,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Ingrese sus nombres';
                            } else if (value.length < 4 || value.length > 20) {
                              return 'Ingrese entre 4 y 20 caracteres';
                            }
                            return null;
                          },
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        const SizedBox(height: 20),
                        _buildTextFieldWithIcon(
                          controller: _apellidosController,
                          labelText: 'Apellidos',
                          hintText: 'Ingrese sus apellidos',
                          icon: Icons.person_outline,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Ingrese sus apellidos';
                            }
                            return null;
                          },
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        const SizedBox(height: 20),
                        _buildTextFieldWithIcon(
                          controller: _cedulaController,
                          labelText: 'Cédula',
                          hintText: 'Ingrese su número de cédula',
                          icon: Icons.credit_card,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Ingrese su número de cédula';
                            } else if (value.length != 10) {
                              return 'La cédula debe tener exactamente 10 dígitos';
                            } else if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                              return 'La cédula solo puede contener números';
                            }
                            return null;
                          },
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        const SizedBox(height: 20),
                        _buildTextFieldWithIcon(
                          controller: _correoController,
                          labelText: 'Correo',
                          hintText: 'Ingrese su correo electrónico',
                          icon: Icons.email,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Ingrese su correo electrónico';
                            } else if (!RegExp(
                                    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
                                .hasMatch(value)) {
                              return 'Por favor ingrese un correo electrónico válido';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        _buildTextFieldWithIcon(
                          controller: _usuarioController,
                          labelText: 'Usuario',
                          hintText: 'Ingrese su nombre de usuario',
                          icon: Icons.account_circle,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Ingrese su nombre de usuario';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        _buildTextFieldWithIcon(
                          controller: _passController,
                          labelText: 'Contraseña',
                          hintText: 'Ingrese su contraseña',
                          icon: Icons.lock,
                          obscureText: _obscureText,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureText
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscureText = !_obscureText;
                              });
                            },
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Ingrese su contraseña';
                            } else if (value.length < 8 || value.length > 10) {
                              return 'Ingrese entre 8 y 10 caracteres';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              await _crearRegistro(context);
                            } else {
                              bool allFieldsEmpty =
                                  _nombresController.text.isEmpty &&
                                      _apellidosController.text.isEmpty &&
                                      _cedulaController.text.isEmpty &&
                                      _correoController.text.isEmpty &&
                                      _usuarioController.text.isEmpty &&
                                      _passController.text.isEmpty;

                              if (allFieldsEmpty) {
                                print('Todos los campos son obligatorios');
                              }
                            }
                          },
                          child: const Text('Registrarse'),
                        ),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(context, '/login');
                          },
                          child: const Text('Iniciar sesión'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextFieldWithIcon({
    TextEditingController? controller,
    String? labelText,
    IconData? icon,
    bool obscureText = false,
    Widget? suffixIcon,
    String? Function(String?)? validator,
    BorderRadius? borderRadius,
    required String hintText,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      validator: validator,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        prefixIcon: Icon(icon),
        suffixIcon: suffixIcon,
      ),
    );
  }

  Future<void> _crearRegistro(BuildContext context) async {
    final String nombres = _nombresController.text;
    final String apellidos = _apellidosController.text;
    final String cedula = _cedulaController.text;
    final String correo = _correoController.text;
    final String usuario = _usuarioController.text;
    final String pass = _passController.text;

    print('Datos del registro:');
    print('Nombres: $nombres');
    print('Apellidos: $apellidos');
    print('Cédula: $cedula');
    print('Correo: $correo');
    print('Usuario: $usuario');
    // No imprimir la contraseña por razones de seguridad

    try {
      print('Llamando al servicio para crear registro...');
      // Llamar al servicio para crear el registro
      await RegisterLoginService().crearRegistro({
        'nombres': nombres,
        'apellidos': apellidos,
        'cedula': cedula,
        'correo': correo,
        'usuario': usuario,
        'pass': pass,
        'rol': rol
      });
      _showSuccessSnackbar();
    } catch (e) {
      print('Error al crear registro: $e');
      if (e.toString().contains('El número de cédula ya está en uso')) {
        _showErrorSnackbar();
      } else {
        _showGenericErrorSnackbar();
      }
    }
  }
}
