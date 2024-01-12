import 'package:flutter/material.dart';
import 'package:seed_pro/globales.dart';
import 'package:seed_pro/models/ProductDetails.dart';
import 'package:seed_pro/services/productdetails_service.dart';
import 'package:seed_pro/widgets/appBar.dart';
import 'package:seed_pro/widgets/button.dart';
import 'package:seed_pro/widgets/colors.dart';
import 'package:seed_pro/widgets/sidebar.dart';

class Products extends StatefulWidget {
  const Products({super.key});

  @override
  State<Products> createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  late List<ProductDetails> products = [];
  @override
  void initState() {
    super.initState();
    loadProducts();
  }

  Future<void> loadProducts() async {
    products = await ProductDetailsApi(baseurl).getProductsInShop();

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
                          'PRODUCTS',
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        CustomElevatedButton(
                            onPressed: () {}, buttonText: 'Add Product')
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        child: Expanded(
                          child: Text(
                            'Reference',
                            style:
                                TextStyle(fontSize: 20, color: AppColors.grey),
                          ),
                        ),
                      ),
                      Container(
                        child: Expanded(
                          child: Text(
                            'Description',
                            style:
                                TextStyle(fontSize: 20, color: AppColors.grey),
                          ),
                        ),
                      ),
                      Container(
                        child: Expanded(
                          child: Text(
                            'Selling price',
                            style:
                                TextStyle(fontSize: 20, color: AppColors.grey),
                          ),
                        ),
                      ),
                      Container(
                        child: Expanded(
                          child: Text(
                            'Quantity',
                            style:
                                TextStyle(fontSize: 20, color: AppColors.grey),
                          ),
                        ),
                      ),
                      Container(
                        child: Expanded(
                          child: Text(
                            'Buying price',
                            style:
                                TextStyle(fontSize: 20, color: AppColors.grey),
                          ),
                        ),
                      ),
                      SizedBox(width: 20),
                    ],
                  ),
                  SingleChildScrollView(
                    child: Column(
                      children: products.map((pr) {
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
                                      pr.reference,
                                      style: TextStyle(
                                          fontSize: 20, color: AppColors.grey),
                                    ),
                                  ),
                                ),
                                Container(
                                  child: Expanded(
                                    child: Text(
                                      pr.description,
                                      style: TextStyle(
                                          fontSize: 20, color: AppColors.grey),
                                    ),
                                  ),
                                ),
                                Container(
                                  child: Expanded(
                                    child: Text(
                                      pr.buyingPrice.toString(),
                                      style: TextStyle(
                                          fontSize: 20, color: AppColors.grey),
                                    ),
                                  ),
                                ),
                                Container(
                                  child: Expanded(
                                    child: Text(
                                      pr.quantity.toString(),
                                      style: TextStyle(
                                          fontSize: 20, color: AppColors.grey),
                                    ),
                                  ),
                                ),
                                Container(
                                  child: Expanded(
                                    child: Text(
                                      pr.sellingPrice.toString(),
                                      style: TextStyle(
                                          fontSize: 20, color: AppColors.grey),
                                    ),
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    print('Edit Product pressed for ${pr.id}');
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
                        );
                      }).toList(),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
