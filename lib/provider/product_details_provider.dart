import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shopease/models/products_model.dart';


class ProductDetailProvider with ChangeNotifier {
  Product? _product;
  bool _isLoading = false;

  Product? get product => _product;
  bool get isLoading => _isLoading;

  Future<void> fetchProductDetail(int id, {bool forceRefresh = false}) async {
    if (_product != null && !forceRefresh) return;  
    _isLoading = true;
    notifyListeners(); 

    try {
      final response = await http.get(Uri.parse('https://dummyjson.com/products/$id'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _product = Product.fromJson(data); 
      } else {
        throw Exception('Failed to load product details');
      }
    } catch (e) {
      print('Error fetching product details: $e');
    } finally {
      _isLoading = false;
      notifyListeners();  
    }
  }

  
  void clearProduct() {
    _product = null;
    notifyListeners();
  }
}
