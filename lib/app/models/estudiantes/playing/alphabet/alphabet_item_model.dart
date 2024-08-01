// Ejemplo de implementación de AlphabetItem en alphabet_item_model.dart
class AlphabetItem {
  final String letter;
  final String example;
  final String image;

  AlphabetItem({
    required this.letter,
    required this.example,
    required this.image,
  });

  factory AlphabetItem.fromJson(Map<String, dynamic> json) {
    return AlphabetItem(
      letter: json['letter'],
      example: json['example'],
      image: json['image'] ?? 'assets/img/cp.png',
    );
  }
}
