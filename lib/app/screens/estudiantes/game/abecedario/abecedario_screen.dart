import 'dart:async';
import 'dart:convert';
import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_tts/flutter_tts.dart';

import 'package:capacidades_especiales/app/models/estudiantes/playing/alphabet/alphabet_item_model.dart';
import 'package:capacidades_especiales/app/widgets/estudiantes/game_section/background_lottie/background_lottie.widget.dart';
import 'package:capacidades_especiales/app/widgets/tutor/Home/grid/AnimatedGridItem.dart';

class AlphabetScreen extends StatefulWidget {
  @override
  _AlphabetScreenState createState() => _AlphabetScreenState();
}

class _AlphabetScreenState extends State<AlphabetScreen> {
  late List<AlphabetItem> alphabetList;
  final FlutterTts flutterTts = FlutterTts();
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    alphabetList = [];
    loadAlphabetData();
  }

  Future<void> loadAlphabetData() async {
    try {
      String jsonString =
          await rootBundle.loadString('assets/json/alphabet_data.json');
      final jsonData = jsonDecode(jsonString);
      List<dynamic> jsonList = jsonData['alphabet'];
      setState(() {
        alphabetList = jsonList.map((e) => AlphabetItem.fromJson(e)).toList();
      });
    } catch (e) {
      print('Error al cargar datos: $e');
      // Manejar el error de carga de datos, si es necesario
    }
  }

  Future<void> speakLetterAndExample(String letter, String example) async {
    await flutterTts.setLanguage('es-ES');
    setState(() {
      isPlaying = true;
    });

    if (kIsWeb || Platform.isWindows) {
      // En web y Windows, reproducir vocal primero, luego una pausa, y luego el ejemplo
      await flutterTts.speak(letter);
      await flutterTts.awaitSpeakCompletion(true);
      await Future.delayed(
          Duration(milliseconds: 500)); // Pausa de 0.5 segundos
      await flutterTts.speak(example);
    } else {
      // En móviles, reproducir la vocal y el ejemplo uno tras otro
      await flutterTts.speak(letter);
      await flutterTts
          .awaitSpeakCompletion(true); // Esperar a que termine de hablar
      await flutterTts.speak(example);
    }

    setState(() {
      isPlaying = false;
    });
  }

  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Abecedario'),
      ),
      body: Stack(
        children: [
          LearningAnimation(), // Animación de fondo
          Opacity(
            opacity: 0.9,
            child: Stack(
              children: [
                if (alphabetList.isEmpty)
                  Center(child: CircularProgressIndicator()),
                GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: alphabetList.length,
                  itemBuilder: (context, index) {
                    AlphabetItem item = alphabetList[index];
                    return AnimatedGridItem(
                      onTap: () {
                        if (!isPlaying) {
                          speakLetterAndExample(
                              item.letter.toUpperCase(), item.example);
                        }
                      },
                      child: Card(
                        elevation: 5,
                        margin: EdgeInsets.all(10),
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: CachedNetworkImage(
                                    imageUrl: item.image,
                                    width: 100,
                                    height: index.isEven ? 200 : 240,
                                    fit: BoxFit.contain,
                                    errorWidget: (context, url, error) =>
                                        Image.asset(
                                      'assets/img/cp.png',
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                item.letter.toUpperCase(),
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 5),
                              Expanded(
                                child: Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 8.0),
                                  child: Text(
                                    item.example,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
