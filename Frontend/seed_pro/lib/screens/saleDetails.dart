import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:seed_pro/globales.dart';
import 'package:seed_pro/models/extandedsale_model.dart';

import 'package:seed_pro/models/product_model.dart';

import 'package:seed_pro/models/saleproduct_model.dart';
import 'package:seed_pro/screens/salePayment.dart';
import 'package:seed_pro/services/ExtandedSale_service.dart';
import 'package:seed_pro/services/SaleProductApi_service.dart';
import 'package:seed_pro/services/product_service.dart';
import 'package:seed_pro/widgets/appBar.dart';
import 'package:seed_pro/widgets/button.dart';
import 'package:seed_pro/widgets/colors.dart';
import 'package:seed_pro/widgets/sidebar.dart';

class SaleDetails extends StatefulWidget {
  ExtendedSale sale;
  SaleDetails({Key? key, required this.sale}) : super(key: key);

  @override
  State<SaleDetails> createState() => _SaleDetailsState();
}

class _SaleDetailsState extends State<SaleDetails> {
  late List<Product> products = [];
  late List<SaleProduct> saleProducts = [];
  int i = 0;

  late Product selectedProduct;

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

  Future<void> deleteProduts(int saleId) async {
    saleProducts.clear();
    await SaleProductApi(baseurl).deleteSaleProduct(saleId);
    var newTotal = await getTotal();

    var updatedSale = ExtendedSale(
      id: widget.sale.id,
      clientName: widget.sale.clientName,
      total: newTotal,
      client: widget.sale.client,
      date: widget.sale.date,
      clientFirstName: widget.sale.clientFirstName,
      amountPaid: widget.sale.amountPaid,
      amountNotPaid: widget.sale.amountNotPaid,
    );
    setState(() {
      widget.sale = updatedSale;
      i = 0;
    });
    loadSaleProducts();
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

  Future<double> getTotal() async {
    var sales = await ExtendedSaleApi(baseurl).getAllSalesInfo();
    var sale = sales.firstWhere((element) => element.id == widget.sale.id);

    return sale.total;
  }

  void _showAddSaleProductDialog() async {
    List<Product> allProducts = await ProductApi(baseurl).getProducts();
    setState(() {
      i = 0;
    });

    int quantitySold = 1;

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
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Autocomplete<Product>(
                    optionsBuilder: (TextEditingValue textEditingValue) {
                      return allProducts.where((product) =>
                          '${product.reference} ${product.description}'
                              .toLowerCase()
                              .contains(textEditingValue.text.toLowerCase()));
                    },
                    onSelected: (Product selectedProduct) {
                      setState(() {
                        this.selectedProduct = selectedProduct;
                      });
                    },
                    displayStringForOption: (Product product) =>
                        '${product.reference} ${product.description}',
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
                          labelText: 'Search for Product',
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
                      AutocompleteOnSelected<Product> onSelected,
                      Iterable<Product> options,
                    ) {
                      return Container(
                        color: Colors.red,
                        width: 60, // Set the desired width
                        child: Material(
                          child: Container(
                            width: 200,
                            child: SingleChildScrollView(
                              child: Column(
                                children: options.map((product) {
                                  return Container(
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(color: Colors.grey),
                                      ),
                                    ),
                                    child: ListTile(
                                      title: Text(
                                        '${product.reference} ${product.description}',
                                        style: TextStyle(
                                          color: AppColors.black,
                                          fontSize: 16.0,
                                        ),
                                      ),
                                      onTap: () {
                                        onSelected(product);
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Quantity:',
                        style: TextStyle(fontSize: 16),
                      ),
                      Container(
                        width: 50,
                        child: TextFormField(
                          initialValue: '1',
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            quantitySold = int.tryParse(value) ?? 1;
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  CustomElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      _handleAddSaleProduct(selectedProduct, quantitySold);
                    },
                    buttonText: "Add Sale Item",
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _handleAddSaleProduct(
      Product? selectedProduct, int quantitySold) async {
    if (selectedProduct != null) {
      var newsaletem = SaleProduct(
          id: 0,
          quantitySold: quantitySold,
          productId: selectedProduct.id,
          saleId: widget.sale.id);
      await addSalesProduct(newsaletem);
      var newTotal = await getTotal();
      setState(() {
        i = 0;
      });
      var updatedSale = ExtendedSale(
        id: widget.sale.id,
        clientName: widget.sale.clientName,
        total: newTotal,
        client: widget.sale.client,
        date: widget.sale.date,
        clientFirstName: widget.sale.clientFirstName,
        amountPaid: widget.sale.amountPaid,
        amountNotPaid: widget.sale.amountNotPaid,
      );
      setState(() {
        widget.sale = updatedSale;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Product selected: ${selectedProduct.reference} '),
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select a Product'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Future<SaleProduct> addSalesProduct(SaleProduct newSaleProduct) async {
    var newsale = await SaleProductApi(baseurl).AddSaleProduct(newSaleProduct);
    loadSaleProducts();

    return newsale;
  }

  Future<void> _showEditSaleProductDialog(SaleProduct saleProduct) async {
    List<Product> allProducts = await ProductApi(baseurl).getProducts();
    setState(() {
      i = 0;
    });
    int quantitySold = saleProduct.quantitySold;

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
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Autocomplete<Product>(
                    optionsBuilder: (TextEditingValue textEditingValue) {
                      return allProducts.where((product) =>
                          '${product.reference} ${product.description}'
                              .toLowerCase()
                              .contains(textEditingValue.text.toLowerCase()));
                    },
                    onSelected: (Product selectedProduct) {
                      setState(() {
                        this.selectedProduct = selectedProduct;
                      });
                    },
                    displayStringForOption: (Product product) =>
                        '${product.reference} ${product.description}',
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
                          labelText: 'Search for Product',
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
                      AutocompleteOnSelected<Product> onSelected,
                      Iterable<Product> options,
                    ) {
                      return Container(
                        color: Colors.red,
                        width: 60, // Set the desired width
                        child: Material(
                          child: Container(
                            width: 200,
                            child: SingleChildScrollView(
                              child: Column(
                                children: options.map((product) {
                                  return Container(
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(color: Colors.grey),
                                      ),
                                    ),
                                    child: ListTile(
                                      title: Text(
                                        '${product.reference} ${product.description}',
                                        style: TextStyle(
                                          color: AppColors.black,
                                          fontSize: 16.0,
                                        ),
                                      ),
                                      onTap: () {
                                        onSelected(product);
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Quantity:',
                        style: TextStyle(fontSize: 16),
                      ),
                      Container(
                        width: 50,
                        child: TextFormField(
                          initialValue: quantitySold.toString(),
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            quantitySold = int.tryParse(value) ?? 1;
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  CustomElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      _handleEditSaleProduct(saleProduct, quantitySold);
                    },
                    buttonText: "Edit Sale Item",
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _handleEditSaleProduct(
      SaleProduct saleProduct, int quantitySold) async {
    if (selectedProduct != null) {
      var updatedSaleProduct = SaleProduct(
        id: saleProduct.id,
        quantitySold: quantitySold,
        productId: selectedProduct.id,
        saleId: widget.sale.id,
      );
      await updateSalesProduct(updatedSaleProduct);
      var newTotal = await getTotal();
      setState(() {
        i = 0;
      });
      var updatedSale = ExtendedSale(
        id: widget.sale.id,
        clientName: widget.sale.clientName,
        total: newTotal,
        client: widget.sale.client,
        date: widget.sale.date,
        clientFirstName: widget.sale.clientFirstName,
        amountPaid: widget.sale.amountPaid,
        amountNotPaid: widget.sale.amountNotPaid,
      );
      setState(() {
        widget.sale = updatedSale;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Product edited: ${selectedProduct.reference} '),
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select a Product'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Future<SaleProduct> updateSalesProduct(SaleProduct updatedSaleProduct) async {
    var updatedSale =
        await SaleProductApi(baseurl).updateSaleProduct(updatedSaleProduct);
    loadSaleProducts();

    return updatedSale;
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
                            onPressed: _showAddSaleProductDialog,
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
                        double subtotal =
                            product.sellingPrice * sl.quantitySold;
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
                                    onPressed: () {
                                      _showEditSaleProductDialog(sl);
                                    },
                                    icon: Icon(Icons.edit),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      deleteProduts(sl.id);
                                      setState(() {
                                        i = 0;
                                      });
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
                            // Handle onTap
                          },
                        );
                      }).toList(),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          CustomElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          SalePaymentScreen(sale: widget.sale),
                                    ));
                              },
                              buttonText: "Pay Sale"),
                          Text(
                            "TOTAL : ${widget.sale.total}",
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
