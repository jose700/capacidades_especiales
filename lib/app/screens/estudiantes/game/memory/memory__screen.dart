import 'package:capacidades_especiales/app/screens/estudiantes/game/memory/list_data_memory_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class MemoryGameScreen extends StatelessWidget {
  final String category;
  final String level;

  MemoryGameScreen({required this.category, required this.level});

  @override
  Widget build(BuildContext context) {
    final List<String> emojis = _getEmojisForCategory(category);
    final List<String> dataToShow = _getDataForLevel(level, emojis);

    return Scaffold(
      appBar: AppBar(
        title: Text('Juego de Memoria - $category - $level'),
      ),
      body: MemoryGameWidget(
        data: dataToShow,
        onGameComplete: () =>
            _speak('¡Felicidades! Has completado el juego con éxito.'),
        onMismatch: () => _speak('Suerte para la próxima.'),
        onMatch: () => _speak('¡Excelente!'),
      ),
    );
  }

  List<String> _getEmojisForCategory(String category) {
    switch (category) {
      case 'Frutas':
        return fruits;
      case 'Animales':
        return animals;
      case 'Transporte':
        return transport;
      case 'Emojis':
        return emotes;
      case 'Banderas':
        return banderas;
      default:
        return fruits; // Default to fruits
    }
  }

  List<String> _getDataForLevel(String level, List<String> emojis) {
    int count;
    switch (level) {
      case 'Fácil':
        count = 8;
        break;
      case 'Medio':
        count = 16;
        break;
      case 'Difícil':
        count = emojis.length;
        break;
      default:
        count = 6; // Default to 6 items for 'Fácil'
    }
    return _getRandomSubset(emojis, count);
  }

  Future<void> _speak(String message) async {
    final FlutterTts flutterTts = FlutterTts();
    await flutterTts.setLanguage('es-US');
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.setVolume(1.0);
    await flutterTts.setPitch(1.0);
    await flutterTts.speak(message);
  }

  List<String> _getRandomSubset(List<String> list, int count) {
    if (list.length < count) {
      // Handle the case where there are not enough emojis
      return List.from(list); // or handle as needed
    }

    list.shuffle();
    List<String> result = [];
    Map<String, int> emojiCount = {};

    for (var emoji in list) {
      if (emojiCount.containsKey(emoji)) {
        emojiCount[emoji] = emojiCount[emoji]! + 1;
      } else {
        emojiCount[emoji] = 1;
      }
    }

    for (var emoji in list) {
      if (result.length < count) {
        if (emojiCount[emoji]! < 2) {
          result.add(emoji);
          result.add(emoji);
          emojiCount[emoji] = emojiCount[emoji]! + 2;
        } else if (emojiCount[emoji]! >= 2 &&
            result.where((e) => e == emoji).length < 2) {
          result.add(emoji);
          result.add(emoji);
          emojiCount[emoji] = emojiCount[emoji]! + 2;
        }
      }
    }

    // Ensure result has at least 'count' items
    return result.length > count ? result.sublist(0, count) : result;
  }
}

class MemoryGameWidget extends StatefulWidget {
  final List<String> data;
  final VoidCallback onGameComplete;
  final VoidCallback onMismatch;
  final VoidCallback onMatch;

  MemoryGameWidget({
    required this.data,
    required this.onGameComplete,
    required this.onMismatch,
    required this.onMatch,
  });

  @override
  _MemoryGameWidgetState createState() => _MemoryGameWidgetState();
}

class _MemoryGameWidgetState extends State<MemoryGameWidget>
    with SingleTickerProviderStateMixin {
  late List<String> _data;
  late List<bool> _visible;
  int? _firstIndex;
  int _score = 0;
  bool _isProcessing = false;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _initializeGame();
  }

  void _initializeGame() {
    _data = List.from(widget.data);
    _data.shuffle();
    _visible = List.filled(_data.length, false);
    _firstIndex = null;
    _score = 0;
    _isProcessing = false;

    _controller = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    );

    _animation = Tween<double>(begin: 1.0, end: 0.0).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _shuffleCards();
  }

  void _shuffleCards() {
    setState(() {
      _visible = List.filled(_data.length, true);
      _controller.forward().then((_) {
        Future.delayed(Duration(milliseconds: 500), () {
          setState(() {
            _visible = List.filled(_data.length, false);
            _controller.reset();
          });
        });
      });
    });
  }

  void _onCardTap(int index) {
    if (_isProcessing || _visible[index]) return;

    setState(() {
      _visible[index] = true;
      if (_firstIndex == null) {
        _firstIndex = index;
      } else {
        _isProcessing = true;
        if (_data[_firstIndex!] == _data[index]) {
          _score++;
          _firstIndex = null;
          _isProcessing = false;
          widget.onMatch();
          if (_score == _data.length ~/ 2) {
            widget.onGameComplete();
          }
        } else {
          widget.onMismatch();
          Future.delayed(Duration(milliseconds: 500), () {
            setState(() {
              _visible[_firstIndex!] = false;
              _visible[index] = false;
              _firstIndex = null;
              _isProcessing = false;
            });
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: GridView.builder(
        padding: EdgeInsets.all(16.0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
        ),
        itemCount: _data.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => _onCardTap(index),
            child: Card(
              child: Center(
                child: _visible[index]
                    ? Text(
                        _data[index],
                        style: TextStyle(fontSize: 32.0),
                      )
                    : Container(),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
