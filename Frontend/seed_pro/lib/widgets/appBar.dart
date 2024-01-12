import 'package:flutter/material.dart';
import 'package:seed_pro/models/employee_model.dart';
import 'package:seed_pro/models/shop_model.dart';
import 'package:seed_pro/services/employee_service.dart';
import 'package:seed_pro/services/shop_service.dart';
import 'package:seed_pro/widgets/colors.dart';
import 'package:seed_pro/globales.dart';

class appBar extends StatefulWidget {
  const appBar({
    super.key,
  });

  @override
  State<appBar> createState() => _appBarState();
}

class _appBarState extends State<appBar> {
  final ShopApi shopApi = ShopApi(baseurl);
  final EmployeeApi employeeApi = EmployeeApi(baseurl);
  late Employee employee = new Employee(
    id: 0,
    name: '',
    familyName: '',
    username: '',
    password: '',
    dateStart: DateTime.now(),
    email: '',
    monthlySalary: 0,
    shop: 0,
  );
  late Shop shop = new Shop(
    address: '',
    name: '',
    id: 0,
    isMaster: false,
  );

  @override
  void initState() {
    super.initState();
    fetchShopDetails();
  }

  Future<void> fetchShopDetails() async {
    Shop fetchedShop = await shopApi.getShopDetails();
    Employee fetchedEmployee = await employeeApi.getEmployeeDetails();

    print(fetchedShop.name);
    print(fetchedEmployee.name);
    setState(() {
      shop = fetchedShop;
      employee = fetchedEmployee;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            child: Row(
              children: [
                Text(
                  'Shop:',
                  style: TextStyle(color: AppColors.grey, fontSize: 30),
                ),
                SizedBox(
                  width: 20,
                ),
                Text(
                  "${shop.name}",
                  style: TextStyle(color: AppColors.green, fontSize: 30),
                ),
              ],
            ),
          ),
          Container(
            child: Row(
              children: [
                Text(
                  'Adress:',
                  style: TextStyle(color: AppColors.grey, fontSize: 30),
                ),
                SizedBox(
                  width: 20,
                ),
                Text(
                  "${shop.address}",
                  style: TextStyle(color: AppColors.green, fontSize: 30),
                ),
              ],
            ),
          ),
          Container(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'images/profile.png',
                  height: 50,
                ),
                SizedBox(
                  width: 20,
                ),
                Text(
                  "${employee.name}  ${employee.familyName}",
                  style: TextStyle(color: AppColors.black, fontSize: 30),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
