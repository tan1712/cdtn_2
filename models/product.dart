class Product {
  final int id;
  final int categoryId;
  final String name;
  final double price;
  final double? oldPrice;
  final String description;
  final String imageUrl;
  final int stockQuantity;
  final bool isPopular;

  Product({
    required this.id,
    required this.categoryId,
    required this.name,
    required this.price,
    this.oldPrice,
    required this.description,
    required this.imageUrl,
    required this.stockQuantity,
    this.isPopular = false,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: int.parse(json['id'].toString()),
      categoryId: int.parse(json['category_id'].toString()),
      name: json['name'] ?? '',
      price: double.parse(json['price'].toString()),
      oldPrice: json['old_price'] != null ? double.parse(json['old_price'].toString()) : null,
      description: json['description'] ?? '',
      imageUrl: json['image_url'] ?? '',
      stockQuantity: int.parse(json['stock_quantity'].toString()),
      isPopular: json['is_popular'] == '1' || json['is_popular'] == true,
    );
  }
}
