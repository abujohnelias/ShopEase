import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shopease/models/products_model.dart';

class ProductService {
  final String baseUrl = 'https://dummyjson.com';

  Future<List<Product>> fetchProducts(
    int limit,
    int skip,
  ) async {
    final response = await http.get(
      Uri.parse('$baseUrl/products?limit=$limit&skip=$skip'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<Product> products = (data['products'] as List)
          .map((productJson) => Product.fromJson(productJson))
          .toList();
      return products;
    } else {
      throw Exception('Failed to load products');
    }
  }

  Future<Product> fetchProductById(
    int id,
  ) async {
    final response = await http.get(Uri.parse('$baseUrl/products/$id'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Product.fromJson(data);
    } else {
      throw Exception('Failed to load product details');
    }
  }

  Future<Product> updateProduct(
    int id,
    String title,
    double price,
    String description,
  ) async {
    final response = await http.put(
      Uri.parse('$baseUrl/products/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'title': title,
        'price': price,
        'description': description,
      }),
    );

    if (response.statusCode == 200) {
      return Product.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update product');
    }
  }
}
