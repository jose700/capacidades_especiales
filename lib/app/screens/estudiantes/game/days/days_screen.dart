import 'dart:convert';
import 'package:capacidades_especiales/app/models/estudiantes/playing/days/days_item_model.dart';
import 'package:capacidades_especiales/app/widgets/estudiantes/game_section/background_lottie/background_lottie.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_tts/flutter_tts.dart';
import 'package:capacidades_especiales/app/widgets/tutor/Home/grid/AnimatedGridItem.dart';

class DaysScreen extends StatefulWidget {
  @override
  _DaysScreenState createState() => _DaysScreenState();
}

class _DaysScreenState extends State<DaysScreen> {
  late List<Day> daysList;
  final FlutterTts flutterTts = FlutterTts();
  bool isPlaying = false; // Estado de reproducción

  @override
  void initState() {
    super.initState();
    daysList = [];
    loadDaysData();
  }

  Future<void> loadDaysData() async {
    try {
      String jsonString =
          await rootBundle.loadString('assets/json/days_data.json');
      final jsonData = jsonDecode(jsonString);
      List<dynamic> jsonList = jsonData['days'];
      setState(() {
        daysList = jsonList.map((e) => Day.fromJson(e)).toList();
      });
    } catch (e) {
      print('Error al cargar datos: $e');
    }
  }

  Future<void> speakExample(String example) async {
    if (!isPlaying) {
      setState(() {
        isPlaying = true; // Establece que se está reproduciendo
      });
      await flutterTts.setLanguage('es-ES');
      await flutterTts.speak(example);
      flutterTts.setCompletionHandler(() {
        setState(() {
          isPlaying = false; // Establece que terminó la reproducción
        });
      });
    }
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
        title: Text('Días de la semana'),
      ),
      body: Stack(
        children: [
          LearningAnimation(), // Usa el widget para la animación Lottie
          Opacity(
            opacity: 0.9,
            child: daysList.isEmpty
                ? Center(child: CircularProgressIndicator())
                : GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: daysList.length,
                    itemBuilder: (context, index) {
                      Day item = daysList[index];
                      return AnimatedGridItem(
                        onTap: () {
                          if (!isPlaying) {
                            speakExample(
                                item.day); // Llama a speakNumber al tocar
                          }
                        },
                        child: Card(
                          elevation: 5,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                item.day.toUpperCase(),
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
          ),
        ],
      ),
    );
  }
}
