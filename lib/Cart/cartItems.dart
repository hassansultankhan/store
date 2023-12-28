class CartItem {
  final int id; // Add an ID field for database operations
  final String title;
  final String category;
  final String size;
  final int price;
  final String imagePath;
  final int qtySold;
  final int productNo;

  CartItem({
    required this.id,
    required this.title,
    required this.category,
    required this.size,
    required this.price,
    required this.imagePath,
    required this.qtySold,
    required this.productNo,
  });
  CartItem.withoutId({
    required this.title,
    required this.category,
    required this.size,
    required this.price,
    required this.imagePath,
    required this.qtySold,
    required this.productNo,
  }) : id = 0;

  // Method to convert CartItem to a map for database operations
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'category': category,
      'size': size,
      'price': price,
      'imagePath': imagePath,
      'qtySold': qtySold,
      'product_no': productNo,
    };
  }
}
