import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiUtility {
  static final String baseUrl = 'http://127.0.0.1:8000/api';

  static Future<List<Map<String, dynamic>>> fetchProducts() async {
    final response = await http.get(
      Uri.parse('$baseUrl/products/'),
      headers: await _getHeaders(),
    );

    if (response.statusCode == 200) {
      final List<dynamic> productList = json.decode(response.body);
      return productList.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to load products');
    }
  }

  static Future<void> createProduct(Map<String, dynamic> productData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/products/'),
      headers: await _getHeaders(),
      body: json.encode(productData),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to create product');
    }
  }

  static Future<Map<String, dynamic>> fetchProduct(int productId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/products/$productId/'),
      headers: await _getHeaders(),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to fetch product');
    }
  }

  static Future<void> updateProduct(int productId, Map<String, dynamic> productData) async {
    final response = await http.put(
      Uri.parse('$baseUrl/products/$productId/'),
      headers: await _getHeaders(),
      body: json.encode(productData),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update product');
    }
  }

  static Future<void> deleteProduct(int productId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/products/$productId/'),
      headers: await _getHeaders(),
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to delete product');
    }
  }

  static Future<Map<String, String>> _getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final authToken = prefs.getString('authToken') ?? '';
    return {'Authorization': 'Token $authToken'};
  }
}
