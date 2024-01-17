import 'package:flutter/material.dart';
import 'package:seed_pro/globales.dart';
import 'package:seed_pro/models/category_model.dart';
import 'package:seed_pro/services/category_service.dart';
import 'package:seed_pro/widgets/appBar.dart';
import 'package:seed_pro/widgets/button.dart';
import 'package:seed_pro/widgets/colors.dart';
import 'package:seed_pro/widgets/sidebar.dart';

class Categories extends StatefulWidget {
  const Categories({super.key});

  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  late List<Category> categories = [];
  late TextEditingController categoryNameController;
  late TextEditingController categoryDescriptionController;

  @override
  void initState() {
    super.initState();
    loadCategories();
    categoryNameController = TextEditingController();
    categoryDescriptionController = TextEditingController();
  }

  Future<void> loadCategories() async {
    categories = await CategoryApi(baseurl).getCategories();

    setState(() {});
  }

  Future<void> addCategory() async {
    if (categoryNameController.text.isEmpty ||
        categoryDescriptionController.text.isEmpty) {
      return;
    }

    Category newCategory = Category(
      id: categories.length,
      name: categoryNameController.text,
      description: categoryDescriptionController.text,
    );

    await CategoryApi(baseurl).createCategory(newCategory);

    categoryNameController.clear();
    categoryDescriptionController.clear();

    await loadCategories();
  }

  void _showAddCategoryDialog() {
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
                  controller: categoryNameController,
                  decoration: InputDecoration(
                    labelText: 'Category Name',
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
                  controller: categoryDescriptionController,
                  decoration: InputDecoration(
                    labelText: 'Category Description',
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
                      addCategory();
                    },
                    buttonText: "Add Category")
              ],
            ),
          ),
        );
      },
    );
  }

  void _showUpdateCategoryDialog(Category category) {
    categoryNameController.text = category.name;
    categoryDescriptionController.text = category.description;

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
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: categoryNameController,
                  decoration: InputDecoration(
                    labelText: 'Category Name',
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
                  controller: categoryDescriptionController,
                  decoration: InputDecoration(
                    labelText: 'Category Description',
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
                    Category updatedCategory = Category(
                      id: category.id,
                      name: categoryNameController.text,
                      description: categoryDescriptionController.text,
                    );

                    Navigator.of(context).pop();

                    await CategoryApi(baseurl).updateCategory(updatedCategory);

                    categoryNameController.clear();
                    categoryDescriptionController.clear();
                    await loadCategories();
                  },
                  buttonText: "Edit Category",
                ),
              ],
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
                            'CATEGORIES',
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                          CustomElevatedButton(
                              onPressed: _showAddCategoryDialog,
                              buttonText: 'Add Category')
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
                                'Description',
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
                      children: categories.map((cat) {
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
                                      cat.name,
                                      style: TextStyle(
                                          fontSize: 20, color: AppColors.grey),
                                    ),
                                  ),
                                ),
                                Container(
                                  child: Expanded(
                                    child: Text(
                                      cat.description,
                                      style: TextStyle(
                                          fontSize: 20, color: AppColors.grey),
                                    ),
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    _showUpdateCategoryDialog(cat);
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
