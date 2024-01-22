import 'package:flutter/material.dart';
import 'package:seed_pro/globales.dart';
import 'package:seed_pro/models/cleint_model.dart';
import 'package:seed_pro/services/authentication_service.dart';
import 'package:seed_pro/services/cleint_service.dart';
import 'package:seed_pro/widgets/appBar.dart';
import 'package:seed_pro/widgets/button.dart';
import 'package:seed_pro/widgets/colors.dart';
import 'package:seed_pro/widgets/sidebar.dart';

class ClientsScreen extends StatefulWidget {
  const ClientsScreen({super.key});

  @override
  State<ClientsScreen> createState() => _ClientsScreenState();
}

class _ClientsScreenState extends State<ClientsScreen> {
  late List<ClientT> clients = [];
  TextEditingController nameController = TextEditingController();
  TextEditingController familyNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadClients();
  }

  Future<void> loadClients() async {
    clients = await ClientApi(baseurl).getClientsInShop();

    setState(() {});
  }

  bool isValidEmail(String email) {
    final RegExp emailRegex =
        RegExp(r'^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');

    return emailRegex.hasMatch(email);
  }

  Future<void> addClient() async {
    if (nameController.text.isEmpty ||
        familyNameController.text.isEmpty ||
        phoneController.text.isEmpty ||
        addressController.text.isEmpty ||
        emailController.text.isEmpty) {
      return;
    }
    if (!isValidEmail(emailController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Invalid email address'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    String? shopIdString = await getShopIdFromPrefs();

    int? shopId;
    try {
      shopId = int.parse(shopIdString ?? '');
    } catch (e) {
      print("Error parsing shopId: $e");
      return;
    }

    ClientT newClient = ClientT(
      id: 0,
      familyName: familyNameController.text,
      phone: phoneController.text,
      name: nameController.text,
      address: addressController.text,
      email: emailController.text,
      shop: shopId,
    );

    ClientT createdClient = await ClientApi(baseurl).createClient(newClient);
    nameController.clear();
    familyNameController.clear();
    phoneController.clear();
    addressController.clear();
    emailController.clear();

    await loadClients();
  }

  void _showAddClientDialog() {
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
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Name',
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
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: familyNameController,
                  decoration: InputDecoration(
                    labelText: 'Family Name',
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
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: phoneController,
                  decoration: InputDecoration(
                    labelText: 'Phone',
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
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: addressController,
                  decoration: InputDecoration(
                    labelText: 'Address',
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
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
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
                ),
                SizedBox(height: 10),
                CustomElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    addClient();
                  },
                  buttonText: "Add Client",
                )
              ],
            ),
          ),
        );
      },
    );
  }

  void _showUpdateClientDialog(ClientT client) {
    nameController.text = client.name;
    familyNameController.text = client.familyName;
    phoneController.text = client.phone;
    addressController.text = client.address;
    emailController.text = client.email;

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
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Name',
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
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: familyNameController,
                  decoration: InputDecoration(
                    labelText: 'Family Name',
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
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: phoneController,
                  decoration: InputDecoration(
                    labelText: 'Phone',
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
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: addressController,
                  decoration: InputDecoration(
                    labelText: 'Address',
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
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
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
                ),
                SizedBox(height: 10),
                CustomElevatedButton(
                  onPressed: () async {
                    ClientT updatedClient = ClientT(
                      id: client.id,
                      name: nameController.text,
                      familyName: familyNameController.text,
                      phone: phoneController.text,
                      address: addressController.text,
                      email: emailController.text,
                      shop: client.shop,
                    );

                    Navigator.of(context).pop();

                    await ClientApi(baseurl).updateClient(updatedClient);
                    loadClients();
                  },
                  buttonText: "Update Client",
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Container(
              width: 200.0,
              color: AppColors.lightGrey,
              child: Padding(
                  padding: const EdgeInsets.all(20.0), child: Sidebar())),
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
                            'CLIENTS',
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                          CustomElevatedButton(
                              onPressed: _showAddClientDialog,
                              buttonText: 'Add Clients')
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        children: [
                          Container(
                            child: Expanded(
                              child: Text(
                                'Name',
                                style: TextStyle(
                                    fontSize: 20, color: AppColors.grey),
                              ),
                            ),
                          ),
                          Container(
                            child: Expanded(
                              child: Text(
                                'Family Name',
                                style: TextStyle(
                                    fontSize: 20, color: AppColors.grey),
                              ),
                            ),
                          ),
                          Container(
                            child: Expanded(
                              child: Text(
                                'Phone',
                                style: TextStyle(
                                    fontSize: 20, color: AppColors.grey),
                              ),
                            ),
                          ),
                          Container(
                            child: Expanded(
                              child: Text(
                                'Address',
                                style: TextStyle(
                                    fontSize: 20, color: AppColors.grey),
                              ),
                            ),
                          ),
                          Container(
                            child: Expanded(
                              child: Text(
                                'Email',
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
                      children: clients.map((cl) {
                        return Container(
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Container(
                              color: AppColors.lightGrey,
                              child: Row(
                                children: [
                                  Container(
                                    child: Expanded(
                                      child: Text(
                                        cl.name,
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: AppColors.grey),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    child: Expanded(
                                      child: Text(
                                        cl.familyName,
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: AppColors.grey),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    child: Expanded(
                                      child: Text(
                                        cl.phone.toString(),
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: AppColors.grey),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    child: Expanded(
                                      child: Text(
                                        cl.address,
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: AppColors.grey),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    child: Expanded(
                                      child: Text(
                                        cl.email,
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: AppColors.grey),
                                      ),
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      _showUpdateClientDialog(cl);
                                    },
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
