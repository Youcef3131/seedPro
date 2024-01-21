import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:seed_pro/models/saleproduct_model.dart';
import 'package:seed_pro/screens/products.dart';
import 'package:seed_pro/services/authentication_service.dart';

class SaleProductApi {
  final String baseUrl;

  SaleProductApi(this.baseUrl);

  Future<List<SaleProduct>> getSaleProductsBySaleId(int saleId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/saleproducts/sale/$saleId'),
      headers: await getHeaders(),
    );

    print('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body);
      return List<SaleProduct>.from(
        list.map((saleProduct) => SaleProduct.fromJson(saleProduct)),
      );
    } else {
      throw Exception('Failed to load sale products by sale ID');
    }
  }

  Future<SaleProduct> getSaleProductById(int saleProductId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/saleproduct/$saleProductId/'),
      headers: await getHeaders(),
    );

    if (response.statusCode == 200) {
      return SaleProduct.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load sale product by ID');
    }
  }

  Future<SaleProduct> updateSaleProduct(SaleProduct updatedSaleProduct) async {
    final response = await http.put(
      Uri.parse(
        '$baseUrl/api/saleproduct/${updatedSaleProduct.id}/',
      ),
      body: jsonEncode(updatedSaleProduct.toJson()),
      headers: await getHeaders(),
    );

    if (response.statusCode == 200) {
      return SaleProduct.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update sale product');
    }
  }

  Future<void> deleteSaleProduct(int saleProductId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/api/saleproduct/$saleProductId/'),
      headers: await getHeaders(),
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to delete sale product');
    }
  }

  Future<SaleProduct> AddSaleProduct(SaleProduct newSaleProduct) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/saleproduct/'),
      body: jsonEncode(newSaleProduct.toJson()),
      headers: await getHeaders(),
    );

    if (response.statusCode == 201) {
      return SaleProduct.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create new sale product');
    }
  }
}
