import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:seed_pro/globales.dart';
import 'package:seed_pro/models/logout_model.dart';
import 'package:seed_pro/services/authentication_service.dart';

class LogoutService {
  final String baseUrl;
  final LogoutRequest logoutRequest;

  LogoutService(this.logoutRequest, this.baseUrl);

  Future<void> logout() async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/logout/'),
        headers: await getHeaders(),
        body: jsonEncode(logoutRequest.toJson()),
      );

      if (response.statusCode == 200) {
        print('Logout successful');
      } else {
        print('Logout failed with status code: ${response.statusCode}');
        throw Exception('Failed to logout');
      }
    } catch (e) {
      print('Error during logout: $e');
      rethrow;
    }
  }
}


