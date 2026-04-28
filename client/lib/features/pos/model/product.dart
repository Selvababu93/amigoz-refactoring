class Product {
  final int id;
  final String name;
  final double price;
  final int stock;
  final int? categoryId;
  final String? imagePath;
  final String? barcode;

  const Product(
      {required this.id,
      required this.name,
      required this.price,
      required this.stock,
      required this.categoryId,
      required this.imagePath,
      required this.barcode});
}
