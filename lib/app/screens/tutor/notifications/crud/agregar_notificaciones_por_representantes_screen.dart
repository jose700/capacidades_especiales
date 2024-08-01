import 'package:capacidades_especiales/app/models/tutor/login_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:capacidades_especiales/app/models/representantes/representative_model.dart';
import 'package:capacidades_especiales/app/models/tutor/notifications_model.dart';
import 'package:capacidades_especiales/app/services/representante/service_representantes.dart';
import 'package:capacidades_especiales/app/services/tutor/notificaciones_service.dart';
import 'package:capacidades_especiales/app/widgets/tutor/Home/messages/dialogs/login_message.dart';

class AgregarNotificacionPorRepresentanteScreen extends StatefulWidget {
  final String usuario;
  final int idnotificacion;
  final Sesion sesion;
  final Representante representante;

  const AgregarNotificacionPorRepresentanteScreen(
    this.representante, {
    Key? key,
    required this.usuario,
    required this.idnotificacion,
    required this.sesion,
  }) : super(key: key);

  @override
  _AgregarNotificacionScreenState createState() =>
      _AgregarNotificacionScreenState();
}

class _AgregarNotificacionScreenState
    extends State<AgregarNotificacionPorRepresentanteScreen> {
  final _formKey = GlobalKey<FormState>();
  final ServicioRepresentante servicioRepresentante = ServicioRepresentante();
  late Future<List<Representante>> representantes;
  final TextEditingController _mensajeController = TextEditingController();
  final TextEditingController _esEventoController = TextEditingController();
  final TextEditingController _tituloEventoController = TextEditingController();
  final TextEditingController _horaEventoController = TextEditingController();
  final NotificacionesService servicioNotificacion = NotificacionesService();
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    representantes = fetchRepresentantes();
  }

  Future<List<Representante>> fetchRepresentantes() async {
    try {
      final fetchedRepresentantes = await servicioRepresentante
          .obtenerRepresentantesTutor(widget.usuario, widget.sesion.token);
      return fetchedRepresentantes;
    } catch (e) {
      _showErrorSnackbar();
      return [];
    }
  }

  void _showErrorSnackbar() {
    Dialogs.showSnackbarError(context, 'Error al cargar crear la notificación');
  }

  void _showSuccessSnackbar() {
    Dialogs.showSnackbar(context, 'Notificación enviada exitosamente');
  }

  String? requiredValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Este campo es obligatorio';
    }
    return null;
  }

  // Estado inicial del switch
  bool _esEvento = false; // Estado inicial del switch

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
              'Enviar notificación para ${widget.representante.nombres} ${widget.representante.apellidos}')),
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
                      prefixIcon: Icon(Icons.message)),
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
                      prefixIcon: Icon(Icons.title)),
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
                      labelText: 'Hora envío',
                      hintText: 'HH:MM',
                      prefixIcon: Icon(Icons.access_time)),
                  onTap: () async {
                    final selectedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (selectedTime != null) {
                      setState(() {
                        _horaEventoController.text =
                            '${selectedTime.hour}:${selectedTime.minute}';
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
                        idrepresentante: widget.representante.idrepresentante,
                        idestudiante: widget.representante
                            .idestudiante, // Usar el id del estudiante del representante
                        usuarioTutor: widget.usuario,
                        mensaje: _mensajeController.text,
                        fechaEnvio: DateTime.now(),
                        leida: false,
                        esEvento:
                            _esEventoController.text.toLowerCase() == 'true'
                                ? true
                                : false,
                        tituloEvento: _tituloEventoController.text.isEmpty
                            ? null
                            : _tituloEventoController.text,
                        fechaEvento: _selectedDate,
                        horaEvento: _horaEventoController.text.isEmpty
                            ? null
                            : TimeOfDay.fromDateTime(DateTime.parse(
                                '0001-01-01 ${_horaEventoController.text}')),
                      );

                      try {
                        await servicioNotificacion.crearNotificacion(
                            notificacion, widget.sesion.token);
                        _showSuccessSnackbar();
                      } catch (error) {
                        _showErrorSnackbar();
                      }
                    }
                  },
                  child: const Text('Enviar Notificación'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
