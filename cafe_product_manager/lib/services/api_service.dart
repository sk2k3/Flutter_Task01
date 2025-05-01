import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:5000/products'; // For Android emulator
  // Use http://localhost:5000 if using web or desktop

  static Future<List<Product>> fetchProducts() async {
    final response = await http.get(Uri.parse('$baseUrl/products'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  static Future<Product> addProduct(Product product) async {
    final response = await http.post(
      Uri.parse('$baseUrl/products'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(product.toJson()),
    );

    if (response.statusCode == 201) {
      return Product.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to add product');
    }
  }

  // You can add update and delete methods here later
}
