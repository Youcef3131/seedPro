import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:seed_pro/services/authentication_service.dart';

class LastSalesService {
  final String baseUrl;

  LastSalesService(this.baseUrl);

  // Fetches the last 5 days sales data for a shop from the API
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

        // Extracting sales data from JSON response
        List<int> salesData = List<int>.from(jsonData);

        // Filter out non-finite values (Infinity, NaN)
        salesData = salesData.where((value) => value.isFinite).toList();

        return salesData;
      } else {
        // Handle non-200 status code
        throw Exception(
          'Failed to fetch sales data. Status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      // Log the error for debugging purposes
      print('Error during API call: $e');
      rethrow; // Rethrow the caught exception
    }
  }
}
