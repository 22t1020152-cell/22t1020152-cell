// lib/models/product_model.dart

class Product {
  final int id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  final double rating;
  final int reviews;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.rating,
    required this.reviews,
  });

  // Factory constructor để tạo đối tượng Product từ JSON
  factory Product.fromJson(Map<String, dynamic> json) {
    // Lưu ý: Các trường như 'rating' và 'price' thường là 'num' trong JSON,
    // nên ta cần chuyển chúng thành 'double'.
    // Ta sử dụng một API giả định trả về các trường này.
    return Product(
      id: json['id'] as int,
      title: json['title'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      imageUrl: json['image'] as String, // Thay đổi tùy theo API của bạn
      // Giả định API trả về object 'rating'
      rating: (json['rating']['rate'] as num).toDouble(),
      reviews: json['rating']['count'] as int, // 'reviews' là 'count'
    );
  }
}
