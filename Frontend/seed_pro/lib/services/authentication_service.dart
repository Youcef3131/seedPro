// authentication_service.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:seed_pro/globales.dart';

import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

class AuthenticationService {
  static const String apiUrl = '${baseurl}/api/login/';

  Future<String?> login(User user) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: {
          'username': user.username,
          'password': user.password,
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        // Check if the 'token' key exists in the response
        if (data.containsKey('token')) {
          final String token = data['token'];

          saveTokenLocally(token);

          return token;
        } else {
          debugPrint('Token not found in the response');
          return null;
        }
      } else {
        debugPrint('Login failed: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      debugPrint('Error during login: $e');
      return null;
    }
  }

  Future<void> saveTokenLocally(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
    debugPrint('Token saved securelyy: $token');
  }

  Future<void> saveShopInfoLocally(
      String shopId, String username, String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('shop_id', shopId);
    await prefs.setString('username', username);
    await prefs.setString('password', password);
    debugPrint(
        'Shop information saved: Shop ID - $shopId, Username - $username  - $password');
  }
}

Future<String?> getTokenFromPrefs() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('auth_token');
}

Future<String?> getUsernameFromPrefs() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('username');
}

Future<String?> getPasswordFromPrefs() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('password');
}

Future<String?> getShopIdFromPrefs() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('shop_id');
}

Future<Map<String, String>> getHeaders() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? authToken = prefs.getString('auth_token');

  return {
    'Content-Type': 'application/json',
    'Authorization': 'Token $authToken',
  };
}

Future<void> removeAllInfoFromPrefs() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.clear();
  debugPrint('All information removed from SharedPreferences');
}
