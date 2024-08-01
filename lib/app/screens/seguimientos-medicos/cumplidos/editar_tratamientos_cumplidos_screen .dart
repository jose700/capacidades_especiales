import 'package:capacidades_especiales/app/models/seguimientos-medicos/tratamientos/compliment_model.dart';
import 'package:capacidades_especiales/app/models/seguimientos-medicos/tratamientos/treatment_model.dart';
import 'package:capacidades_especiales/app/models/tutor/login_model.dart';
import 'package:capacidades_especiales/app/services/seguimientos-medicos/tratamiento/service_cumplido.dart';
import 'package:capacidades_especiales/app/services/seguimientos-medicos/tratamiento/service_no_cumplido.dart';
import 'package:capacidades_especiales/app/services/seguimientos-medicos/tratamiento/service_tratamiento.dart';
import 'package:capacidades_especiales/app/widgets/tutor/Home/messages/dialogs/login_message.dart';
import 'package:capacidades_especiales/app/widgets/seguimientos-medicos/cumplido/editar_tratamiento_cumplido_form_fields_widget.dart';

import 'package:flutter/material.dart';

class ActualizarTratamientosCumplidosScreen extends StatefulWidget {
  final TratamientoCumplido cumplidos;
  final Sesion sesion;
  const ActualizarTratamientosCumplidosScreen(this.cumplidos,
      {Key? key, required this.sesion})
      : super(key: key);

  @override
  _ActualizarTratamientosCumplidosScreenState createState() =>
      _ActualizarTratamientosCumplidosScreenState();
}

class _ActualizarTratamientosCumplidosScreenState
    extends State<ActualizarTratamientosCumplidosScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _tratamientocumplido = TextEditingController();
  final TextEditingController _observacion = TextEditingController();
  late Future<List<Tratamiento>> tratamientos;
  DateTime? _fechaInicio;
  DateTime? _fechaFin;
  bool _cumplimiento = false;
  String? _selectedEstudiante;

  @override
  void initState() {
    super.initState();
    _observacion.text = widget.cumplidos.observacion;
    _fechaInicio = widget.cumplidos.fechainicio;
    _fechaFin = widget.cumplidos.fechafin;
    _cumplimiento = widget.cumplidos.cumplimiento ?? false;

    // Inicializar la lista de tratamientos si es necesario
    tratamientos = fetchTratamientos();
  }

  Future<List<Tratamiento>> fetchTratamientos() async {
    try {
      final fetchTratamientos = await ServicioTratamiento()
          .obtenerTratamientosTutor(
              widget.cumplidos.usuariotutor, widget.sesion.token);
      return fetchTratamientos;
    } catch (e) {
      _showErrorSnackbar();
      return [];
    }
  }

  String? requiredValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Este campo es obligatorio';
    }
    return null;
  }

  void _showErrorSnackbar() {
    Dialogs.showSnackbarError(
        context, 'Error al actualizar el tratamiento cumplido');
  }

  void _showSuccessSnackbar() {
    Dialogs.showSnackbar(
        context, 'Se ha actualizado el tratamiento correctamente');
  }

  void _updateData() async {
    if (_formKey.currentState!.validate()) {
      if (_cumplimiento) {
        // Actualizar usando el servicio de tratamientos cumplidos
        TratamientoCumplido actualizadoTratamiento = TratamientoCumplido(
          idcumplido: widget.cumplidos.idcumplido,
          idtratamiento: int.parse(_selectedEstudiante!),
          usuariotutor: widget.cumplidos.usuariotutor,
          observacion: _observacion.text,
          fechainicio: _fechaInicio ?? DateTime.now(),
          fechafin: _fechaFin ?? DateTime.now(),
          cumplimiento: _cumplimiento,
        );

        try {
          await ServicioTratamientoCumplido().actualizarTratamiento(
              widget.cumplidos.idcumplido ?? 0,
              actualizadoTratamiento,
              widget.sesion.token);
          _showSuccessSnackbar(); // Mostrar mensaje de éxito
        } catch (error) {
          _showErrorSnackbar(); // Mostrar mensaje de error
        }
      } else {
        // Guardar usando el servicio de tratamientos no cumplidos
        TratamientoCumplido nuevoTratamientoNoCumplido = TratamientoCumplido(
          idnocumplido: widget.cumplidos.idnocumplido ?? 0,
          idtratamiento: int.parse(_selectedEstudiante!),
          usuariotutor: widget.cumplidos.usuariotutor,
          observacion: _observacion.text,
          fechainicio: _fechaInicio ?? DateTime.now(),
          fechafin: _fechaFin ?? DateTime.now(),
        );

        try {
          await ServicioTratamientoNoCumplido()
              .crearNoCumplido(nuevoTratamientoNoCumplido, widget.sesion.token);
          // Mostrar mensaje de éxito

          // Eliminar el tratamiento cumplido existente
          await ServicioTratamientoCumplido().eliminarTratamientoCumplido(
            widget.cumplidos.idcumplido.toString(),
            widget.sesion.token,
          );
          _showSuccessSnackbar(); // Mostrar mensaje de éxito
        } catch (error) {
          _showErrorSnackbar(); // Mostrar mensaje de error
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Actualizar tratamiento'),
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                FutureBuilder<List<Tratamiento>>(
                  future: tratamientos,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Text('No hay tratamientos disponibles');
                    } else {
                      final tratamientos = snapshot.data!;
                      return DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                            labelText: 'Seleccione tratamiento',
                            prefixIcon: Icon(Icons.medical_information)),
                        items: tratamientos
                            .map((es) => DropdownMenuItem(
                                  value: es.idtratamiento.toString(),
                                  child: Text('Datos: '
                                      '${es.tratamientopsicologico} ${es.estudiante_nombres} Cédula: ${es.estudiante_cedula}'),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedEstudiante = value;
                          });
                        },
                        validator: requiredValidator,
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                        ),
                        dropdownColor:
                            Theme.of(context).scaffoldBackgroundColor,
                      );
                    }
                  },
                ),
                EditarTratamientoCumplidoFormFields(
                  tratamientoCumplidoController: _tratamientocumplido,
                  observacionController: _observacion,
                  fechaInicio: _fechaInicio,
                  onDateInicioSelected: (DateTime) {},
                  fechaFin: _fechaFin,
                  onDateFinSelected: (DateTime) {},
                  cumplimiento: _cumplimiento,
                  onCumplimientoChanged: (bool cumplimiento) {
                    setState(() {
                      _cumplimiento = cumplimiento;
                    });
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _updateData,
                  child: const Text('Actualizar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
