// Ejemplo de implementación de AlphabetItem en alphabet_item_model.dart
class PainterItem {
  final int id;
  final String image;

  PainterItem({
    required this.id,
    required this.image,
  });

  factory PainterItem.fromJson(Map<String, dynamic> json) {
    return PainterItem(
      id: json['id'],
      image: json['image'] ?? 'assets/img/cp.png',
    );
  }
}
