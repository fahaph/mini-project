enum ImgPath {
  food(title: 'A La Carte', imgPath: 'assets/images/food.png'),
  fruit(title: 'Fruit', imgPath: 'assets/images/fruit.png'),
  snack(title: 'Snack', imgPath: 'assets/images/snack.png'),
  beverage(title: 'Beverage', imgPath: 'assets/images/beverage.png');

  const ImgPath({
    required this.imgPath,
    required this.title
  });

  final imgPath;
  final title;
}