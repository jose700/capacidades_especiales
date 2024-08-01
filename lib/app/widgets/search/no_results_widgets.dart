// no_results_widgets.dart

import 'package:flutter/material.dart';

class NoResultsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search, size: 50),
          Text('No hay resultados de búsqueda'),
        ],
      ),
    );
  }
}

class NoTasksAssignedWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.assignment_turned_in_outlined, size: 50),
          Text('Aún no hay tareas asignadas'),
        ],
      ),
    );
  }
}

class NoQuizAssignedWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.quiz, size: 50),
          Text('Aún no hay cuestionarios asignadas'),
        ],
      ),
    );
  }
}

class NoTDataWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.warning, size: 50),
          Text('Lo sentimos aún no hay datos por mostrar'),
        ],
      ),
    );
  }
}

class buildNoNotificationsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_off,
            size: 80,
          ),
          SizedBox(height: 16),
          Text(
            'Aún no hay notificaciones',
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
