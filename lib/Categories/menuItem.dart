class MenuItem {
  late String title;
  late String category;
  late String size;
  late int price;
  late String imagePath;
  late bool soldStatus;
  late int qtySold;
  late int productNo;

  MenuItem({
    required this.title,
    required this.category,
    required this.size,
    required this.price,
    required this.imagePath,
    required this.soldStatus,
    required this.qtySold,
    required this.productNo,
  });
}
