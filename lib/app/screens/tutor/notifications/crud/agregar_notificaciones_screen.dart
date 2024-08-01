import 'package:capacidades_especiales/app/models/tutor/login_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:capacidades_especiales/app/models/representantes/representative_model.dart';
import 'package:capacidades_especiales/app/models/tutor/notifications_model.dart';
import 'package:capacidades_especiales/app/services/estudiante/service_estudiantes.dart';
import 'package:capacidades_especiales/app/services/representante/service_representantes.dart';
import 'package:capacidades_especiales/app/services/tutor/notificaciones_service.dart';
import 'package:capacidades_especiales/app/widgets/tutor/Home/messages/dialogs/login_message.dart';

class AgregarNotificacionScreen extends StatefulWidget {
  final int idTutor;
  final String usuario;
  final int idnotificacion;
  final Sesion sesion;
  final List<Representante> representantes;
  const AgregarNotificacionScreen(
    this.idTutor, {
    Key? key,
    required this.usuario,
    required this.idnotificacion,
    required this.sesion,
    required this.representantes,
  }) : super(key: key);

  @override
  _AgregarNotificacionScreenState createState() =>
      _AgregarNotificacionScreenState();
}

class _AgregarNotificacionScreenState extends State<AgregarNotificacionScreen> {
  final _formKey = GlobalKey<FormState>();
  final ServicioEstudiante servicioEstudiante = ServicioEstudiante();
  final ServicioRepresentante servicioRepresentante = ServicioRepresentante();
  final TextEditingController _mensajeController = TextEditingController();
  final TextEditingController _tituloEventoController = TextEditingController();
  final TextEditingController _horaEventoController = TextEditingController();
  final NotificacionesService servicioNotificacion = NotificacionesService();
  late DateTime _selectedDate;

  // Seleccionar el representante automáticamente al iniciar
  late Representante _selectedRepresentante;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _selectedRepresentante =
        widget.representantes.first; // Suponiendo que la lista no está vacía

    // Puedes hacer fetch de los estudiantes si es necesario
    // estudiantes = fetchEstudiantes();
  }

  void _showErrorSnackbar() {
    Dialogs.showSnackbarError(context, 'Error al cargar crear la notificación');
  }

  void _showSuccessSnackbar() {
    Dialogs.showSnackbar(context, 'Notificación guardada exitosamente');
  }

  String? requiredValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Este campo es obligatorio';
    }
    return null;
  }

  bool _esEvento = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Enviar notificciones para todos los representantes')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 20),
                TextFormField(
                  controller: _mensajeController,
                  maxLines: null,
                  decoration: InputDecoration(
                    labelText: 'Mensaje',
                    hintText: 'Ingrese el mensaje de la notificación',
                    prefixIcon: Icon(Icons.message),
                  ),
                  validator: requiredValidator,
                ),
                const SizedBox(height: 20),
                SwitchListTile(
                  title: Text('¿Es un evento?'),
                  value: _esEvento,
                  onChanged: (value) {
                    setState(() {
                      _esEvento = value;
                    });
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _tituloEventoController,
                  validator: requiredValidator,
                  decoration: InputDecoration(
                    labelText: 'Título del Evento',
                    hintText: 'Ingrese el título del evento si aplica',
                    prefixIcon: Icon(Icons.title),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  enabled: false,
                  controller: TextEditingController(
                    text: DateFormat('kk:mm:ss \n EEE d MMM')
                        .format(_selectedDate),
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Fecha del evento',
                    prefixIcon: Icon(Icons.date_range),
                  ),
                  onTap: () async {
                    final selectedDate = await showDatePicker(
                      context: context,
                      initialDate: _selectedDate,
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2100),
                    );
                    if (selectedDate != null) {
                      setState(() {
                        _selectedDate = selectedDate;
                      });
                    }
                  },
                  maxLines: null,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _horaEventoController,
                  validator: requiredValidator,
                  decoration: InputDecoration(
                    labelText: 'Hora del Evento',
                    hintText: 'HH:MM',
                    prefixIcon: Icon(Icons.access_time),
                  ),
                  onTap: () async {
                    final selectedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (selectedTime != null) {
                      setState(() {
                        _horaEventoController.text =
                            '${selectedTime.hour.toString().padLeft(2, '0')}:${selectedTime.minute.toString().padLeft(2, '0')}';
                      });
                    }
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState?.validate() ?? false) {
                      Notificacion notificacion = Notificacion(
                        idnotificacion: widget.idnotificacion,
                        idtutor: widget.sesion.idtutor ?? 0,
                        idrepresentante: _selectedRepresentante.idrepresentante,
                        idestudiante: _selectedRepresentante.idestudiante,
                        usuarioTutor: widget.usuario,
                        mensaje: _mensajeController.text,
                        fechaEnvio: DateTime.now(),
                        leida: false,
                        esEvento: _esEvento,
                        tituloEvento: _tituloEventoController.text.isEmpty
                            ? null
                            : _tituloEventoController.text,
                        fechaEvento: _selectedDate,
                        horaEvento: _horaEventoController.text.isNotEmpty
                            ? TimeOfDay(
                                hour: int.parse(
                                    _horaEventoController.text.split(':')[0]),
                                minute: int.parse(
                                    _horaEventoController.text.split(':')[1]),
                              )
                            : null,
                      );

                      try {
                        await servicioNotificacion
                            .enviarNotificacionATodosLosRepresentantes(
                                widget.usuario,
                                notificacion,
                                widget.sesion.token);
                        _showSuccessSnackbar();
                      } catch (error) {
                        _showErrorSnackbar();
                      }
                    }
                  },
                  child: const Text(
                      'Enviar Notificación a Todos los representantes'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
