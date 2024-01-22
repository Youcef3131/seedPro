import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:seed_pro/services/authentication_service.dart';

class LastSalesService {
  final String baseUrl;

  LastSalesService(this.baseUrl);

  Future<List<int>> getSalesData() async {
    var shopId = await getShopIdFromPrefs();
    print(shopId);

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/sales-last-5-days-per-shop/$shopId/'),
        headers: await getHeaders(),
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);

        List<int> salesData = List<int>.from(jsonData);

        salesData = salesData.where((value) => value.isFinite).toList();

        return salesData;
      } else {
        throw Exception(
          'Failed to fetch sales data. Status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Error during API call: $e');
      rethrow;
    }
  }

  Future<double> getSalesEvolutionMonth() async {
    var shopId = await getShopIdFromPrefs();
    final response = await http.get(
      Uri.parse('$baseUrl/api/sales-evolution-month/$shopId/'),
      headers: await getHeaders(),
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);

      final salesEvolutionMonth =
          _parseDouble(jsonData['evolution_rate_month_sales']);
      return salesEvolutionMonth ?? 0.0;
    } else {
      throw Exception(
        'Failed to fetch sales evolution for the month. Status code: ${response.statusCode}',
      );
    }
  }

  double _parseDouble(dynamic value) {
    if (value is double) {
      return value;
    } else if (value is int) {
      return value.toDouble();
    } else if (value is String) {
      final parsedValue = double.tryParse(value) ?? 0.0;
      return double.parse(parsedValue.toStringAsFixed(2));
    } else {
      return 0.0;
    }
  }

  Future<double> getSalesEvolutionYear() async {
    var shopId = await getShopIdFromPrefs();
    final response = await http.get(
      Uri.parse('$baseUrl/api/sales-evolution-year/$shopId/'),
      headers: await getHeaders(),
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      return jsonData['evolution_rate_year_sales'] ?? 0.0;
    } else {
      throw Exception(
        'Failed to fetch sales evolution for the year. Status code: ${response.statusCode}',
      );
    }
  }

  Future<double> getPurchasesEvolutionMonth() async {
    var shopId = await getShopIdFromPrefs();
    final response = await http.get(
      Uri.parse('$baseUrl/api/purchase-evolution-month/$shopId/'),
      headers: await getHeaders(),
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      return jsonData['evolution_rate_month_purchase'] ?? 0.0;
    } else {
      throw Exception(
        'Failed to fetch purchases evolution for the month. Status code: ${response.statusCode}',
      );
    }
  }

  Future<double> getPurchasesEvolutionYear() async {
    var shopId = await getShopIdFromPrefs();
    final response = await http.get(
      Uri.parse('$baseUrl/api/purchase-evolution-year/$shopId/'),
      headers: await getHeaders(),
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      return jsonData['evolution_rate_year_purchase'] ?? 0.0;
    } else {
      throw Exception(
        'Failed to fetch purchases evolution for the year. Status code: ${response.statusCode}',
      );
    }
  }

  Future<double> getProfitsEvolutionYear() async {
    var shopId = await getShopIdFromPrefs();
    final response = await http.get(
      Uri.parse('$baseUrl/api/profit-evolution-year/$shopId/'),
      headers: await getHeaders(),
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      return jsonData['evolution_rate_year_profit'] ?? 0.0;
    } else {
      throw Exception(
        'Failed to fetch profit evolution for the year. Status code: ${response.statusCode}',
      );
    }
  }
}
