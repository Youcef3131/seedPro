import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:seed_pro/globales.dart';
import 'package:seed_pro/models/cleint_model.dart';
import 'package:seed_pro/models/extandedsale_model.dart';
import 'package:seed_pro/models/sale_model.dart';
import 'package:seed_pro/screens/saleDetails.dart';
import 'package:seed_pro/services/ExtandedSale_service.dart';
import 'package:seed_pro/services/cleint_service.dart';
import 'package:seed_pro/services/sale_service.dart';
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
  TextEditingController clientController = TextEditingController();
  Client? selectedClient;
  @override
  void initState() {
    super.initState();
    loadSales();
  }

  Future<void> loadSales() async {
    sales = await ExtendedSaleApi(baseurl).getAllSalesInfo();
    sales = sales.reversed.toList();
    setState(() {});
  }

  Future<void> deletSales(int saleId) async {
    await SaleApi(baseurl).deleteSale(saleId);

    loadSales();
  }

  Future<Sale> addSales(Sale sale) async {
    Sale newsale = await SaleApi(baseurl).createSale(sale);

    loadSales();
    return newsale;
  }

  void _showAddSaleDialog() async {
    List<Client> allClients = await ClientApi(baseurl).getClientsInShop();

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
              width: 20,
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Autocomplete<Client>(
                    optionsBuilder: (TextEditingValue textEditingValue) {
                      return allClients.where((client) =>
                          '${client.name} ${client.familyName}'
                              .toLowerCase()
                              .contains(textEditingValue.text.toLowerCase()));
                    },
                    onSelected: (Client selectedClient) {
                      setState(() {
                        this.selectedClient = selectedClient;
                      });
                    },
                    displayStringForOption: (Client client) =>
                        '${client.name} ${client.familyName}',
                    fieldViewBuilder: (BuildContext context,
                        TextEditingController textEditingController,
                        FocusNode focusNode,
                        VoidCallback onFieldSubmitted) {
                      return TextField(
                        controller: textEditingController,
                        focusNode: focusNode,
                        onSubmitted: (value) {
                          onFieldSubmitted();
                        },
                        decoration: InputDecoration(
                          labelText: 'Search for Client',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          filled: true,
                          fillColor: AppColors.lightGrey,
                          labelStyle: TextStyle(color: AppColors.grey),
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 15.0,
                            horizontal: 16.0,
                          ),
                        ),
                      );
                    },
                    optionsViewBuilder: (
                      BuildContext context,
                      AutocompleteOnSelected<Client> onSelected,
                      Iterable<Client> options,
                    ) {
                      return Container(
                        color: Colors.red,
                        width: 60, // Set the desired width
                        child: Material(
                          child: Container(
                            width: 200,
                            child: SingleChildScrollView(
                              child: Column(
                                children: options.map((client) {
                                  return Container(
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(color: Colors.grey),
                                      ),
                                    ),
                                    child: ListTile(
                                      title: Text(
                                        '${client.name} ${client.familyName}',
                                        style: TextStyle(
                                          color: AppColors.black,
                                          fontSize: 16.0,
                                        ),
                                      ),
                                      onTap: () {
                                        onSelected(client);
                                      },
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 10),
                  CustomElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      _handleAddSale(selectedClient);
                    },
                    buttonText: "Add Sale",
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _handleAddSale(Client? selectedClient) async {
    if (selectedClient != null) {
      Sale newSale = Sale(
        id: 0,
        date: DateTime.now(),
        clientId: selectedClient.id,
        amountPaid: 0,
      );

      Sale newsalel = await addSales(newSale);
      var newextandedsale = ExtendedSale(
          id: newsalel.id,
          date: newsalel.date,
          client: newsalel.id,
          clientName: selectedClient.name,
          clientFirstName: selectedClient.familyName,
          amountPaid: "0",
          total: 0,
          amountNotPaid: 0);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Client selected: ${selectedClient.name} ${selectedClient.familyName}'),
          duration: Duration(seconds: 2),
        ),
      );
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SaleDetails(sale: newextandedsale),
          ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select a client'),
          duration: Duration(seconds: 2),
        ),
      );
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
                              onPressed: _showAddSaleDialog,
                              buttonText: 'Add Sale')
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
                          IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.delete),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: sales.map((sl) {
                        return GestureDetector(
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Container(
                              color: AppColors.lightGrey,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Container(
                                    child: Expanded(
                                      child: Text(
                                        DateFormat('yyyy-MM-dd HH:mm')
                                            .format(sl.date),
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: AppColors.grey),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    child: Expanded(
                                      child: Text(
                                        sl.clientName,
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: AppColors.grey),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    child: Expanded(
                                      child: Text(
                                        sl.clientFirstName,
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: AppColors.grey),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    child: Expanded(
                                      child: Text(
                                        sl.total.toString(),
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: AppColors.grey),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    child: Expanded(
                                      child: Text(
                                        sl.amountPaid.toString(),
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: AppColors.grey),
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () async {
                                      await deletSales(sl.id);
                                    },
                                    icon: Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return SaleDetails(sale: sl);
                                },
                              ),
                            );
                          },
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
