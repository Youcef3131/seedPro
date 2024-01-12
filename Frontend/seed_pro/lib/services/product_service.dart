import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:seed_pro/models/product_model.dart';
import 'package:seed_pro/services/authentication_service.dart';


class ProductApi {
  final String baseUrl;

  ProductApi(this.baseUrl);

  Future<List<Product>> getProducts() async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/products/'),
      headers: await getHeaders(),
    );

    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body);
      return List<Product>.from(
        list.map((product) => Product.fromJson(product)),
      );
    } else {
      throw Exception('Failed to load products');
    }
  }

  Future<Product> createProduct(Product newProduct) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/products/'),
      headers: await getHeaders(),
      body: jsonEncode(newProduct.toJson()),
    );

    if (response.statusCode == 201) {
      return Product.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create product');
    }
  }

  Future<Product> getProductById(int productId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/products/$productId/'),
      headers: await getHeaders(),
    );

    if (response.statusCode == 200) {
      return Product.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load product details');
    }
  }

  Future<Product> updateProduct(Product updatedProduct) async {
    final response = await http.put(
      Uri.parse('$baseUrl/api/products/${updatedProduct.id}/'),
      headers: await getHeaders(),
      body: jsonEncode(updatedProduct.toJson()),
    );

    if (response.statusCode == 200) {
      return Product.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update product');
    }
  }
}



