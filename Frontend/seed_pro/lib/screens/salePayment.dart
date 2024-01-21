import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:seed_pro/globales.dart';
import 'package:seed_pro/models/extandedsale_model.dart';
import 'package:seed_pro/models/salePayment_model.dart';
import 'package:seed_pro/services/ExtandedSale_service.dart';

import 'package:seed_pro/widgets/appBar.dart';
import 'package:seed_pro/widgets/button.dart';
import 'package:seed_pro/widgets/colors.dart';
import 'package:seed_pro/widgets/sidebar.dart';

import '../services/SalePayment_service.dart';

class SalePaymentScreen extends StatefulWidget {
  ExtendedSale sale;

  SalePaymentScreen({Key? key, required this.sale}) : super(key: key);

  @override
  State<SalePaymentScreen> createState() => _SalePaymentScreenState();
}

class _SalePaymentScreenState extends State<SalePaymentScreen> {
  List<SalePayment> salePayments = [];
  int i = 0;

  double totalPayments = 0;
  TextEditingController amountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadPayments();

    i = 0;
  }

  Future<void> loadPayments() async {
    try {
      List<SalePayment> loadedPayments = (await SalePaymentApi(baseurl)
              .getSalePaymentsBySaleId(widget.sale.id))
          .cast<SalePayment>();

      setState(() {
        salePayments = loadedPayments;
        totalPayments =
            salePayments.fold(0, (sum, payment) => sum + payment.amount);
        i = 0;
      });
    } catch (e) {
      print('Error loading sale payments: $e');
    }
  }

  Future<void> _addSalePayment(double amount) async {
    try {
      await SalePaymentApi(baseurl).createSalePayment(
        SalePayment(
          date: DateTime.now(),
          amount: amount,
          sale: widget.sale.id,
          id: 0,
        ),
      );
      var newsale = await getTSale();

      loadPayments();

      setState(() {
        widget.sale = newsale;
      });
      setState(() {
        totalPayments =
            salePayments.fold(0, (sum, payment) => sum + payment.amount);

        i = 0;
      });
    } catch (e) {
      print('Error adding sale payment: $e');
    }
  }

  Future<ExtendedSale> getTSale() async {
    var sales = await ExtendedSaleApi(baseurl).getAllSalesInfo();
    var sale = sales.firstWhere((element) => element.id == widget.sale.id);

    return sale;
  }

  Future<void> _deleteSalePayment(SalePayment salePayment) async {
    try {
      await SalePaymentApi(baseurl).deleteSalePayment(salePayment.id);

      var newsale = await getTSale();

      loadPayments();

      setState(() {
        widget.sale = newsale;
      });
    } catch (e) {
      print('Error deleting sale payment: $e');
    }
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
              child: Column(
                children: [
                  appBar(),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(
                            Icons.arrow_back,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          'Sales Number: ${widget.sale.id}',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Client: ${widget.sale.clientFirstName} ${widget.sale.clientName}',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Date: ${DateFormat('yyyy-MM-dd HH:mm').format(widget.sale.date)}',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        CustomElevatedButton(
                          onPressed: () {
                            _showAddPaymentDialog();
                          },
                          buttonText: 'Add Sale Payment',
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: [
                        Container(
                          child: Expanded(
                            child: Text(
                              'N°',
                              style: TextStyle(
                                fontSize: 20,
                                color: AppColors.grey,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          child: Expanded(
                            child: Text(
                              'Date',
                              style: TextStyle(
                                fontSize: 20,
                                color: AppColors.grey,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          child: Expanded(
                            child: Text(
                              'Ammount',
                              style: TextStyle(
                                fontSize: 20,
                                color: AppColors.grey,
                              ),
                            ),
                          ),
                        ),

                        IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.delete),
                        ),
                        // Add an empty SizedBox to accommodate the delete icon
                      ],
                    ),
                  ),
                  Column(
                    children: salePayments.map((salePayment) {
                      i++;

                      return Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          color: AppColors.lightGrey,
                          child: Row(
                            children: [
                              Container(
                                child: Expanded(
                                  child: Text(
                                    i.toString(),
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: AppColors.grey,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                child: Expanded(
                                  child: Text(
                                    DateFormat('yyyy-MM-dd HH:mm')
                                        .format(salePayment.date),
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: AppColors.grey,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                child: Expanded(
                                  child: Text(
                                    salePayment.amount.toString(),
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: AppColors.grey,
                                    ),
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  _deleteSalePayment(salePayment);
                                },
                                icon: Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          "TOTAL payments : $totalPayments",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Ammount Not paid : ${widget.sale.total - double.parse(widget.sale.amountPaid)} ',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showAddPaymentDialog() async {
    double amount = 0.0;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: SingleChildScrollView(
            child: Container(
              width: 200,
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Text(
                    'Add Sale Payment',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: amountController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Amount',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      amount = double.tryParse(value) ?? 0.0;
                    },
                  ),
                  SizedBox(height: 20),
                  CustomElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _addSalePayment(amount);
                      amountController.clear();
                    },
                    buttonText: 'Add Payment',
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
