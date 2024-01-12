import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:seed_pro/models/ProductDetails.dart';
import 'package:seed_pro/services/authentication_service.dart';

class ProductDetailsApi {
  final String baseUrl;

  ProductDetailsApi(this.baseUrl);

  Future<List<ProductDetails>> getProductsInShop() async {
    var shopId = await getShopIdFromPrefs();

    final response = await http.get(
      Uri.parse('$baseUrl/api/products-in-shop/$shopId/'),
      headers: await getHeaders(),
    );

    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body);
      return List<ProductDetails>.from(
        list.map((productDetails) => ProductDetails.fromJson(productDetails)),
      );
    } else {
      throw Exception('Failed to load products in shop');
    }
  }
}
