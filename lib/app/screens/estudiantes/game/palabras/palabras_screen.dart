import 'package:capacidades_especiales/app/widgets/tutor/Home/messages/dialogs/login_message.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter_tts/flutter_tts.dart';

class WordGameScreen extends StatefulWidget {
  final String word;

  WordGameScreen({required this.word});

  @override
  _WordGameScreenState createState() => _WordGameScreenState();
}

class _WordGameScreenState extends State<WordGameScreen> {
  List<String> shuffledLetters = [];
  late FlutterTts flutterTts;
  bool isSpeaking = false;
  bool isWordFormed = false;

  @override
  void initState() {
    super.initState();
    _shuffleLetters();
    flutterTts = FlutterTts();
  }

  void _shuffleLetters() {
    setState(() {
      shuffledLetters = List.from(widget.word.split(''))..shuffle(Random());
      isWordFormed = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Juego de Palabras'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            IconButton(
              icon: Icon(
                Icons.volume_up,
                color: isSpeaking ? Colors.green : Colors.red,
              ),
              onPressed: _speakPhrase,
              iconSize: 80,
            ),
            SizedBox(height: 20.0),
            Text(
              'Palabra a formar: ${widget.word}',
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20.0),
            Wrap(
              alignment: WrapAlignment.center,
              children: shuffledLetters.asMap().entries.map((entry) {
                int index = entry.key;
                String letter = entry.value;
                return Draggable<String>(
                  data: letter,
                  child: DragTarget<String>(
                    builder: (context, candidateData, rejectedData) {
                      return LetterBox(letter: letter);
                    },
                    onWillAcceptWithDetails: (data) {
                      return data != letter;
                    },
                    onAccept: (data) async {
                      await flutterTts.speak(data);
                      setState(() {
                        int fromIndex = shuffledLetters.indexOf(data);
                        String temp = shuffledLetters[index];
                        shuffledLetters[index] = shuffledLetters[fromIndex];
                        shuffledLetters[fromIndex] = temp;

                        if (shuffledLetters.join() == widget.word) {
                          setState(() {
                            isWordFormed = true;
                          });
                          Dialogs.showSnackbar(context,
                              'Felicidades: Formaste la palabra correctamente.');
                        }
                      });
                    },
                  ),
                  feedback: Material(
                    color: Colors.transparent,
                    child: LetterBox(letter: letter),
                  ),
                  childWhenDragging: LetterBox(letter: ''),
                );
              }).toList(),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: _resetGame,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
              ),
              child: Text(
                'Reiniciar',
                style: TextStyle(fontSize: 18.0),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _resetGame() {
    _shuffleLetters();
  }

  Future<void> _speakPhrase() async {
    setState(() {
      isSpeaking = true;
    });

    await flutterTts.speak("La palabra a formar es ${widget.word}");

    setState(() {
      isSpeaking = false;
    });
  }
}

class LetterBox extends StatelessWidget {
  final String letter;

  const LetterBox({required this.letter});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(4.0),
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: letter.isEmpty ? Colors.grey : Colors.blueAccent,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Text(
        letter,
        style: TextStyle(
          fontSize: 24.0,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}
