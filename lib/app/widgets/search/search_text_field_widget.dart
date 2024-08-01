import 'package:flutter/material.dart';

class SearchTextField extends StatelessWidget {
  final TextEditingController searchController;

  const SearchTextField({Key? key, required this.searchController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: searchController,
        decoration: const InputDecoration(
          labelText: 'Búsqueda rápida',
          hintText: 'Buscar...',
          prefixIcon: Icon(Icons.search),
        ),
      ),
    );
  }
}
