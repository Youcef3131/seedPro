import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:seed_pro/globales.dart';
import 'package:seed_pro/models/extandedsale_model.dart';
import 'package:seed_pro/services/ExtandedSale_service.dart';
import 'package:seed_pro/widgets/appBar.dart';
import 'package:seed_pro/widgets/button.dart';
import 'package:seed_pro/widgets/colors.dart';
import 'package:seed_pro/widgets/sidebar.dart';

class Sales extends StatefulWidget {
  const Sales({super.key});

  @override
  State<Sales> createState() => _SalesState();
}

class _SalesState extends State<Sales> {
  late List<ExtendedSale> sales = [];
  @override
  void initState() {
    super.initState();
    loadSales();
  }

  Future<void> loadSales() async {
    sales = await ExtendedSaleApi(baseurl).getAllSalesInfo();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
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
              child: Container(
                child: Column(
                  children: [
                    appBar(),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'SALES',
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                          CustomElevatedButton(
                              onPressed: () {}, buttonText: 'Add Sale')
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            child: Expanded(
                              child: Text(
                                'Date',
                                style: TextStyle(
                                    fontSize: 20, color: AppColors.grey),
                              ),
                            ),
                          ),
                          Container(
                            child: Expanded(
                              child: Text(
                                'Client Name',
                                style: TextStyle(
                                    fontSize: 20, color: AppColors.grey),
                              ),
                            ),
                          ),
                          Container(
                            child: Expanded(
                              child: Text(
                                'Client First Name',
                                style: TextStyle(
                                    fontSize: 20, color: AppColors.grey),
                              ),
                            ),
                          ),
                          Container(
                            child: Expanded(
                              child: Text(
                                'Total',
                                style: TextStyle(
                                    fontSize: 20, color: AppColors.grey),
                              ),
                            ),
                          ),
                          Container(
                            child: Expanded(
                              child: Text(
                                'Ammount Paid',
                                style: TextStyle(
                                    fontSize: 20, color: AppColors.grey),
                              ),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {},
                            child: Text(
                              'Edit',
                              style: TextStyle(color: AppColors.white),
                            ),
                            style: ElevatedButton.styleFrom(
                              primary: Colors.transparent,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: sales.map((sl) {
                        return Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Container(
                            color: AppColors.lightGrey,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Container(
                                  child: Expanded(
                                    child: Text(
                                      DateFormat('yyyy-MM-dd HH:mm')
                                          .format(sl.date),
                                      style: TextStyle(
                                          fontSize: 20, color: AppColors.grey),
                                    ),
                                  ),
                                ),
                                Container(
                                  child: Expanded(
                                    child: Text(
                                      sl.clientName,
                                      style: TextStyle(
                                          fontSize: 20, color: AppColors.grey),
                                    ),
                                  ),
                                ),
                                Container(
                                  child: Expanded(
                                    child: Text(
                                      sl.clientFirstName,
                                      style: TextStyle(
                                          fontSize: 20, color: AppColors.grey),
                                    ),
                                  ),
                                ),
                                Container(
                                  child: Expanded(
                                    child: Text(
                                      sl.total.toString(),
                                      style: TextStyle(
                                          fontSize: 20, color: AppColors.grey),
                                    ),
                                  ),
                                ),
                                Container(
                                  child: Expanded(
                                    child: Text(
                                      sl.amountPaid.toString(),
                                      style: TextStyle(
                                          fontSize: 20, color: AppColors.grey),
                                    ),
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () {},
                                  child: Text(
                                    'Edit',
                                    style: TextStyle(color: AppColors.white),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    primary: AppColors.green,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
