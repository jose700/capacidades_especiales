class Number {
  final int number;
  final String type;

  Number({required this.number, required this.type});

  factory Number.fromJson(Map<String, dynamic> json) {
    return Number(
      number: json['number'],
      type: json['type'],
    );
  }
}
