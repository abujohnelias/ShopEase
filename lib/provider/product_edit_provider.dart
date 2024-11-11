// import 'package:flutter/material.dart';
// import 'package:shopease/services/product_services.dart';

// class ProductEditProvider extends ChangeNotifier {
//   final ProductService _productService = ProductService();
//   bool isLoading = false;

//   Future<void> updateProduct(
//       int id, String title, double price, String description) async {
//     isLoading = true;
//     notifyListeners();

//     try {
//       await _productService.updateProduct(id, title, price, description);
//     } catch (e) {
//       rethrow;
//     } finally {
//       isLoading = false;
//       notifyListeners();
//     }
//   }
// }


// providers/product_edit_provider.dart

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProductEditProvider with ChangeNotifier {
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  Future<void> updateProduct(int id, String title, double price, String description) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.put(
        Uri.parse('https://dummyjson.com/products/$id'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'title': title,
          'price': price,
          'description': description,
        }),
      );

      if (response.statusCode == 200) {
        // Optionally decode and check the response data to ensure it matches expectations
        final responseData = jsonDecode(response.body);
        print("Updated product response: $responseData");
      } else {
        print("Failed to update product: ${response.statusCode}");
        print("Response body: ${response.body}");
        throw Exception('Failed to update product');
      }
    } catch (e) {
      print('Error updating product: $e');
      throw e;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
