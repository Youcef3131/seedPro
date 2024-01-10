import 'package:flutter/material.dart';
import 'package:seed_pro/screens/addshops.dart';
import 'package:seed_pro/screens/categories.dart';
import 'package:seed_pro/screens/clients.dart';
import 'package:seed_pro/screens/coasts.dart';
import 'package:seed_pro/screens/compositions.dart';
import 'package:seed_pro/screens/dashboard.dart';
import 'package:seed_pro/screens/employees.dart';
import 'package:seed_pro/screens/products.dart';
import 'package:seed_pro/screens/purchases.dart';
import 'package:seed_pro/screens/sales.dart';
import 'package:seed_pro/screens/suppliers.dart';
import 'package:seed_pro/screens/transfers.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(const MyApp());
}

const String baseurl = 'http://127.0.0.1:8000/';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'seePro',
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginScreen(),
        '/dashboard': (context) => Dashboard(),
        '/categories': (context) => Categories(),
        '/products': (context) => Products(),
        '/clients': (context) => Clients(),
        '/sales': (context) => Sales(),
        '/suppliers': (context) => Suppliers(),
        '/purchases': (context) => Purchases(),
        '/transfers': (context) => Transfers(),
        '/compositions': (context) => Compositions(),
        '/coasts': (context) => Coasts(),
        '/employees': (context) => Employee(),
        '/addshops': (context) => Addshops(),
      },
    );
  }
}
