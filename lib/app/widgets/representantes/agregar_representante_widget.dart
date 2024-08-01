import 'package:flutter/material.dart';

class RegistroFormulario extends StatelessWidget {
  final TextEditingController nombresController;
  final TextEditingController apellidosController;
  final TextEditingController cedulaController;
  final TextEditingController correoController;
  final TextEditingController estadoCivilController;
  final TextEditingController ocupacionController;
  final TextEditingController usuarioController;
  final TextEditingController passController;
  final TextEditingController numberphoneController;
  final String? Function(String?)? nombresValidator;
  final String? Function(String?)? apellidosValidator;
  final String? Function(String?)? cedulaValidator;
  final String? Function(String?)? correoValidator;
  final String? Function(String?)? estadoCivilValidator;
  final String? Function(String?)? ocupacionValidator;
  final String? Function(String?)? numberphoneValidator;
  final String? Function(String?)? usuarioValidator;
  final String? Function(String?)? passValidator;

  const RegistroFormulario({
    Key? key,
    required this.nombresController,
    required this.apellidosController,
    required this.cedulaController,
    required this.correoController,
    required this.estadoCivilController,
    required this.ocupacionController,
    required this.numberphoneController,
    required this.usuarioController,
    required this.passController,
    this.nombresValidator,
    this.apellidosValidator,
    this.cedulaValidator,
    this.correoValidator,
    this.estadoCivilValidator,
    this.ocupacionValidator,
    this.numberphoneValidator,
    this.usuarioValidator,
    this.passValidator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildTextFormField(
          nombresController,
          'Nombres',
          'Ingrese los nombres',
          nombresValidator ?? _requiredValidator,
        ),
        const SizedBox(height: 20),
        _buildTextFormField(
          apellidosController,
          'Apellidos',
          'Ingrese los apellidos',
          apellidosValidator ?? _requiredValidator,
        ),
        const SizedBox(height: 20),
        _buildTextFormField(
          cedulaController,
          'Cédula',
          'Ingrese la cédula',
          cedulaValidator ?? _cedulaValidator,
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 20),
        _buildTextFormField(
          correoController,
          'Correo',
          'Ingrese el correo electrónico',
          correoValidator ?? _emailValidator,
        ),
        const SizedBox(height: 20),
        _buildTextFormField(
          estadoCivilController,
          'Estado Civil',
          'Ingrese el estado civil',
          estadoCivilValidator ?? _requiredValidator,
        ),
        const SizedBox(height: 20),
        _buildTextFormField(
          ocupacionController,
          'Ocupación',
          'Ingrese la ocupación',
          ocupacionValidator ?? _requiredValidator,
        ),
        const SizedBox(height: 20),
        _buildTextFormField(
          numberphoneController,
          'Número de teléfono',
          'Ingrese el número de teléfono',
          numberphoneValidator ?? _phoneValidator,
          keyboardType: TextInputType.phone,
        ),
        const SizedBox(height: 20),
        _buildTextFormField(
          usuarioController,
          'Usuario',
          'Ingrese el nombre de usuario',
          usuarioValidator ?? _requiredValidator,
        ),
        const SizedBox(height: 20),
        _buildTextFormField(
          passController,
          'Contraseña',
          'Ingrese la contraseña',
          passValidator ?? _requiredValidator,
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildTextFormField(TextEditingController controller, String labelText,
      String hintText, String? Function(String?) validator,
      {TextInputType keyboardType = TextInputType.text}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        prefixIcon: _getPrefixIcon(labelText),
      ),
      validator: validator,
      keyboardType: keyboardType,
    );
  }

  Icon? _getPrefixIcon(String labelText) {
    switch (labelText) {
      case 'Nombres':
      case 'Apellidos':
        return Icon(Icons.person);
      case 'Cédula':
        return Icon(Icons.credit_card);
      case 'Correo':
        return Icon(Icons.email);
      case 'Estado Civil':
        return Icon(Icons.account_balance);
      case 'Ocupación':
        return Icon(Icons.work);
      case 'Número de teléfono':
        return Icon(Icons.phone);
      case 'Usuario':
        return Icon(Icons.account_circle);
      case 'Contraseña':
        return Icon(Icons.lock);
      default:
        return null;
    }
  }

  String? _requiredValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Este campo es obligatorio';
    }
    return null;
  }

  String? _emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Este campo es obligatorio';
    }
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value)) {
      return 'Ingrese un correo electrónico válido';
    }
    return null;
  }

  String? _cedulaValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Este campo es obligatorio';
    }
    if (!RegExp(r'^\d+$').hasMatch(value)) {
      return 'Ingrese solo números';
    }
    return null;
  }

  String? _phoneValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Este campo es obligatorio';
    }
    final phoneRegex = RegExp(r'^\+?\d{10,14}$');
    if (!phoneRegex.hasMatch(value)) {
      return 'Ingrese un número de teléfono válido (10-14 dígitos, incluyendo el código de país)';
    }
    return null;
  }
}
