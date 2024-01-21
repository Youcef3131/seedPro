import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:seed_pro/models/salePayment_model.dart';
import 'package:seed_pro/services/authentication_service.dart';

class SalePaymentApi {
  final String baseUrl;

  SalePaymentApi(this.baseUrl);

  Future<List<SalePayment>> getSalePayments() async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/salepayments/'),
      headers: await getHeaders(),
    );

    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body);
      return List<SalePayment>.from(
        list.map((payment) => SalePayment.fromJson(payment)),
      );
    } else {
      throw Exception('Failed to load sale payments');
    }
  }

  Future<List<SalePayment>> getSalePaymentsBySaleId(int saleId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/salepayments/'),
      headers: await getHeaders(),
    );

    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body);

      List<SalePayment> filteredList = List<SalePayment>.from(
        list.map((payment) => SalePayment.fromJson(payment)),
      ).where((payment) => payment.sale == saleId).toList();

      return filteredList;
    } else {
      throw Exception('Failed to load sale payments');
    }
  }

  Future<SalePayment> createSalePayment(SalePayment newPayment) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/salepayments/'),
      headers: await getHeaders(),
      body: jsonEncode(newPayment.toJson()),
    );

    if (response.statusCode == 201) {
      return SalePayment.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create sale payment');
    }
  }

  Future<SalePayment> getSalePaymentById(int paymentId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/salepayments/$paymentId/'),
      headers: await getHeaders(),
    );

    if (response.statusCode == 200) {
      return SalePayment.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load sale payment details');
    }
  }

  Future<void> deleteSalePayment(int paymentId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/api/salepayments/$paymentId/'),
      headers: await getHeaders(),
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to delete sale payment');
    }
  }
}
