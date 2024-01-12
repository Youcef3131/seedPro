import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:seed_pro/models/category_model.dart';
import 'package:seed_pro/services/authentication_service.dart';

class CategoryApi {
  final String baseUrl;

  CategoryApi(this.baseUrl);

  Future<List<Category>> getCategories() async {
    final response = await http.get(Uri.parse('$baseUrl/api/categories/'),
        headers: await getHeaders());

    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body);
      return List<Category>.from(
        list.map((category) => Category.fromJson(category)),
      );
    } else {
      throw Exception('Failed to load categories');
    }
  }

  Future<Category> getCategoryById(int categoryId) async {
    final response = await http.get(
        Uri.parse('$baseUrl/api/categories/$categoryId/'),
        headers: await getHeaders());

    if (response.statusCode == 200) {
      return Category.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load category details');
    }
  }

  Future<Category> createCategory(Category newCategory) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/categories/'),
      headers: await getHeaders(),
      body: jsonEncode(newCategory.toJson()),
    );

    if (response.statusCode == 201) {
      return Category.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create category');
    }
  }

  Future<Category> updateCategory(Category updatedCategory) async {
    final response = await http.put(
      Uri.parse('$baseUrl/api/categories/${updatedCategory.id}/'),
      headers: await getHeaders(),
      body: jsonEncode(updatedCategory.toJson()),
    );

    if (response.statusCode == 200) {
      return Category.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update category');
    }
  }
}
