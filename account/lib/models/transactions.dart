class Transactions {
  final int? keyID;
  final String title;
  final String resta;
  final double rating;
  final double price;
  final DateTime date;
  final String imgPath;

  Transactions({
    this.keyID,
    required this.title,
    required this.resta,
    required this.rating,
    required this.price,
    required this.date,
    required this.imgPath,
  });

  Map<String, dynamic> toMap() {
    return {
      'keyID': keyID,
      'title': title,
      'resta': resta,
      'rating': rating,
      'price': price,
      'date': date.toIso8601String(),
      'imgPath': imgPath
    };
  }
}
