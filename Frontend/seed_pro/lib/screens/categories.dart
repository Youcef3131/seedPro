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

  @override
  void initState() {
    super.initState();
    loadCategories();
  }

  Future<void> loadCategories() async {
    categories = await CategoryApi(baseurl).getCategories();

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
                          'CATEGORIES',
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        CustomElevatedButton(
                            onPressed: () {}, buttonText: 'Add Category')
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
                            'Name',
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
                      SizedBox(
                        width: 20,
                      ),
                    ],
                  ),
                  SingleChildScrollView(
                    child: Column(
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
                                    print(
                                        'Edit Category pressed for ${cat.id}');
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
