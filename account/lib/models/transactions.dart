class Transactions {
  final String title;
  final String resta;
  final double rating;
  final double price;
  final DateTime date;

  Transactions({
    required this.title,
    required this.resta,
    required this.rating,
    required this.price,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'resta': resta,
      'rating': rating,
      'price': price,
      'date': date.toIso8601String(),
    };
  }
}