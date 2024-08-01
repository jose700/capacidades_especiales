import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_tts/flutter_tts.dart';

import 'package:capacidades_especiales/app/models/estudiantes/playing/fruits/fruits_item_model.dart';
import 'package:capacidades_especiales/app/widgets/estudiantes/game_section/background_lottie/background_lottie_fruits_widget.dart';
import 'package:capacidades_especiales/app/widgets/tutor/Home/grid/AnimatedGridItem.dart';

class FruitsScreen extends StatefulWidget {
  @override
  _FruitsScreenState createState() => _FruitsScreenState();
}

class _FruitsScreenState extends State<FruitsScreen> {
  late List<Fruit> fruitsList;
  final FlutterTts flutterTts = FlutterTts();
  bool isPlaying = false;
  final List<String> fruitIcons = [
    '🍎',
    '🍐',
    '🍊',
    '🍋',
    '🍌',
    '🍉',
    '🍇',
    '🍓',
    '🍒',
    '🍍',
    '🥥',
    '🫐',
    '🫒',
    '🍑',
    '🥝',
    '🍈'
  ];
  late List<Offset> positions;
  Timer? _timer;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fruitsList = [];
    loadFruits();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      generateRandomPositions();
      _timer = Timer.periodic(Duration(seconds: 3), (_) {
        setState(() {
          generateRandomPositions();
        });
      });
    });
  }

  @override
  void dispose() {
    flutterTts.stop();
    _timer?.cancel();
    super.dispose();
  }

  Future<void> loadFruits() async {
    try {
      final String response =
          await rootBundle.loadString('assets/json/fruits_data.json');
      final data = json.decode(response);
      setState(() {
        fruitsList = (data['fruits'] as List)
            .map((fruit) => Fruit.fromJson(fruit))
            .toList();
        isLoading = false;
      });
    } catch (e) {
      print('Error cargando frutas: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> speakLetterAndExample(String nombre) async {
    await flutterTts.setLanguage('es-ES');
    setState(() {
      isPlaying = true;
    });
    await flutterTts.speak(nombre);
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      isPlaying = false;
    });
  }

  void generateRandomPositions() {
    final random = Random();
    positions = List.generate(fruitIcons.length, (index) {
      return Offset(
        random.nextDouble() * (MediaQuery.of(context).size.width - 30),
        random.nextDouble() * (MediaQuery.of(context).size.height - 30),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Frutas'),
      ),
      body: Stack(
        children: [
          FruitsAnimation(),
          ..._buildFruitIcons(),
          Opacity(
            opacity: 0.9,
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : _buildFruitsGrid(),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildFruitIcons() {
    return List.generate(fruitIcons.length, (index) {
      return AnimatedPositioned(
        duration: Duration(seconds: 4),
        left: positions[index].dx,
        top: positions[index].dy,
        child: Text(
          fruitIcons[index],
          style: TextStyle(fontSize: 30),
        ),
      );
    });
  }

  Widget _buildFruitsGrid() {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.8,
      ),
      itemCount: fruitsList.length,
      itemBuilder: (context, index) {
        Fruit item = fruitsList[index];
        return AnimatedGridItem(
          onTap: () {
            if (!isPlaying) {
              speakLetterAndExample(item.nombre.toUpperCase());
            }
          },
          child: Card(
            elevation: 5,
            margin: EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: CachedNetworkImage(
                    imageUrl: item.imagen,
                    width: 100,
                    height: 100,
                    errorWidget:
                        (BuildContext context, String url, dynamic error) {
                      return Image.asset(
                        'assets/img/cp.png',
                        width: 100,
                        height: 100,
                      );
                    },
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  item.nombre.toUpperCase(),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5),
              ],
            ),
          ),
        );
      },
    );
  }
}
