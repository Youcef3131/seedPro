import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:seed_pro/models/extandedsale_model.dart';
import 'package:seed_pro/services/authentication_service.dart';

class ExtendedSaleApi {
  final String baseUrl;

  ExtendedSaleApi(this.baseUrl);

  Future<List<ExtendedSale>> getAllSalesInfo() async {
    var shopId = await getShopIdFromPrefs();
    final response = await http.get(
        Uri.parse('$baseUrl/api/all-sales-info/$shopId/'),
        headers: await getHeaders());

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => ExtendedSale.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load sales info');
    }
  }
}
