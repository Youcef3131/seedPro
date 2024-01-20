import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:seed_pro/globales.dart';
import 'package:seed_pro/models/extandedsale_model.dart';

import 'package:seed_pro/models/product_model.dart';

import 'package:seed_pro/models/saleproduct_model.dart';
import 'package:seed_pro/services/SaleProductApi_service.dart';
import 'package:seed_pro/services/product_service.dart';
import 'package:seed_pro/widgets/appBar.dart';
import 'package:seed_pro/widgets/button.dart';
import 'package:seed_pro/widgets/colors.dart';
import 'package:seed_pro/widgets/sidebar.dart';

class SaleDetails extends StatefulWidget {
  final ExtendedSale sale;
  const SaleDetails({Key? key, required this.sale}) : super(key: key);

  @override
  State<SaleDetails> createState() => _SaleDetailsState();
}

class _SaleDetailsState extends State<SaleDetails> {
  late List<Product> products = [];
  late List<SaleProduct> saleProducts = [];
  int i = 0;

  Product findProductById(List<Product> productList, int idToFind) {
    return productList.firstWhere((product) => product.id == idToFind);
  }

  @override
  void initState() {
    super.initState();
    loadProducts();
    loadSaleProducts();
    i = 0;
  }

  Future<void> loadProducts() async {
    products = await ProductApi(baseurl).getProducts();

    setState(() {});
  }

  Future<void> loadSaleProducts() async {
    try {
      saleProducts =
          await SaleProductApi(baseurl).getSaleProductsBySaleId(widget.sale.id);

      setState(() {});
    } catch (e) {
      print('Error loading sale products: $e');
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
                          IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Icon(
                              Icons.arrow_back,
                              color:
                                  Colors.black, // Add your preferred icon color
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
                            onPressed: () {},
                            buttonText: 'Add Sale item',
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
                                'Reference',
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
                                'Descreption',
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
                                'Price',
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
                                'Quantity',
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
                                'Subtotal',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: AppColors.grey,
                                ),
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.edit),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.delete),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: saleProducts.map((sl) {
                        Product product =
                            findProductById(products, sl.productId);
                        double subtotal = product.buyingPrice * sl.quantitySold;
                        i++;
                        return GestureDetector(
                          child: Padding(
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
                                        product.reference,
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
                                        product.description,
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
                                        product.sellingPrice.toString(),
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
                                        sl.quantitySold.toString(),
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
                                        subtotal.toString(),
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: AppColors.grey,
                                        ),
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {},
                                    icon: Icon(Icons.edit),
                                  ),
                                  IconButton(
                                    onPressed: () {},
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
                            // Handle onTap
                          },
                        );
                      }).toList(),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            "TOTAL : ${widget.sale.total.toString()}",
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.red,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    )
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
