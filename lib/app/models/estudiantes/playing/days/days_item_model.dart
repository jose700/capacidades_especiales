class Day {
  final String day;

  Day({required this.day});

  factory Day.fromJson(Map<String, dynamic> json) {
    return Day(
      day: json['day'],
    );
  }
}
