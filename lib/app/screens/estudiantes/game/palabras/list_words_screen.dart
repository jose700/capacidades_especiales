import 'package:flutter/material.dart';
import 'package:capacidades_especiales/app/models/estudiantes/playing/palabras/words_model.dart';
import 'package:capacidades_especiales/app/screens/estudiantes/game/palabras/palabras_screen.dart';
import 'package:capacidades_especiales/app/widgets/search/search_text_field_widget.dart';

class WordListScreen extends StatefulWidget {
  final Future<List<WordItem>> wordsFuture;

  WordListScreen({required this.wordsFuture});

  @override
  _WordListScreenState createState() => _WordListScreenState();
}

class _WordListScreenState extends State<WordListScreen> {
  List<WordItem> _filteredWords = [];
  List<WordItem> _allWords = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    widget.wordsFuture.then((words) {
      setState(() {
        _allWords = words;
        _filteredWords = words;
      });
      _searchController.addListener(() {
        _filterWords(_searchController.text);
      });
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(() {
      _filterWords(_searchController.text);
    });
    _searchController.dispose();
    super.dispose();
  }

  void _filterWords(String query) {
    final filteredWords = _allWords.where((word) {
      final wordText = word.word.toLowerCase();
      final input = query.toLowerCase();
      return wordText.contains(input);
    }).toList();

    setState(() {
      _filteredWords = filteredWords;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Palabras'),
      ),
      body: Column(
        children: [
          SearchTextField(searchController: _searchController),
          Expanded(
            child: FutureBuilder<List<WordItem>>(
              future: widget.wordsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No hay palabras disponibles.'));
                } else {
                  return ListView.builder(
                    itemCount: _filteredWords.length,
                    itemBuilder: (context, index) {
                      final word = _filteredWords[index];
                      return Card(
                        elevation: 2.0,
                        margin: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16.0),
                        child: ListTile(
                          title: Text(
                            word.word,
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    WordGameScreen(word: word.word),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
