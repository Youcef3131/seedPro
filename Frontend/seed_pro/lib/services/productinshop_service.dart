import 'package:seed_pro/models/productinshop_model.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:seed_pro/services/authentication_service.dart';

class ProductInShopApi {
  final String baseUrl;

  ProductInShopApi(this.baseUrl);

  Future<ProductInShop> createProductInShop(
      ProductInShop newProductInShop) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/product-in-shop/'),
      headers: await getHeaders(),
      body: jsonEncode(newProductInShop.toJson()),
    );

    if (response.statusCode == 201) {
      return ProductInShop.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create product in shop');
    }
  }
}
