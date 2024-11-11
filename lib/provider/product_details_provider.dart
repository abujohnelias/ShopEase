// import 'package:flutter/material.dart';
// import 'package:shopease/models/products_model.dart';
// import 'package:shopease/services/product_services.dart';

// class ProductDetailProvider extends ChangeNotifier {
//   final ProductService _productService = ProductService();
//   Product? product;
//   bool isLoading = false;

//   Future<void> fetchProductDetail(int productId) async {
//     isLoading = true;
//     notifyListeners();

//     try {
//       product = await _productService.fetchProductById(productId);
//     } catch (e) {
//       product = null;
//     } finally {
//       isLoading = false;
//       notifyListeners();
//     }
//   }
// }


// providers/product_detail_provider.dart
// providers/product_detail_provider.dart
// providers/product_detail_provider.dart

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shopease/models/products_model.dart';


class ProductDetailProvider with ChangeNotifier {
  Product? _product;
  bool _isLoading = false;

  Product? get product => _product;
  bool get isLoading => _isLoading;

  // Fetch product details and update the product data
  Future<void> fetchProductDetail(int id, {bool forceRefresh = false}) async {
    if (_product != null && !forceRefresh) return;  // Skip re-fetching unless forced

    _isLoading = true;
    notifyListeners(); // Notify listeners to show loading state

    try {
      final response = await http.get(Uri.parse('https://dummyjson.com/products/$id'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _product = Product.fromJson(data); // Update the product with new data
      } else {
        throw Exception('Failed to load product details');
      }
    } catch (e) {
      print('Error fetching product details: $e');
    } finally {
      _isLoading = false;
      notifyListeners();  // Notify listeners after fetching is done
    }
  }

  // Method to clear the product (optional for forced refresh)
  void clearProduct() {
    _product = null;
    notifyListeners();
  }
}
