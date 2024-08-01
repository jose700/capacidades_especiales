class WordItem {
  final String word;

  WordItem({required this.word});

  factory WordItem.fromJson(Map<String, dynamic> json) {
    return WordItem(
      word: json['word'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'word': word,
    };
  }
}
