import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:seed_pro/models/sale_model.dart';
import 'package:seed_pro/services/authentication_service.dart';

class SaleApi {
  final String baseUrl;

  SaleApi(this.baseUrl);

  Future<Sale> getSaleById(int saleId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/sale/$saleId/'),
      headers: await getHeaders(),
    );

    if (response.statusCode == 200) {
      return Sale.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load sale by ID');
    }
  }

  Future<List<Sale>> getSales() async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/sale/'),
    );

    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body);
      return List<Sale>.from(
        list.map((sale) => Sale.fromJson(sale)),
      );
    } else {
      throw Exception('Failed to load sales');
    }
  }

  Future<Sale> createSale(Sale newSale) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/sale/'),
      headers: await getHeaders(),
      body: jsonEncode(newSale.toJson()),
    );

    if (response.statusCode == 201) {
      return Sale.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create sale');
    }
  }

  Future<Sale> updateSale(Sale updatedSale) async {
    final response = await http.put(
      Uri.parse('$baseUrl/api/sale/${updatedSale.id}/'),
      headers: await getHeaders(),
      body: jsonEncode(updatedSale.toJson()),
    );

    if (response.statusCode == 200) {
      return Sale.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update sale');
    }
  }

  Future<void> deleteSale(int saleId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/api/sale/$saleId/'),
      headers: await getHeaders(),
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to delete sale');
    }
  }
}
