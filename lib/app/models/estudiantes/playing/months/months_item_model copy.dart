class Month {
  final String month;

  Month({required this.month});

  factory Month.fromJson(Map<String, dynamic> json) {
    return Month(
      month: json['month'],
    );
  }
}
