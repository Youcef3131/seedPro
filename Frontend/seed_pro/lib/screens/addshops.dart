import 'package:flutter/material.dart';
import 'package:seed_pro/globales.dart';
import 'package:seed_pro/models/shop_model.dart';
import 'package:seed_pro/services/shop_service.dart';
import 'package:seed_pro/widgets/appBar.dart';
import 'package:seed_pro/widgets/button.dart';
import 'package:seed_pro/widgets/colors.dart';
import 'package:seed_pro/widgets/sidebar.dart';

class Addshops extends StatefulWidget {
  const Addshops({Key? key}) : super(key: key);

  @override
  _AddshopsState createState() => _AddshopsState();
}

class _AddshopsState extends State<Addshops> {
  List<Shop> shops = [];
  final ShopApi shopApi;

  _AddshopsState()
      : shopApi = ShopApi(baseurl),
        super();

  @override
  void initState() {
    super.initState();
    loadShops();
  }

  Future<void> loadShops() async {
    try {
      shops = await shopApi.getShops();
      setState(() {});
    } catch (e) {
      print('Error loading shops: $e');
    }
  }

  void _showAddShopDialog() async {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController locationController = TextEditingController();
    bool isMaster = false;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              backgroundColor: AppColors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: SingleChildScrollView(
                child: Container(
                  width: 300,
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildTextField(
                        controller: nameController,
                        labelText: 'Shop Name',
                      ),
                      SizedBox(height: 10),
                      _buildTextField(
                        controller: locationController,
                        labelText: 'Location',
                      ),
                      SizedBox(height: 10),
                      _buildIsMasterCheckbox(
                        isMaster: isMaster,
                        onChanged: (value) {
                          setState(() {
                            isMaster = value ?? false;
                          });
                        },
                      ),
                      CustomElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          _handleAddShop(
                            nameController.text,
                            locationController.text,
                            isMaster,
                          );
                        },
                        buttonText: 'Add Shop',
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
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
  }

  Widget _buildIsMasterCheckbox({
    required bool isMaster,
    required ValueChanged<bool?> onChanged,
  }) {
    return Row(
      children: [
        Checkbox(
          value: isMaster,
          onChanged: onChanged,
        ),
        Text('Is Master'),
      ],
    );
  }

  void _handleAddShop(String name, String location, bool isMaster) async {
    try {
      Shop newShop = Shop(
        id: 0,
        name: name,
        address: location,
        isMaster: isMaster,
      );

      Shop createdShop = await shopApi.addShop(newShop);
      loadShops();

      print('Shop added successfully: ${createdShop.name}');
    } catch (e) {
      print('Error adding shop: $e');
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
                        Text(
                          'Shops',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: AppColors.grey,
                          ),
                        ),
                        CustomElevatedButton(
                          onPressed: _showAddShopDialog,
                          buttonText: 'Add Shop',
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(
                            child: Text(
                              "Shop Name",
                              style: TextStyle(
                                  fontSize: 20, color: AppColors.grey),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              "Address",
                              style: TextStyle(
                                  fontSize: 20, color: AppColors.grey),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              "Master / Slave",
                              style: TextStyle(
                                  fontSize: 20, color: AppColors.grey),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  _buildShopsList(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShopsList() {
    return Column(
      children: shops.map((shop) {
        return GestureDetector(
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              color: AppColors.lightGrey,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: Text(
                      shop.name,
                      style: TextStyle(fontSize: 20, color: AppColors.grey),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      shop.address,
                      style: TextStyle(fontSize: 20, color: AppColors.grey),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      shop.isMaster ? "Master" : "Slave",
                      style: TextStyle(fontSize: 20, color: AppColors.grey),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
