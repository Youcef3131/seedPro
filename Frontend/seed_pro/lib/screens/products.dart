import 'package:flutter/material.dart';
import 'package:seed_pro/globales.dart';
import 'package:seed_pro/models/ProductDetails.dart';
import 'package:seed_pro/models/category_model.dart';
import 'package:seed_pro/models/product_model.dart';
import 'package:seed_pro/models/productinshop_model.dart';
import 'package:seed_pro/services/authentication_service.dart';
import 'package:seed_pro/services/category_service.dart';
import 'package:seed_pro/services/product_service.dart';
import 'package:seed_pro/services/productdetails_service.dart';
import 'package:seed_pro/services/productinshop_service.dart';
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

  void _showAddProductDialog() {
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
            child: AddProductForm(),
          ),
        );
      },
    );
  }

  void _showUpdateProductDialog(Product product) {
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
            child: UpdateProductForm(
              product: product,
            ),
          ),
        );
      },
    );
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
                            'PRODUCTS',
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                          CustomElevatedButton(
                              onPressed: _showAddProductDialog,
                              buttonText: 'Add Product')
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
                                'Reference',
                                style: TextStyle(
                                    fontSize: 20, color: AppColors.grey),
                              ),
                            ),
                          ),
                          Container(
                            child: Expanded(
                              child: Text(
                                'Description',
                                style: TextStyle(
                                    fontSize: 20, color: AppColors.grey),
                              ),
                            ),
                          ),
                          Container(
                            child: Expanded(
                              child: Text(
                                'Selling price',
                                style: TextStyle(
                                    fontSize: 20, color: AppColors.grey),
                              ),
                            ),
                          ),
                          Container(
                            child: Expanded(
                              child: Text(
                                'Quantity',
                                style: TextStyle(
                                    fontSize: 20, color: AppColors.grey),
                              ),
                            ),
                          ),
                          Container(
                            child: Expanded(
                              child: Text(
                                'Buying price',
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
                                    _showUpdateProductDialog(new Product(
                                        id: pr.id,
                                        reference: pr.reference,
                                        description: pr.description,
                                        buyingPrice: pr.buyingPrice,
                                        sellingPrice: pr.sellingPrice,
                                        category: pr.category));
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

class AddProductForm extends StatefulWidget {
  const AddProductForm({Key? key}) : super(key: key);

  @override
  State<AddProductForm> createState() => _AddProductFormState();
}

class _AddProductFormState extends State<AddProductForm> {
  final TextEditingController referenceController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController buyingPriceController = TextEditingController();
  final TextEditingController sellingPriceController = TextEditingController();
  late Category? selectedCategory;
  List<Category> categories = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadCategories();
    selectedCategory = null;
  }

  Future<void> loadCategories() async {
    final categoryApi = CategoryApi(baseurl);
    final loadedCategories = await categoryApi.getCategories();

    setState(() {
      categories = loadedCategories;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (!isLoading) SizedBox(height: 10),
        TextFormField(
          controller: referenceController,
          decoration: InputDecoration(
            labelText: 'Reference',
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
          controller: descriptionController,
          decoration: InputDecoration(
            labelText: 'Description',
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
          controller: buyingPriceController,
          decoration: InputDecoration(
            labelText: 'Buying Price',
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
          keyboardType: TextInputType.number,
        ),
        SizedBox(height: 10),
        TextFormField(
          controller: sellingPriceController,
          decoration: InputDecoration(
            labelText: 'Selling Price',
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
          keyboardType: TextInputType.number,
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              "Category",
              style: TextStyle(color: AppColors.black),
            ),
            DropdownButton<Category>(
              value: selectedCategory,
              items: categories.map((Category category) {
                return DropdownMenuItem<Category>(
                  value: category,
                  child: Text(category.name),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedCategory = value;
                });
              },
            ),
          ],
        ),
        SizedBox(height: 10),
        CustomElevatedButton(
          onPressed: () {
            createProduct();
          },
          buttonText: "Add Product",
        ),
      ],
    );
  }

  Future<void> createProduct() async {
    final api = ProductApi(baseurl);
    final productinshopapi = ProductInShopApi(baseurl);

    if (selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select a category'),
        ),
      );
      return;
    }

    final newProduct = Product(
      id: 0,
      reference: referenceController.text,
      description: descriptionController.text,
      buyingPrice: double.parse(buyingPriceController.text),
      sellingPrice: double.parse(sellingPriceController.text),
      category: selectedCategory!.id,
    );

    print(newProduct.category);
    int? shop = int.tryParse(await getShopIdFromPrefs() as String);
    var newPoduct = await api.createProduct(newProduct);
    final newPoductInShop =
        ProductInShop(id: 0, quantity: 0, shop: shop!, product: newPoduct.id);
    await productinshopapi.createProductInShop(newPoductInShop);
    Navigator.popAndPushNamed(context, '/products');
    referenceController.clear();
    descriptionController.clear();
    sellingPriceController.clear();
    buyingPriceController.clear();
  }

  bool _validateFields() {
    if (referenceController.text.isEmpty ||
        descriptionController.text.isEmpty ||
        buyingPriceController.text.isEmpty ||
        sellingPriceController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill in all fields'),
        ),
      );
      return false;
    }
    return true;
  }
}

