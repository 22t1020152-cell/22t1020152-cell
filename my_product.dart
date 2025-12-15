import 'package:flutter/material.dart';
import 'models/product.dart';
import 'api.dart';

// The top-level MaterialApp was moved to `lib/main.dart` so the app can
// provide a single router suitable for web. Keep using `ProductListScreen`
// and `ProductDetailsScreen` from this module; they will be wired in main.
// This file exposes the product listing screen widgets which are used by
// the application's top-level router in `main.dart`.
//
// Previously this file built its own MaterialApp. For proper web routing and
// to avoid nested MaterialApp instances we now keep only widgets (screens) here
// and configure MaterialApp at the app entry (`lib/main.dart`).

// The `ProductListScreen` and supportive widgets remain defined below.

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  late Future<List<Product>> futureProducts;

  @override
  void initState() {
    super.initState();
    // Khởi tạo việc fetch dữ liệu khi widget được tạo
    futureProducts = ApiService().fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'bài thực hành web API 2 có dùng routing',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color.fromARGB(
          255,
          248,
          2,
          137,
        ), // Màu nền của AppBar
        actions: const [
          // Thêm chữ DEBUG ở góc phải như trong hình
          Padding(
            padding: EdgeInsets.only(right: 8.0),
            child: Chip(
              label: Text(
                'routing',
                style: TextStyle(fontSize: 10, color: Colors.white),
              ),
              backgroundColor: Color.fromARGB(255, 0, 0, 0),
            ),
          ),
        ],
      ),
      body: FutureBuilder<List<Product>>(
        future: futureProducts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Hiển thị loading khi đang chờ dữ liệu
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Hiển thị lỗi nếu có
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            // Khi có dữ liệu, hiển thị GridView
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                // Chia thành 2 cột
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10.0, // Khoảng cách giữa các cột
                  mainAxisSpacing: 10.0, // Khoảng cách giữa các hàng
                  childAspectRatio:
                      0.7, // Tỉ lệ chiều rộng/chiều cao của mỗi item
                ),
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final p = snapshot.data![index];
                  return GestureDetector(
                    onTap: () => Navigator.of(
                      context,
                    ).pushNamed('/product', arguments: p),
                    child: ProductGridItem(product: p),
                  );
                },
              ),
            );
          } else {
            // Trường hợp không có dữ liệu
            return const Center(child: Text('No products found.'));
          }
        },
      ),
    );
  }
}

// Widget đại diện cho mỗi item sản phẩm
class ProductGridItem extends StatelessWidget {
  final Product product;
  const ProductGridItem({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0, // Độ nổi của Card
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0), // Bo góc
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // 1. Hình ảnh sản phẩm (có thể cần dùng placeholder nếu API không có ảnh chất lượng)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                // Căn giữa hình ảnh
                child: Image.network(
                  product.imageUrl,
                  fit: BoxFit.contain, // Đảm bảo hình ảnh vừa vặn
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const Center(child: CircularProgressIndicator());
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.broken_image, size: 80);
                  },
                ),
              ),
            ),
          ),
          // 2. Tên sản phẩm
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 4.0),
            child: Text(
              product.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ),
          // 3. Giá tiền
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: Text(
              '\$${product.price.toStringAsFixed(2)}', // Định dạng giá 2 chữ số thập phân
              style: const TextStyle(
                color: Color.fromARGB(255, 109, 221, 158),
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          // 4. Đánh giá (Rating và Reviews)
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
            child: Row(
              children: <Widget>[
                const Icon(
                  Icons.star,
                  color: Color.fromARGB(255, 145, 111, 10),
                  size: 16,
                ),
                const SizedBox(width: 4),
                Text(
                  '${product.rating.toStringAsFixed(1)} (${product.reviews})',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
