import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TratamientoCumplidoFormFields extends StatefulWidget {
  final TextEditingController tratamientoCumplidoController;
  final TextEditingController observacionController;
  final DateTime? fechaInicio;
  final DateTime? fechaFin;
  final Function(DateTime?) onDateInicioSelected;
  final Function(DateTime?) onDateFinSelected;
  final bool cumplimiento; // Nuevo campo para cumplimiento
  final Function(bool)
      onCumplimientoChanged; // Callback para cambios en cumplimiento

  const TratamientoCumplidoFormFields({
    Key? key,
    required this.tratamientoCumplidoController,
    required this.observacionController,
    required this.fechaInicio,
    required this.fechaFin,
    required this.onDateInicioSelected,
    required this.onDateFinSelected,
    required this.cumplimiento, // Inicializar el campo cumplimiento
    required this.onCumplimientoChanged, // Inicializar el callback de cumplimiento
  }) : super(key: key);

  @override
  _TratamientoFormFieldsState createState() => _TratamientoFormFieldsState();
}

class _TratamientoFormFieldsState extends State<TratamientoCumplidoFormFields> {
  late DateTime _selectedFechaInicio;
  late DateTime _selectedFechaFin;
  late bool _cumplimiento; // Variable para el estado de cumplimiento

  @override
  void initState() {
    super.initState();
    _selectedFechaInicio = widget.fechaInicio ?? DateTime.now();
    _selectedFechaFin = widget.fechaFin ?? DateTime.now();
    _cumplimiento =
        widget.cumplimiento; // Inicializar el estado del cumplimiento
    widget.onDateInicioSelected(_selectedFechaInicio);
    widget.onDateFinSelected(_selectedFechaFin);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        TextFormField(
          controller: widget.observacionController,
          decoration: const InputDecoration(
            labelText: 'Observación',
            hintText: 'Ingrese la observación',
            prefixIcon: Icon(Icons.description),
          ),
          validator: requiredValidator,
          maxLines: null, // Para que el campo se expanda automáticamente
        ),
        const SizedBox(height: 20),
        InkWell(
          onTap: () {
            _selectFechaInicio(context);
          },
          child: InputDecorator(
            decoration: const InputDecoration(
              labelText: 'Fecha de Inicio',
              prefixIcon: Icon(Icons.date_range),
            ),
            child: Text(
              DateFormat('kk:mm:ss \n EEE d MMM').format(_selectedFechaInicio),
            ),
          ),
        ),
        const SizedBox(height: 20),
        InkWell(
          onTap: () {
            _selectFechaFin(context);
          },
          child: InputDecorator(
            decoration: const InputDecoration(
              labelText: 'Fecha Fin',
              prefixIcon: Icon(Icons.date_range),
            ),
            child: Text(
              DateFormat('kk:mm:ss \n EEE d MMM').format(_selectedFechaFin),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          const Text('Cumplió con el tratamiento'),
          Row(
            children: [
              Text(_cumplimiento ? 'Sí' : 'No'),
              Switch(
                value: _cumplimiento,
                onChanged: (bool value) {
                  setState(() {
                    _cumplimiento = value;
                    widget.onCumplimientoChanged(_cumplimiento);
                  });
                },
              ),
            ],
          )
        ])
      ],
    );
  }

  Future<void> _selectFechaInicio(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedFechaInicio,
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedFechaInicio)
      setState(() {
        _selectedFechaInicio = picked;
        widget.onDateInicioSelected(_selectedFechaInicio);
      });
  }

  Future<void> _selectFechaFin(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedFechaFin,
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedFechaFin)
      setState(() {
        _selectedFechaFin = picked;
        widget.onDateFinSelected(_selectedFechaFin);
      });
  }

  String? requiredValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Este campo es obligatorio';
    }
    return null;
  }
}
