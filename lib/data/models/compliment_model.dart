class Compliment {
  final int id;
  final String text;
  final String theme;
  final String createdAt;

  Compliment({
    required this.id,
    required this.text,
    required this.theme,
    required this.createdAt,
  });

  factory Compliment.fromJson(Map<String, dynamic> json) {
    return Compliment(
      id: json['id'],
      text: json['text'],
      theme: json['theme'],
      createdAt: json['created_at'],
    );
  }
}
