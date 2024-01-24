import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:seed_pro/globales.dart';
import 'package:seed_pro/models/logout_model.dart';
import 'package:seed_pro/models/shop_model.dart';
import 'package:seed_pro/services/authentication_service.dart';
import 'package:seed_pro/services/logout_service.dart';
import 'package:seed_pro/services/shop_service.dart';
import 'package:seed_pro/widgets/colors.dart';

class Sidebar extends StatefulWidget {
  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  final ShopApi shopApi = ShopApi(baseurl);
  bool master = false;
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

    print(fetchedShop.name);

    setState(() {
      shop = fetchedShop;
      master = shop.isMaster;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: 200.0,
      color: AppColors.lightGrey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 15,
            ),
            Image.asset('images/logo.png'),
            SizedBox(height: 20),
            Text(
              '   OVERVIEW',
              style: TextStyle(color: AppColors.grey, fontSize: 12.0),
            ),
            SizedBox(height: 10),
            SidebarItem(
              routeName: '/dashboard',
              icon: Icons.dashboard,
              text: 'Dashboard',
            ),
            SidebarItem(
              routeName: '/categories',
              icon: Icons.category,
              text: 'Categories',
            ),
            SidebarItem(
              routeName: '/products',
              icon: Icons.shopping_cart,
              text: 'Products',
            ),
            SidebarItem(
              routeName: '/clients',
              icon: Icons.person,
              text: 'Clients',
            ),
            SidebarItem(
              routeName: '/sales',
              icon: Icons.monetization_on,
              text: 'Sales',
            ),
            SidebarItem(
              routeName: '/suppliers',
              icon: Icons.local_shipping,
              text: 'Suppliers',
            ),
            master == true
                ? SidebarItem(
                    routeName: '/purchases',
                    icon: Icons.add_shopping_cart,
                    text: 'Purchases',
                  )
                : Container(),
            master == true
                ? SidebarItem(
                    routeName: '/transfers',
                    icon: Icons.compare_arrows,
                    text: 'Transfers',
                  )
                : Container(),
            master == false
                ? SidebarItem(
                    routeName: '/compositions',
                    icon: Icons.recycling_sharp,
                    text: 'Compositions',
                  )
                : Container(),
            SidebarItem(
              routeName: '/coasts',
              icon: Icons.money,
              text: 'Coasts',
            ),
            SidebarItem(
              routeName: '/employees',
              icon: Icons.people,
              text: 'Employees',
            ),
            master == true
                ? SidebarItem(
                    routeName: '/addshops',
                    icon: Icons.add_location,
                    text: 'Add Shops',
                  )
                : Container(),
            SizedBox(height: 40),
            Text(
              '   OTHER',
              style: TextStyle(color: AppColors.grey, fontSize: 12.0),
            ),
            SizedBox(height: 10),
            GestureDetector(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    Icon(
                      Icons.logout,
                      color: Colors.red,
                    ),
                    SizedBox(width: 10.0),
                    Text(
                      'Logout',
                      style: TextStyle(color: AppColors.grey),
                    )
                  ],
                ),
              ),
              onTap: () async {
                performLogout(context, baseurl);
              },
            )
          ],
        ),
      ),
    );
  }
}

class SidebarItem extends StatelessWidget {
  final String routeName;
  final IconData icon;
  final String text;

  SidebarItem({
    required this.routeName,
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    bool isActive = ModalRoute.of(context)?.settings.name == routeName;

    return GestureDetector(
      onTap: () {
        Navigator.pushReplacementNamed(context, routeName);
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: isActive ? AppColors.green : Colors.transparent,
        ),
        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
        child: Row(
          children: [
            Icon(icon, color: isActive ? AppColors.white : AppColors.grey),
            SizedBox(width: 10.0),
            Text(
              text,
              style: TextStyle(
                color: isActive ? AppColors.white : AppColors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> performLogout(BuildContext context, String baseurl) async {
  try {
    var username = await getUsernameFromPrefs();
    var password = await getPasswordFromPrefs();

    var logoutRequest = LogoutRequest(username: username!, password: password!);

    var logoutService = LogoutService(logoutRequest, baseurl);
    await logoutService.logout();

    removeAllInfoFromPrefs();

    Navigator.pushReplacementNamed(context, '/login');
  } catch (e) {
    print('Error during logout: $e');
  }
}
