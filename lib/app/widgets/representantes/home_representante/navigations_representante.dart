import 'package:flutter/material.dart';

class NavigationsBarRepresentante extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTabSelected;
  final Color? iconColor;
  final bool
      hasNotifications; // Nuevo atributo para indicar si hay nuevas notificaciones

  const NavigationsBarRepresentante({
    Key? key,
    required this.selectedIndex,
    required this.onTabSelected,
    this.iconColor,
    this.hasNotifications = false, // Por defecto no hay nuevas notificaciones
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(),
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Color(0xf000000),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 7), // Cambia la sombra del NavigationBar
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.home),
            color: selectedIndex == 0 ? iconColor : null, // Color condicional
            onPressed: () {
              onTabSelected(0); // Al seleccionar el ícono de inicio
            },
          ),
          IconButton(
            icon: Icon(Icons.settings),
            color: selectedIndex == 1 ? iconColor : null, // Color condicional
            onPressed: () {
              onTabSelected(1); // Al seleccionar el ícono de perfil
            },
          ),
          IconButton(
            icon: Icon(Icons.leaderboard),
            color: selectedIndex == 2 ? iconColor : null, // Color condicional
            onPressed: () {
              onTabSelected(2); // Al seleccionar el ícono de ajustes
            },
          ),
          IconButton(
            icon: Icon(Icons.notification_add),
            color: hasNotifications
                ? Colors.red
                : (selectedIndex == 3 ? iconColor : null),
            onPressed: () {
              onTabSelected(3); // Al seleccionar el ícono de notificaciones
            },
          ),
        ],
      ),
    );
  }
}
