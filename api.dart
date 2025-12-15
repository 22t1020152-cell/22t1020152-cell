// lib/services/api_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

// If you have an API key, set it here. The sample key you provided is included
// and will be sent as a header named 'x-api-key'. If your backend expects a
// different header/query param, change ApiService accordingly.
const _apiKey = '88f8ebe79c674408a7817896097f4004';

class ApiService {
  // Example endpoint. You can replace this with your real API endpoint.
  final String apiUrl = 'https://fakestoreapi.com/products?limit=12';

  Future<List<Product>> fetchProducts() async {
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        // Send API key header (if needed)
        'x-api-key': _apiKey,
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      // Nếu server trả về mã 200 OK, parse JSON
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((product) => Product.fromJson(product)).toList();
    } else {
      // Nếu server không trả về mã 200 OK, ném exception
      throw Exception('Failed to load products from API');
    }
  }
}
