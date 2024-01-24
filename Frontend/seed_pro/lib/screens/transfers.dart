import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:seed_pro/globales.dart';
import 'package:seed_pro/models/Trensfer_model.dart';
import 'package:seed_pro/models/shop_model.dart';
import 'package:seed_pro/services/authentication_service.dart';
import 'package:seed_pro/services/transfer_service.dart';
import 'package:seed_pro/services/shop_service.dart';
import 'package:seed_pro/widgets/appBar.dart';
import 'package:seed_pro/widgets/button.dart';
import 'package:seed_pro/widgets/colors.dart';
import 'package:seed_pro/widgets/sidebar.dart';

class Transfers extends StatefulWidget {
  const Transfers({Key? key}) : super(key: key);

  @override
  State<Transfers> createState() => _TransfersState();
}

class _TransfersState extends State<Transfers> {
  List<Transfer> transfers = [];
  List<Shop> shops = [];
  late TextEditingController sourceShopController;
  late TextEditingController destShopController;

  @override
  void initState() {
    super.initState();
    loadTransfers();
    loadShops();

    sourceShopController = TextEditingController();
    destShopController = TextEditingController();
  }

  Future<void> loadTransfers() async {
    try {
      transfers = await TransferApi(baseurl).getTransfers();
      transfers = transfers.reversed.toList();
      setState(() {});
    } catch (e) {
      print("Error loading transfers: $e");
    }
  }

  Future<void> loadShops() async {
    try {
      shops = await ShopApi(baseurl).getShops();
      setState(() {});
    } catch (e) {
      print("Error loading shops: $e");
    }
  }

  Future<void> deleteTransfer(int transferId) async {
    try {
      await TransferApi(baseurl).deleteTransfer(transferId);
      loadTransfers();
    } catch (e) {
      print("Error deleting transfer: $e");
    }
  }

  void _showAddTransferDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Container(
            width: 400,
            padding: const EdgeInsets.all(16.0),
            child: AddTransferForm(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
                              'Transfers',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            CustomElevatedButton(
                              onPressed: () {
                                _showAddTransferDialog(context);
                              },
                              buttonText: 'Add Transfer',
                            )
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
                                    fontSize: 20,
                                    color: AppColors.grey,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              child: Expanded(
                                child: Text(
                                  'Source Shop',
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
                                  'Destination Shop',
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
                          ],
                        ),
                      ),
                      Column(
                        children: transfers.map((tr) {
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
                                              .format(tr.date),
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
                                          shops
                                              .firstWhere((shop) =>
                                                  shop.id == tr.sourceShop)
                                              .name,
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
                                          shops
                                              .firstWhere((shop) =>
                                                  shop.id == tr.destShop)
                                              .name,
                                          style: TextStyle(
                                            fontSize: 20,
                                            color: AppColors.grey,
                                          ),
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () async {
                                        print(tr.id.toString());
                                        await deleteTransfer(tr.id);
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
                            onTap: () {},
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
      ),
    );
  }
}

class AddTransferForm extends StatefulWidget {
  const AddTransferForm({Key? key}) : super(key: key);

  @override
  State<AddTransferForm> createState() => _AddTransferFormState();
}

class _AddTransferFormState extends State<AddTransferForm> {
  String? selectedSourceShop;
  Shop? selectedDestShop;
  List<Transfer> transfers = [];
  List<Shop> shops = [];

  @override
  void initState() {
    super.initState();
    loadTransfers();
    loadShops();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: 10),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0),
            border: Border.all(
              color: Colors.grey,
              width: 1.0,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                "Destination Shop",
                style: TextStyle(color: AppColors.black),
              ),
              DropdownButton<Shop>(
                value: selectedDestShop,
                items: shops.map((Shop shop) {
                  return DropdownMenuItem<Shop>(
                    value: shop,
                    child: Text(shop.name),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedDestShop = value;
                  });
                },
              ),
            ],
          ),
        ),
        SizedBox(height: 10),
        CustomElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
            _handleAddTransfer(context);
          },
          buttonText: 'Add Transfer',
        ),
      ],
    );
  }

  Future<void> _handleAddTransfer(BuildContext context) async {
    selectedSourceShop = await getShopIdFromPrefs();
    if (selectedDestShop != null) {
      bool isValidDest = shops.contains(selectedDestShop);

      if (isValidDest) {
        Transfer newTransfer = Transfer(
          id: 0,
          date: DateTime.now(),
          sourceShop: int.tryParse(selectedSourceShop!) ?? 0,
          destShop: selectedDestShop!.id,
        );

        try {
          await addTransfer(newTransfer);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Transfer added successfully'),
              duration: Duration(seconds: 2),
            ),
          );

          loadTransfers();
          Navigator.pushReplacementNamed(context, '/transfers');
        } catch (e) {
          print("Error adding transfer: $e");
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Invalid  destination shop'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select destination shop'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> addTransfer(Transfer newTransfer) async {
    try {
      await TransferApi(baseurl).createTransfer(newTransfer);
    } catch (e) {
      print("Error adding transfer: $e");
      rethrow;
    }
  }

  Future<void> loadTransfers() async {
    try {
      transfers = await TransferApi(baseurl).getTransfers();
      transfers = transfers.reversed.toList();
      setState(() {});
    } catch (e) {
      print("Error loading transfers: $e");
    }
  }

  Future<void> loadShops() async {
    try {
      shops = await ShopApi(baseurl).getShops();
      setState(() {});
    } catch (e) {
      print("Error loading shops: $e");
    }
  }
}
