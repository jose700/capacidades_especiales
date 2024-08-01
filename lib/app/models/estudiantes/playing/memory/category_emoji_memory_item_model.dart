class EmojiCategory {
  List<String> fruits;
  List<String> animals;
  List<String> transport;
  List<String> emojis;

  EmojiCategory({
    required this.fruits,
    required this.animals,
    required this.transport,
    required this.emojis,
  });

  factory EmojiCategory.fromJson(Map<String, dynamic> json) {
    return EmojiCategory(
      fruits: List<String>.from(json['fruits']),
      animals: List<String>.from(json['animals']),
      transport: List<String>.from(json['transport']),
      emojis: List<String>.from(json['emojis']),
    );
  }
}
