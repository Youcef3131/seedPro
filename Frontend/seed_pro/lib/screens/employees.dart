import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:seed_pro/globales.dart';
import 'package:seed_pro/models/employee_model.dart';
import 'package:seed_pro/services/authentication_service.dart';
import 'package:seed_pro/services/employee_service.dart';
import 'package:seed_pro/widgets/appBar.dart';
import 'package:seed_pro/widgets/button.dart';
import 'package:seed_pro/widgets/colors.dart';
import 'package:seed_pro/widgets/sidebar.dart';

class EmployeeScreen extends StatefulWidget {
  const EmployeeScreen({super.key});

  @override
  State<EmployeeScreen> createState() => _EmployeeScreenState();
}

class _EmployeeScreenState extends State<EmployeeScreen> {
  late List<Employee> employes = [];
  @override
  void initState() {
    super.initState();
    loademplyees();
  }

  Future<void> loademplyees() async {
    employes = (await EmployeeApi(baseurl).getEmployeesByShop());
    setState(() {});
  }

  void _showEditEmployeeDialog(Employee employee) async {
    final TextEditingController nameController =
        TextEditingController(text: employee.name);
    final TextEditingController familyNameController =
        TextEditingController(text: employee.familyName);
    final TextEditingController emailController =
        TextEditingController(text: employee.email);
    final TextEditingController usernameController =
        TextEditingController(text: employee.username);

    final TextEditingController monthlySalaryController =
        TextEditingController(text: employee.monthlySalary.toString());

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
              width: 300,
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: 'Name',
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
                  TextField(
                    controller: familyNameController,
                    decoration: InputDecoration(
                      labelText: 'Family Name',
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
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
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
                  TextField(
                    controller: usernameController,
                    decoration: InputDecoration(
                      labelText: 'Username',
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
                  TextField(
                    controller: monthlySalaryController,
                    decoration: InputDecoration(
                      labelText: 'Monthly Salary',
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
                      _handleUpdateEmployee(
                        employee.id,
                        nameController.text,
                        familyNameController.text,
                        emailController.text,
                        usernameController.text,
                        double.parse(monthlySalaryController.text),
                      );
                    },
                    buttonText: "Update Employee",
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _handleUpdateEmployee(
    int employeeId,
    String name,
    String familyName,
    String email,
    String username,
    double monthlySalary,
  ) async {
    try {
      Employee existingEmployee =
          (await EmployeeApi(baseurl).getEmployeeById(employeeId));

      Employee updatedEmployee = Employee(
        id: employeeId,
        name: name,
        familyName: familyName,
        dateStart: existingEmployee.dateStart,
        email: email,
        username: username,
        password: existingEmployee.password, // Retain existing password
        monthlySalary: monthlySalary,
        shop: existingEmployee.shop,
      );

      await EmployeeApi(baseurl).updateEmployee(updatedEmployee);
      loademplyees();

      print(
        'Employee updated successfully: ${updatedEmployee.name} ${updatedEmployee.familyName}',
      );
    } catch (e) {
      print('Error updating employee: $e');
    }
  }

  void _showAddEmployeeDialog() async {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController familyNameController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController usernameController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final TextEditingController monthlySalaryController =
        TextEditingController();

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
              width: 300,
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: 'Name',
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
                  TextField(
                    controller: familyNameController,
                    decoration: InputDecoration(
                      labelText: 'Family Name',
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
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
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
                  TextField(
                    controller: usernameController,
                    decoration: InputDecoration(
                      labelText: 'Username',
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
                  TextField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      labelText: 'Password',
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
                  TextField(
                    controller: monthlySalaryController,
                    decoration: InputDecoration(
                      labelText: 'Monthly Salary',
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
                      _handleAddEmployee(
                        nameController.text,
                        familyNameController.text,
                        emailController.text,
                        usernameController.text,
                        passwordController.text,
                        double.parse(monthlySalaryController.text),
                      );
                    },
                    buttonText: "Add Employee",
                  ),
                ],
              ),
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
                        'Employees',
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      CustomElevatedButton(
                          onPressed: _showAddEmployeeDialog,
                          buttonText: 'Add Employee')
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
                            'Name',
                            style:
                                TextStyle(fontSize: 20, color: AppColors.grey),
                          ),
                        ),
                      ),
                      Container(
                        child: Expanded(
                          child: Text(
                            'Family Name',
                            style:
                                TextStyle(fontSize: 20, color: AppColors.grey),
                          ),
                        ),
                      ),
                      Container(
                        child: Expanded(
                          child: Text(
                            'Date start',
                            style:
                                TextStyle(fontSize: 20, color: AppColors.grey),
                          ),
                        ),
                      ),
                      Container(
                        child: Expanded(
                          child: Text(
                            'Email',
                            style:
                                TextStyle(fontSize: 20, color: AppColors.grey),
                          ),
                        ),
                      ),
                      Container(
                        child: Expanded(
                          child: Text(
                            'Monthly salary',
                            style:
                                TextStyle(fontSize: 20, color: AppColors.grey),
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.edit),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: employes.map((em) {
                    return GestureDetector(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          color: AppColors.lightGrey,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Container(
                                child: Expanded(
                                  child: Text(
                                    em.name,
                                    style: TextStyle(
                                        fontSize: 20, color: AppColors.grey),
                                  ),
                                ),
                              ),
                              Container(
                                child: Expanded(
                                  child: Text(
                                    em.familyName,
                                    style: TextStyle(
                                        fontSize: 20, color: AppColors.grey),
                                  ),
                                ),
                              ),
                              Container(
                                child: Expanded(
                                  child: Text(
                                    DateFormat('yyyy-MM-dd HH:mm')
                                        .format(em.dateStart),
                                    style: TextStyle(
                                        fontSize: 20, color: AppColors.grey),
                                  ),
                                ),
                              ),
                              Container(
                                child: Expanded(
                                  child: Text(
                                    em.email,
                                    style: TextStyle(
                                        fontSize: 20, color: AppColors.grey),
                                  ),
                                ),
                              ),
                              Container(
                                child: Expanded(
                                  child: Text(
                                    em.monthlySalary.toString(),
                                    style: TextStyle(
                                        fontSize: 20, color: AppColors.grey),
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  _showEditEmployeeDialog(em);
                                },
                                icon: Icon(Icons.edit),
                              ),
                            ],
                          ),
                        ),
                      ),
                      onTap: () {},
                    );
                  }).toList(),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  void _handleAddEmployee(
    String name,
    String familyName,
    String email,
    String username,
    String password,
    double monthlySalary,
  ) async {
    try {
      String? shopid = await getShopIdFromPrefs();

      Employee newEmployee = Employee(
        id: 0,
        name: name,
        familyName: familyName,
        dateStart: DateTime.now(),
        email: email,
        username: username,
        password: password,
        monthlySalary: monthlySalary,
        shop: int.parse(shopid!),
      );

      Employee createdEmployee =
          await EmployeeApi(baseurl).signUpEmployee(newEmployee);
      loademplyees();

      print(
          'Employee added successfully: ${createdEmployee.name} ${createdEmployee.familyName}');
    } catch (e) {
      print('Error adding employee: $e');
    }
  }
}
