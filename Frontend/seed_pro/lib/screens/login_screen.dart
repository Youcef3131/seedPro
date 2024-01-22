import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:seed_pro/globales.dart';

import 'package:seed_pro/widgets/colors.dart';
import '../models/user.dart';
import '../services/authentication_service.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthenticationService authService = AuthenticationService();
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGrey,
      body: Center(
        child: Container(
          width: 800,
          height: 550,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'images/home.png',
              ),
              SizedBox(
                height: 50,
              ),
              Container(
                width: 500,
                height: 300,
                color: AppColors.white,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      TextFormField(
                        key: Key('username_field'),
                        controller: usernameController,
                        decoration: InputDecoration(
                          labelText: 'Username',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              borderSide: BorderSide(color: AppColors.black)),
                          filled: true,
                          fillColor: AppColors.lightGrey,
                          labelStyle: TextStyle(color: AppColors.grey),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 25.0, horizontal: 16.0),
                          prefixIcon: Icon(Icons.person, color: AppColors.grey),
                        ),
                      ),
                      SizedBox(height: 30),
                      TextFormField(
                        key: Key('password_field'),
                        controller: passwordController,
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              borderSide: BorderSide(color: AppColors.black)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              borderSide: BorderSide(color: AppColors.black)),
                          filled: true,
                          fillColor: AppColors.lightGrey,
                          labelStyle: TextStyle(color: AppColors.grey),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 25.0, horizontal: 16.0),
                          prefixIcon: Icon(Icons.lock, color: AppColors.grey),
                          suffixIcon: GestureDetector(
                            onTap: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                            child: Icon(
                              _obscurePassword
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: AppColors.grey,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      ElevatedButton(
                        onPressed: _performLogin,
                        style: ElevatedButton.styleFrom(
                          primary: AppColors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          minimumSize: Size(350, 60),
                        ),
                        child: Text(
                          'Login',
                          style: TextStyle(color: AppColors.white),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _performLogin() async {
    try {
      String username = usernameController.text;
      String password = passwordController.text;

      if (username.isEmpty || password.isEmpty) {
        print('Please enter both username and password');
        return;
      }

      User user = User(username: username, password: password);

      String? token = await authService.login(user);

      if (token != null) {
        String apiUrl = '${baseurl}/api/get-shop/$username/';
        final response = await http.get(
          Uri.parse(apiUrl),
          headers: {'Authorization': 'token ${token}'},
        );

        if (response.statusCode == 200) {
          final Map<String, dynamic> data = json.decode(response.body);

          if (data.containsKey('id')) {
            final String shopId = data['id'].toString();
            await authService.saveShopInfoLocally(shopId, username, password);
            Navigator.pushNamed(context, '/dashboard');
          } else {
            print('Shop ID not found in the response');
          }
        } else {
          print('Failed to get shop information: ${response.statusCode}');
        }
      } else {
        print('Login failed');
      }
    } catch (e) {
      print('Error during login: $e');
    }
  }
}
