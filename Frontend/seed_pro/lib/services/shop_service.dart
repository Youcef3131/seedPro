import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:seed_pro/models/shop_model.dart';
import 'package:seed_pro/services/authentication_service.dart';

class ShopApi {
  final String baseUrl;

  ShopApi(this.baseUrl);

  Future<List<Shop>> getShops() async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/shops/'),
      headers: await getHeaders(),
    );

    if (response.statusCode == 200) {
      Iterable shopList = json.decode(response.body);
      return shopList.map((shopJson) => Shop.fromJson(shopJson)).toList();
    } else {
      throw Exception('Failed to load shops');
    }
  }

  Future<Shop> addShop(Shop newShop) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/add_shop/'),
      headers: await getHeaders(),
      body: json.encode(newShop.toJson()),
    );

    if (response.statusCode == 201) {
      return Shop.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to add shop');
    }
  }

  Future<Shop> getShopDetails() async {
    var globalShopId = await getShopIdFromPrefs();
    final response = await http.get(
      Uri.parse('$baseUrl/api/shops/$globalShopId/'),
      headers: await getHeaders(),
    );

    if (response.statusCode == 200) {
      return Shop.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load shop details');
    }
  }
}
