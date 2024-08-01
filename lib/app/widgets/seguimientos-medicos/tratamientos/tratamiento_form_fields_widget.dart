import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TratamientoFormFields extends StatefulWidget {
  final TextEditingController claseDiscapacidadController;
  final TextEditingController descripcionConsultaController;
  final TextEditingController opinionPacienteController;
  final TextEditingController tratamientoPsicologicoController;
  final TextEditingController tratamientoFisicoController;
  final TextEditingController duracionController;
  final DateTime? fechaConsulta;
  final Function(DateTime?) onDateSelected;
  final TextEditingController resultado;

  const TratamientoFormFields({
    super.key,
    required this.claseDiscapacidadController,
    required this.descripcionConsultaController,
    required this.opinionPacienteController,
    required this.tratamientoPsicologicoController,
    required this.tratamientoFisicoController,
    required this.duracionController,
    required this.fechaConsulta,
    required this.onDateSelected,
    required this.resultado,
  });

  @override
  _TratamientoFormFieldsState createState() => _TratamientoFormFieldsState();
}

class _TratamientoFormFieldsState extends State<TratamientoFormFields> {
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now(); // Establecer la fecha y hora actual
    widget.onDateSelected(
        _selectedDate); // Llamar a la función de devolución de llamada con la fecha actual
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        TextFormField(
          controller: widget.claseDiscapacidadController,
          decoration: const InputDecoration(
            labelText: 'Clase de Discapacidad',
            hintText: 'Ingrese la clase de discapacidad',
            prefixIcon: Icon(Icons.accessibility),
          ),
          validator: requiredValidator,
        ),
        const SizedBox(height: 20),
        TextFormField(
          controller: widget.descripcionConsultaController,
          decoration: const InputDecoration(
            labelText: 'Descripción del Tratamiento',
            hintText: 'Ingrese la descripción del tratamiento',
            prefixIcon: Icon(Icons.description),
          ),
          validator: requiredValidator,
          maxLines: null, // Para que el campo se expanda automáticamente
        ),
        const SizedBox(height: 20),
        TextFormField(
          controller: widget.opinionPacienteController,
          decoration: const InputDecoration(
            labelText: 'Opinión del paciente',
            hintText: 'Ingrese la opinión del paciente',
            prefixIcon: Icon(Icons.comment),
          ),
          maxLines: null, // Para que el campo se expanda automáticamente
        ),
        const SizedBox(height: 20),
        TextFormField(
          controller: widget.tratamientoPsicologicoController,
          decoration: const InputDecoration(
            labelText: 'Tratamiento Psicológico',
            hintText: 'Ingrese el tratamiento Psicológico',
            prefixIcon: Icon(Icons.description),
          ),
          maxLines: null, // Para que el campo se expanda automáticamente
        ),
        const SizedBox(height: 20),
        TextFormField(
          controller: widget.tratamientoFisicoController,
          decoration: const InputDecoration(
            labelText: 'Tratamiento Físico',
            hintText: 'Ingrese el tratamiento Físico',
            prefixIcon: Icon(Icons.description),
          ),
          maxLines: null, // Para que el campo se expanda automáticamente
        ),
        const SizedBox(height: 20),
        TextFormField(
          controller: widget.duracionController,
          decoration: const InputDecoration(
            labelText: 'Duración del tratamiento',
            hintText: 'Ingrese la duración del tratamiento',
            prefixIcon: Icon(Icons.timer),
          ),
          validator: requiredValidator,
        ),
        const SizedBox(height: 20),
        TextFormField(
          enabled: false,
          controller: TextEditingController(
            text: DateFormat('kk:mm:ss \n EEE d MMM').format(_selectedDate),
          ),
          decoration: const InputDecoration(
            labelText: 'Fecha de Tratamiento',
            prefixIcon: Icon(Icons.date_range),
          ),
          maxLines: null,
        ),
        const SizedBox(height: 20),
        TextFormField(
          controller: widget.resultado,
          decoration: const InputDecoration(
            labelText: 'Resultado',
            hintText: 'Ingrese el resultado',
            prefixIcon: Icon(Icons.trending_up),
          ),
          maxLines: null, // Para que el campo se expanda automáticamente
        ),
      ],
    );
  }

  String? requiredValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Este campo es obligatorio';
    }
    return null;
  }
}