class UpdateProductForm extends StatefulWidget {
  const UpdateProductForm({super.key, required this.product});
  final Product product;

  @override
  State<UpdateProductForm> createState() => _UpdateProductFormState();
}

class _UpdateProductFormState extends State<UpdateProductForm> {
  final TextEditingController referenceController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController buyingPriceController = TextEditingController();
  final TextEditingController sellingPriceController = TextEditingController();
  Category? selectedCategory = Category(id: 0, name: "", description: "");
  List<Category> categories = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadCategories();
    initControllers(widget.product);
  }

  Future<void> loadCategories() async {
    final categoryApi = CategoryApi(baseurl);
    final loadedCategories = await categoryApi.getCategories();

    setState(() {
      categories = loadedCategories;
      isLoading = false;
    });
    selectedCategory = loadedCategories.firstWhere(
      (category) => category.id == widget.product.category,
    );
  }

  initControllers(Product product) {
    referenceController.text = product.reference;
    descriptionController.text = product.description;
    buyingPriceController.text = product.buyingPrice.toString();
    sellingPriceController.text = product.sellingPrice.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (!isLoading) SizedBox(height: 10),
        TextFormField(
          controller: referenceController,
          decoration: InputDecoration(
            labelText: 'Reference',
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
          controller: descriptionController,
          decoration: InputDecoration(
            labelText: 'Description',
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
          controller: buyingPriceController,
          decoration: InputDecoration(
            labelText: 'Buying Price',
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
          keyboardType: TextInputType.number,
        ),
        SizedBox(height: 10),
        TextFormField(
          controller: sellingPriceController,
          decoration: InputDecoration(
            labelText: 'Selling Price',
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
          keyboardType: TextInputType.number,
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              "Category",
              style: TextStyle(color: AppColors.black),
            ),
            DropdownButton<Category>(
              value: selectedCategory,
              items: categories.map((Category category) {
                return DropdownMenuItem<Category>(
                  value: category,
                  child: Text(category.name),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedCategory = value;
                });
              },
            ),
          ],
        ),
        SizedBox(height: 10),
        CustomElevatedButton(
          onPressed: () {
            UpdateProduct();
          },
          buttonText: "Edit Product",
        ),
      ],
    );
  }

  Future<void> UpdateProduct() async {
    final api = ProductApi(baseurl);

    if (selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select a category'),
        ),
      );
      return;
    }

    final newProduct = Product(
      id: widget.product.id,
      reference: referenceController.text,
      description: descriptionController.text,
      buyingPrice: double.parse(buyingPriceController.text),
      sellingPrice: double.parse(sellingPriceController.text),
      category: selectedCategory!.id,
    );

    print(newProduct.category);

    await api.updateProduct(newProduct);

    Navigator.popAndPushNamed(context, '/products');
    referenceController.clear();
    descriptionController.clear();
    sellingPriceController.clear();
    buyingPriceController.clear();
  }

  bool _validateFields() {
    if (referenceController.text.isEmpty ||
        descriptionController.text.isEmpty ||
        buyingPriceController.text.isEmpty ||
        sellingPriceController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill in all fields'),
        ),
      );
      return false;
    }
    return true;
  }
}
