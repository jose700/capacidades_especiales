import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:capacidades_especiales/app/widgets/search/search_text_field_widget.dart';
import 'package:capacidades_especiales/app/models/estudiantes/playing/animals/animals_item_model.dart';
import 'package:capacidades_especiales/app/widgets/estudiantes/game/animals_widget/animal_emoji.dart';
import 'package:capacidades_especiales/app/widgets/estudiantes/game/animals_widget/cards.dart';

class AnimalScreen extends StatefulWidget {
  const AnimalScreen({Key? key}) : super(key: key);

  @override
  State<AnimalScreen> createState() => _AnimalScreenState();
}

class _AnimalScreenState extends State<AnimalScreen> {
  late List<Animal> animalsList = [];
  late List<Animal> filteredAnimalsList = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadAnimalsData();
    _searchController.addListener(_filterAnimals);
  }

  Future<void> loadAnimalsData() async {
    try {
      String jsonString =
          await rootBundle.loadString('assets/json/animals_data.json');
      final jsonData = jsonDecode(jsonString);
      List<dynamic> jsonList = jsonData['animales'];
      setState(() {
        animalsList =
            jsonList.map((e) => Animal.fromJson(e)).cast<Animal>().toList();
        filteredAnimalsList =
            animalsList; // Inicialmente, mostrar todos los animales
      });
    } catch (e) {
      print('Error al cargar datos: $e');
      // Puedes mostrar un mensaje de error al usuario aquí
    }
  }

  void _filterAnimals() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      filteredAnimalsList = animalsList.where((animal) {
        return animal.nombre.toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterAnimals);
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sección animales'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SearchTextField(searchController: _searchController),
          const SizedBox(height: 20),
          const Text(
            'Descubrir',
            style: TextStyle(
              fontSize: 27,
              letterSpacing: 5,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 5),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: filteredAnimalsList
                          .map((animal) => MyCard(animal: animal))
                          .toList(),
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    'Explora la vida salvaje antigua',
                    style: TextStyle(
                      fontSize: 20,
                      letterSpacing: 5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 100,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: filteredAnimalsList.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Animogi(animal: filteredAnimalsList[index]),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
