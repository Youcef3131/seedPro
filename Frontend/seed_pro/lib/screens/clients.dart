import 'package:flutter/material.dart';
import 'package:seed_pro/globales.dart';
import 'package:seed_pro/models/cleint_model.dart';
import 'package:seed_pro/services/cleint_service.dart';
import 'package:seed_pro/widgets/appBar.dart';
import 'package:seed_pro/widgets/button.dart';
import 'package:seed_pro/widgets/colors.dart';
import 'package:seed_pro/widgets/sidebar.dart';

class Clients extends StatefulWidget {
  const Clients({super.key});

  @override
  State<Clients> createState() => _ClientsState();
}

class _ClientsState extends State<Clients> {
  late List<Client> clients = [];

  @override
  void initState() {
    super.initState();
    loadClients();
  }

  Future<void> loadClients() async {
    clients = await ClientApi(baseurl).getClientsInShop();

    setState(() {});
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
                            onPressed: () {}, buttonText: 'Add Clients')
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
                                          fontSize: 20, color: AppColors.grey),
                                    ),
                                  ),
                                ),
                                Container(
                                  child: Expanded(
                                    child: Text(
                                      cl.familyName,
                                      style: TextStyle(
                                          fontSize: 20, color: AppColors.grey),
                                    ),
                                  ),
                                ),
                                Container(
                                  child: Expanded(
                                    child: Text(
                                      cl.phone.toString(),
                                      style: TextStyle(
                                          fontSize: 20, color: AppColors.grey),
                                    ),
                                  ),
                                ),
                                Container(
                                  child: Expanded(
                                    child: Text(
                                      cl.address,
                                      style: TextStyle(
                                          fontSize: 20, color: AppColors.grey),
                                    ),
                                  ),
                                ),
                                Container(
                                  child: Expanded(
                                    child: Text(
                                      cl.email,
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
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
