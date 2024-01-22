import 'dart:async';

import 'package:flutter/material.dart';
import 'package:seed_pro/globales.dart';
import 'package:seed_pro/services/last5sale_service.dart';
import 'package:seed_pro/widgets/appBar.dart';
import 'package:seed_pro/widgets/button.dart';
import 'package:seed_pro/widgets/colors.dart';
import 'package:seed_pro/widgets/saleschart.dart';
import 'package:seed_pro/widgets/sidebar.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final LastSalesService salesService = LastSalesService(baseurl);
  List<int> salesNumber = [];

  late Timer _timer;

  @override
  void initState() {
    super.initState();

    // Load data initially
    loadData();

    // Set up a timer to refresh every 10 seconds
    _timer = Timer.periodic(Duration(seconds: 10), (timer) {
      loadData();
    });
  }

  @override
  void dispose() {
    // Dispose of the timer to prevent memory leaks
    _timer.cancel();
    super.dispose();
  }

  Future<void> loadData() async {
    try {
      final data = await salesService.getSalesData();

      // Filter out non-finite values (Infinity, NaN)
      salesNumber = data.where((value) => value.isFinite).toList();

      // Trigger a rebuild of the widget
      setState(() {});
    } catch (e) {
      print('Error loading data: $e');
      // Handle the error as needed, e.g., show an error message to the user
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height, // Set a specific height
        child: Row(
          children: [
            Container(
              width: 200.0,
              color: AppColors.lightGrey,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Sidebar(),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    appBar(),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        height: 650,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.green, width: 2),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              children: [
                                Text(
                                  'SALES IN LAST 5 DAYS',
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: AppColors.green, width: 2),
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: SalesChart(salesNumber),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
