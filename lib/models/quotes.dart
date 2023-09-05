class Quotes {

  final String author;
  final String text;

  Quotes({required this.author, required this.text,});

  factory Quotes.fromJson(Map<String, dynamic> json) {
    return Quotes(
      text: json['text'] as String,
      author: json['author'] as String,
    );
  }

  factory Quotes.fromMap(Map<String, dynamic> json) {
    return Quotes(
      author: json['author'],
      text: json['text'],
    );
  }

}