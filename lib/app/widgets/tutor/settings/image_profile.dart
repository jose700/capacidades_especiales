import 'package:flutter/material.dart';

class ProfileImageWidget extends StatelessWidget {
  final String usuario;

  const ProfileImageWidget({
    required this.usuario,
  });

  @override
  Widget build(BuildContext context) {
    String getInitials(String name) {
      List<String> nameParts = name.split(" ");
      String initials = "";
      if (nameParts.isNotEmpty) {
        initials = nameParts.map((part) => part[0]).take(2).join();
      }
      return initials;
    }

    return CircleAvatar(
      radius: 90.0,
      backgroundColor: Colors.blue, // Color de fondo del avatar
      child: Text(
        getInitials(usuario),
        style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
      ),
    );
  }
}
