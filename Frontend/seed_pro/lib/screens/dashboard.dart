import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:seed_pro/globales.dart';
import 'package:seed_pro/models/cleint_model.dart';
import 'package:seed_pro/models/product_model.dart';
import 'package:seed_pro/services/cleint_service.dart';
import 'package:seed_pro/services/last5sale_service.dart';
import 'package:seed_pro/services/product_service.dart';
import 'package:seed_pro/widgets/appBar.dart';
import 'package:seed_pro/widgets/card.dart';
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
  List<Product> produtcs = [];
  List<ClientT> clientsYEAR = [];
  List<ClientT> clientsMONTH = [];

  double salesEvolutionMonth = 0.0;
  double salesEvolutionYear = 0.0;
  double purchasesEvolutionMonth = 0.0;
  double purchasesEvolutionYear = 0.0;
  double profitsEvolutionYear = 0.0;

  late Timer _timer;

  @override
  void initState() {
    super.initState();

    loadData();
    loadproducts();
    loadclinets();
    _timer = Timer.periodic(Duration(seconds: 5), (timer) {
      loadData();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  loadproducts() async {
    final products = await ProductApi(baseurl).getBestSellingProducts();
    setState(() {
      produtcs = products; // Update the products list
    });
  }

  loadclinets() async {
    final clientsYear = await ClientApi(baseurl).getTopClientsPerYear();
    final clientsMonth = await ClientApi(baseurl).getTopClientsPerMonth();

    setState(() {
      clientsYEAR = clientsYear;
      clientsMONTH = clientsMonth;
    });
  }

  Future<void> loadData() async {
    try {
      final data = await salesService.getSalesData();

      salesNumber = data.where((value) => value.isFinite).toList();

      salesEvolutionMonth = await salesService.getSalesEvolutionMonth();
      salesEvolutionYear = await salesService.getSalesEvolutionYear();
      purchasesEvolutionMonth = await salesService.getPurchasesEvolutionMonth();
      purchasesEvolutionYear = await salesService.getPurchasesEvolutionYear();
      profitsEvolutionYear = await salesService.getProfitsEvolutionYear();
      setState(() {});
    } catch (e) {
      print('Error loading data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
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
                        width: double.infinity,
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.green, width: 2),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Column(
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.auto_graph_outlined,
                                          size: 50,
                                          color: AppColors.green,
                                        ),
                                        Text(
                                          ' EVOULUTION ANALYTICS',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 25,
                                              color: AppColors.grey),
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    CustomInputCard(
                                        icon: Icons.monetization_on,
                                        label: "SALES EVOULUTION PER MONTH",
                                        value:
                                            "${salesEvolutionMonth.toStringAsFixed(2)} %",
                                        label2: "SALES EVOULUTION PER YEAR",
                                        value2:
                                            "${salesEvolutionYear.toStringAsFixed(2)} %"),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    CustomInputCard(
                                        icon: Icons.shopping_bag,
                                        label: "PURSHASES EVOULUTION PER MONTH",
                                        value:
                                            "${purchasesEvolutionMonth.toStringAsFixed(2)} %",
                                        label2: "PURSHASES EVOULUTION PER YEAR",
                                        value2:
                                            "${purchasesEvolutionYear.toStringAsFixed(2)}%"),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    CustomInputCard2(
                                        icon: Icons.trending_up,
                                        label2: "PROFITS EVOULUTION PER YEAR",
                                        value2:
                                            "${profitsEvolutionYear.toStringAsFixed(2)}%"),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Text(
                                      'SALES IN LAST 5 DAYS',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
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
                            SizedBox(
                              height: 50,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Container(
                                  width: 400,
                                  height: 500,
                                  child: Column(
                                    children: [
                                      Text("BEST SELLING PRODUCTS"),
                                      Container(
                                        child: Column(
                                          children: produtcs
                                              .asMap()
                                              .entries
                                              .map((entry) {
                                            int index = entry.key + 1;
                                            Product product = entry.value;
                                            return Container(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Container(
                                                  color: AppColors.lightGrey,
                                                  child: Row(
                                                    children: [
                                                      Expanded(
                                                        child: Container(
                                                          child: Text(
                                                            '$index',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                          child: Text(
                                                        product.description,
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      )),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: 400,
                                  height: 500,
                                  child: Column(
                                    children: [
                                      Text("BEST CLIENTS MONTH"),
                                      Container(
                                        child: Column(
                                          children: clientsMONTH
                                              .asMap()
                                              .entries
                                              .map((entry) {
                                            int index = entry.key + 1;
                                            ClientT client = entry.value;
                                            return Container(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Container(
                                                  color: AppColors.lightGrey,
                                                  child: Row(
                                                    children: [
                                                      Expanded(
                                                        child: Container(
                                                          child: Text(
                                                            '$index',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                          child: Text(
                                                        '${client.name} ${client.familyName}',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      )),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: 400,
                                  height: 500,
                                  child: Column(
                                    children: [
                                      Text("BEST CLIENTS YEAR"),
                                      Container(
                                        child: Column(
                                          children: clientsYEAR
                                              .asMap()
                                              .entries
                                              .map((entry) {
                                            int index = entry.key + 1;
                                            ClientT client = entry.value;
                                            return Container(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Container(
                                                  color: AppColors.lightGrey,
                                                  child: Row(
                                                    children: [
                                                      Expanded(
                                                        child: Container(
                                                          child: Text(
                                                            '$index',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                          child: Text(
                                                        '${client.name} ${client.familyName}',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      )),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )
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
