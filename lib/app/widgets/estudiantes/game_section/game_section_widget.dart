import 'package:capacidades_especiales/app/models/tutor/login_model.dart';
import 'package:capacidades_especiales/app/widgets/tutor/Home/messages/dialogs/login_message.dart';
import 'package:flutter/material.dart';

class GameSection extends StatelessWidget {
  final String title;
  final Color color;
  final bool isLoggedIn;
  final Sesion? sesion;
  const GameSection(this.title, this.color,
      {super.key, required this.isLoggedIn, this.sesion});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        switch (title) {
          case 'Abecedario':
            // Asigna aquí la pantalla para "Abecedario"
            Navigator.pushNamed(context, '/abecedario');
            break;
          case 'Animales':
            // Asigna aquí la pantalla para "Aprender Inglés"
            Navigator.pushNamed(context, '/animals');
            break;
          case 'Aprende pintando':
            // Asigna aquí la pantalla para "Aprende pintando"
            Navigator.pushNamed(context, '/pintar');
            break;
          case 'Números':
            // Asigna aquí la pantalla para "Números"
            Navigator.pushNamed(context, '/numeros');
            break;
          case 'Memoria':
            // Asigna aquí la pantalla para "Números"
            Navigator.pushNamed(context, '/memory');
            break;
          case 'Frutas':
            // Asigna aquí la pantalla para "Frutas"
            Navigator.pushNamed(context, '/frutas');
            break;
          case 'Palabras':
            // Asigna aquí la pantalla para "Frutas"
            Navigator.pushNamed(context, '/palabras');
            break;
          case 'Vegetales':
            // Asigna aquí la pantalla para "Vegetales"
            Navigator.pushNamed(context, '/vegetales');
            break;
          case 'Rompecabezas':
            // Asigna aquí la pantalla para "Canciones Infantiles"
            Navigator.pushNamed(context, '/rompecabezas');
            break;
          case 'Días de la semana':
            // Asigna aquí la pantalla para "Días de la semana"
            Navigator.pushNamed(context, '/dias_semana');
            break;
          case 'Todos los meses':
            // Asigna aquí la pantalla para "Todos los meses"
            Navigator.pushNamed(context, '/meses_año');
            break;

          default:
            // Si no se encuentra la sección, no hacer nada o mostrar un mensaje de error.
            Dialogs.showSnackbarError(
                context, 'Lo sentimos, no se ha encontrado la sessión');
            break;
        }
      },
      child: Container(
        width: 150,
        height: 150,
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(fontSize: 20),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
