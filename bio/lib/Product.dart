// Model class representing a product
class Product {
  final String name;
  final String category;
  final String productId;
  final List<String> images;
  final String link;

  Product({
    required this.name,
    required this.category,
    required this.productId,
    required this.images,
    required this.link,
  });
}
