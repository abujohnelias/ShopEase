import 'package:flutter/material.dart';
import 'package:shopease/models/products_model.dart';
import 'package:shopease/services/product_services.dart';

class ProductProvider extends ChangeNotifier {
  final ProductService _productService = ProductService();
  List<Product> products = [];
  int _currentPage = 0;
  final int _limit = 10;
  bool _isLoading = false;
  bool _hasMore = true;

  bool get isLoading => _isLoading;
  bool get hasMore => _hasMore;

  ProductProvider() {
    fetchNextPage();
  }

  Future<void> fetchNextPage() async {
    if (_isLoading || !_hasMore) return;
    _isLoading = true;
    notifyListeners();

    try {
      final newProducts = await _productService.fetchProducts(_limit, _currentPage * _limit);
      if (newProducts.isEmpty) {
        _hasMore = false;
      } else {
        products.addAll(newProducts);
        _currentPage++;
      }
    } catch (e) {
      _hasMore = false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
