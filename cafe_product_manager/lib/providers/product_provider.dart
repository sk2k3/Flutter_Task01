import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ProductProvider with ChangeNotifier {
  List<Product> _products = [];

  List<Product> get products => [..._products];

  final String baseUrl = 'http://localhost:5000/products';

  Future<void> fetchProducts() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _products = data.map((item) => Product.fromJson(item)).toList();
        notifyListeners();
      } else {
        throw Exception('Failed to load products');
      }
    } catch (error) {
      throw error;
    }
  }

  Future<void> addProduct(Product product) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(product.toJson()),
      );

      if (response.statusCode == 201) {
        final newProduct = Product.fromJson(json.decode(response.body));
        _products.add(newProduct);
        notifyListeners();
      } else {
        throw Exception('Failed to add product');
      }
    } catch (error) {
      throw error;
    }
  }

  Product? getProductById(String id) {
    return _products.firstWhere(
      (prod) => prod.id == id,
      orElse: () => Product(id: '', name: '', description: '', price: 0, imageUrl: ''),
    );
  }

  Future<void> updateProduct(String id, Product updatedProduct) async {
    final url = Uri.parse('$baseUrl/$id');

    try {
      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(updatedProduct.toJson()),
      );

      if (response.statusCode == 200) {
        final index = _products.indexWhere((prod) => prod.id == id);
        if (index >= 0) {
          _products[index] = updatedProduct;
          notifyListeners();
        }
      } else {
        throw Exception('Failed to update product');
      }
    } catch (error) {
      throw error;
    }
  }

  Future<void> deleteProduct(String id) async {
    final url = Uri.parse('$baseUrl/$id');

    try {
      final response = await http.delete(url);

      if (response.statusCode == 200) {
        _products.removeWhere((prod) => prod.id == id);
        notifyListeners();
      } else {
        throw Exception('Failed to delete product');
      }
    } catch (error) {
      throw error;
    }
  }
}
