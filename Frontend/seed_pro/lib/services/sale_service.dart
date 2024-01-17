import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:seed_pro/models/sale_model.dart';

class SaleApi {
  final String baseUrl;

  SaleApi(this.baseUrl);
  
  Future<List<Sale>> getSales() async {
    final response = await http.get(Uri.parse('$baseUrl/sale/Lists'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => Sale.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load sales');
    }
  }

  Future<Sale> getSaleById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/sale/$id/'));

    if (response.statusCode == 200) {
      return Sale.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load sale');
    }
  }

  Future<Sale> addSale(Sale sale) async {
    final response = await http.post(
      Uri.parse('$baseUrl/sale/'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(sale.toJson()),
    );

    if (response.statusCode == 201) {
      return Sale.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to add sale');
    }
  }
}
