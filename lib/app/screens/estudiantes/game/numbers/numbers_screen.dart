import 'dart:convert';
import 'package:capacidades_especiales/app/models/estudiantes/playing/numbers/number_item_model.dart';
import 'package:capacidades_especiales/app/widgets/estudiantes/game_section/background_lottie/background_lottie.widget.dart';
import 'package:capacidades_especiales/app/widgets/tutor/Home/grid/AnimatedGridItem.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_tts/flutter_tts.dart';

class NumbersScreen extends StatefulWidget {
  @override
  _NumbersScreenState createState() => _NumbersScreenState();
}

class _NumbersScreenState extends State<NumbersScreen> {
  late List<Number> numberList;
  late List<Number> filteredNumbers;
  final FlutterTts flutterTts = FlutterTts();
  bool isPlaying = false; // Estado de reproducción

  @override
  void initState() {
    super.initState();
    numberList = [];
    filteredNumbers = [];
    loadNumberData();
  }

  Future<void> loadNumberData() async {
    try {
      String jsonString =
          await rootBundle.loadString('assets/json/numbers_data.json');
      final jsonData = jsonDecode(jsonString);
      List<dynamic> jsonList = jsonData['numbers'];
      setState(() {
        numberList = jsonList.map((e) => Number.fromJson(e)).toList();
        filteredNumbers =
            List.from(numberList); // Inicialmente muestra todos los números
      });
    } catch (e) {
      print('Error al cargar datos: $e');
      // Puedes mostrar un mensaje de error al usuario aquí
    }
  }

  Future<void> speakNumber(int number) async {
    if (!isPlaying) {
      setState(() {
        isPlaying = true; // Establece que se está reproduciendo
      });
      await flutterTts.setLanguage('es-ES');
      await flutterTts.speak(number.toString());
      flutterTts.setCompletionHandler(() {
        setState(() {
          isPlaying = false; // Establece que terminó la reproducción
        });
      });
    }
  }

  void filterNumbers(String type) {
    setState(() {
      if (type == 'primo') {
        filteredNumbers =
            numberList.where((number) => _isPrime(number.number)).toList();
      } else if (type == 'par') {
        filteredNumbers =
            numberList.where((number) => number.number % 2 == 0).toList();
      } else if (type == 'impar') {
        filteredNumbers =
            numberList.where((number) => number.number % 2 != 0).toList();
      } else {
        filteredNumbers = List.from(numberList);
      }
    });
  }

  bool _isPrime(int number) {
    if (number <= 1) return false;
    if (number <= 3) return true;
    if (number % 2 == 0 || number % 3 == 0) return false;
    int i = 5;
    while (i * i <= number) {
      if (number % i == 0 || number % (i + 2) == 0) return false;
      i += 6;
    }
    return true;
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
          title: Text('Números'),
          actions: [
            PopupMenuButton(
              onSelected: filterNumbers,
              itemBuilder: (BuildContext context) => [
                PopupMenuItem(
                  value: 'all',
                  child: Text('Todos'),
                ),
                PopupMenuItem(
                  value: 'primo',
                  child: Text('Primos'),
                ),
                PopupMenuItem(
                  value: 'par',
                  child: Text('Pares'),
                ),
                PopupMenuItem(
                  value: 'impar',
                  child: Text('Impares'),
                ),
              ],
            ),
          ],
        ),
        body: Stack(children: [
          LearningAnimation(), // Usa el widget para la animación Lottie
          Opacity(
            opacity: 0.9,
            child: filteredNumbers.isEmpty
                ? Center(child: CircularProgressIndicator())
                : GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: filteredNumbers.length,
                    itemBuilder: (context, index) {
                      Number number = filteredNumbers[index];
                      return AnimatedGridItem(
                        onTap: () {
                          if (!isPlaying) {
                            speakNumber(
                                number.number); // Llama a speakNumber al tocar
                          }
                        },
                        child: Card(
                          elevation: 5,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                number.number.toString(),
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 10),
                              Text(
                                'Tipo: ${number.type}',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          )
        ]));
  }
}
