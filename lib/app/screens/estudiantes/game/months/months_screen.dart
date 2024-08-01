import 'dart:convert';
import 'package:capacidades_especiales/app/models/estudiantes/playing/months/months_item_model%20copy.dart';
import 'package:capacidades_especiales/app/widgets/estudiantes/game_section/background_lottie/background_lottie.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_tts/flutter_tts.dart';
import 'package:capacidades_especiales/app/widgets/tutor/Home/grid/AnimatedGridItem.dart';

class MonthsScreen extends StatefulWidget {
  @override
  _MonthsScreenState createState() => _MonthsScreenState();
}

class _MonthsScreenState extends State<MonthsScreen> {
  late List<Month> monthsList;
  final FlutterTts flutterTts = FlutterTts();
  bool isPlaying = false; // Estado de reproducción

  @override
  void initState() {
    super.initState();
    monthsList = [];
    loadMonthsData();
  }

  Future<void> loadMonthsData() async {
    try {
      String jsonString =
          await rootBundle.loadString('assets/json/months_data.json');
      final jsonData = jsonDecode(jsonString);
      List<dynamic> jsonList = jsonData['months'];
      setState(() {
        monthsList = jsonList.map((e) => Month.fromJson(e)).toList();
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
        title: Text('Meses del año'),
      ),
      body: Stack(
        children: [
          LearningAnimation(), // Usa el widget para la animación Lottie
          Opacity(
            opacity: 0.9,
            child: monthsList.isEmpty
                ? Center(child: CircularProgressIndicator())
                : GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: monthsList.length,
                    itemBuilder: (context, index) {
                      Month item = monthsList[index];
                      return AnimatedGridItem(
                        onTap: () {
                          if (!isPlaying) {
                            speakExample(
                                item.month); // Llama a speakExample al tocar
                          }
                        },
                        child: Card(
                          elevation: 5,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                item.month.toUpperCase(),
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
