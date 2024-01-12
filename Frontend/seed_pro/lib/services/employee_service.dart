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
}
