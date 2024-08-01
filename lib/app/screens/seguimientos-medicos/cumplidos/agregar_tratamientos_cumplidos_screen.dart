import 'package:capacidades_especiales/app/models/seguimientos-medicos/tratamientos/compliment_model.dart';
import 'package:capacidades_especiales/app/models/seguimientos-medicos/tratamientos/treatment_model.dart';
import 'package:capacidades_especiales/app/models/tutor/login_model.dart';
import 'package:capacidades_especiales/app/services/seguimientos-medicos/tratamiento/service_cumplido.dart';
import 'package:capacidades_especiales/app/services/seguimientos-medicos/tratamiento/service_no_cumplido.dart';
import 'package:capacidades_especiales/app/services/seguimientos-medicos/tratamiento/service_tratamiento.dart';
import 'package:capacidades_especiales/app/widgets/tutor/Home/messages/dialogs/login_message.dart';

import 'package:capacidades_especiales/app/widgets/seguimientos-medicos/cumplido/agregar_tratamiento_cumplido_form_fields_widget.dart';
import 'package:flutter/material.dart';

class AgregarTratamientosCumplidosScreen extends StatefulWidget {
  final int idtratamiento;
  final int idcumplido;
  final String usuario;
  final int idnocumplido;
  final Sesion sesion;
  const AgregarTratamientosCumplidosScreen({
    Key? key,
    required this.idtratamiento,
    required this.usuario,
    required this.idcumplido,
    required this.idnocumplido,
    required this.sesion,
  }) : super(key: key);

  @override
  _AgregarTratamientosCumplidosScreenState createState() =>
      _AgregarTratamientosCumplidosScreenState();
}

class _AgregarTratamientosCumplidosScreenState
    extends State<AgregarTratamientosCumplidosScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _tratamientocumplido = TextEditingController();
  final TextEditingController _observacion = TextEditingController();
  final ServicioTratamientoNoCumplido servicioTratamientoNoCumplidos =
      ServicioTratamientoNoCumplido();
  final ServicioTratamientoCumplido servicioTratamientoCumplidos =
      ServicioTratamientoCumplido();
  final ServicioTratamiento servicioTratamiento = ServicioTratamiento();
  late Future<List<Tratamiento>> tratamientos = fetchTratamientos();
  DateTime? _fechaConsulta;
  bool _cumplimiento = false;
  String? _selectedEstudiante;

  Future<List<Tratamiento>> fetchTratamientos() async {
    try {
      final fetchTratamientos = await servicioTratamiento
          .obtenerTratamientosTutor(widget.usuario, widget.sesion.token);
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
        context, 'Error al registrar el tratamiento cumplido');
  }

  void _showSuccessSnackbar() {
    Dialogs.showSnackbar(
        context, 'Se ha creado el tratamiento correctamente cumplido');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agregar tratamientos cumplidos'),
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
                                      '${es.estudiante_nombres} ${es.estudiante_apellidos} Cédula: ${es.estudiante_cedula}'),
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
                TratamientoCumplidoFormFields(
                  tratamientoCumplidoController: _tratamientocumplido,
                  observacionController: _observacion,
                  fechaInicio: _fechaConsulta,
                  onDateInicioSelected: (DateTime) {},
                  fechaFin: _fechaConsulta,
                  onDateFinSelected: (DateTime) {},
                  cumplimiento: _cumplimiento,
                  onCumplimientoChanged: (value) {
                    setState(() {
                      _cumplimiento = value;
                    });
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      // Formulario válido, proceder a crear el tratamiento
                      if (_cumplimiento) {
                        TratamientoCumplido nuevoTratamientoCumplido =
                            TratamientoCumplido(
                          idcumplido: widget.idcumplido,
                          idtratamiento: int.parse(_selectedEstudiante!),
                          usuariotutor: widget.usuario,
                          observacion: _observacion.text,
                          fechainicio: _fechaConsulta ?? DateTime.now(),
                          fechafin: _fechaConsulta ?? DateTime.now(),
                          cumplimiento: _cumplimiento,
                        );

                        try {
                          await servicioTratamientoCumplidos.crearCumplido(
                              nuevoTratamientoCumplido, widget.sesion.token);
                          _showSuccessSnackbar(); // Cerrar la pantalla de agregar tratamiento después de guardar
                        } catch (error) {
                          _showErrorSnackbar(); // Mostrar un mensaje de error en caso de que falle la creación del tratamiento
                        }
                      } else {
                        TratamientoCumplido nuevoTratamientoNoCumplido =
                            TratamientoCumplido(
                          idnocumplido: widget.idcumplido,
                          idtratamiento: int.parse(_selectedEstudiante!),
                          usuariotutor: widget.usuario,
                          observacion: _observacion.text,
                          fechainicio: _fechaConsulta ?? DateTime.now(),
                          fechafin: _fechaConsulta ?? DateTime.now(),
                          cumplimiento: _cumplimiento,
                        );

                        try {
                          await servicioTratamientoNoCumplidos.crearNoCumplido(
                              nuevoTratamientoNoCumplido, widget.sesion.token);
                          _showSuccessSnackbar(); // Cerrar la pantalla de agregar tratamiento después de guardar
                        } catch (error) {
                          _showErrorSnackbar(); // Mostrar un mensaje de error en caso de que falle la creación del tratamiento
                        }
                      }
                    }
                  },
                  child: const Text('Guardar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
