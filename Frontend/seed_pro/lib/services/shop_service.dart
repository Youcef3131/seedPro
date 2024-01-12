import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:seed_pro/models/shop_model.dart';
import 'package:seed_pro/services/authentication_service.dart';

class ShopApi {
  final String baseUrl;

  ShopApi(this.baseUrl);
  Future<Shop> getShopDetails() async {
    var globalShopId = await getShopIdFromPrefs();
    print('$baseUrl/api/shops/$globalShopId/');
    final response = await http.get(
        Uri.parse('$baseUrl/api/shops/$globalShopId/'),
        headers: await getHeaders());

    if (response.statusCode == 200) {
      return Shop.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load shop details');
    }
  }
}
