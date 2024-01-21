import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:seed_pro/models/employee_model.dart';

import 'package:seed_pro/services/authentication_service.dart';

class EmployeeApi {
  final String baseUrl;

  EmployeeApi(this.baseUrl);

  Future<Employee> getEmployeeDetails() async {
    var username = await getUsernameFromPrefs();
    final response = await http.get(
        Uri.parse('$baseUrl/api/get-employee/$username/'),
        headers: await getHeaders());

    if (response.statusCode == 200) {
      return Employee.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load employee details');
    }
  }

  Future<Employee> getEmployeeById(int employeeId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/employees/$employeeId/'),
      headers: await getHeaders(),
    );

    if (response.statusCode == 200) {
      return Employee.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to get employee by ID');
    }
  }

  Future<List<Employee>> getEmployeesByShop() async {
    String? shopId = await getShopIdFromPrefs();
    final response = await http.get(
      Uri.parse('$baseUrl/api/employees/shop/$shopId/'),
      headers: await getHeaders(),
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Employee.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load employees by shop');
    }
  }

  Future<Employee> updateEmployee(Employee employee) async {
    final response = await http.put(
      Uri.parse('$baseUrl/api/employees/${employee.id}/'),
      headers: await getHeaders(),
      body: json.encode(employee.toJson()),
    );

    if (response.statusCode == 200) {
      return Employee.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update employee');
    }
  }

  Future<Employee> signUpEmployee(Employee employee) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/signup/'),
      headers: await getHeaders(),
      body: json.encode(employee.toJson()),
    );

    if (response.statusCode == 201) {
      return Employee.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to sign up employee');
    }
  }
}
