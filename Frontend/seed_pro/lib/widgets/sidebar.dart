import 'package:flutter/material.dart';
import 'package:seed_pro/widgets/colors.dart';

class Sidebar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200.0,
      color: AppColors.lightGrey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
          SidebarItem(
            routeName: '/purchases',
            icon: Icons.add_shopping_cart,
            text: 'Purchases',
          ),
          SidebarItem(
            routeName: '/transfers',
            icon: Icons.compare_arrows,
            text: 'Transfers',
          ),
          SidebarItem(
            routeName: '/compositions',
            icon: Icons.recycling_sharp,
            text: 'Compositions',
          ),
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
          SidebarItem(
            routeName: '/addshops',
            icon: Icons.add_location,
            text: 'Add Shops',
          ),
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
            onTap: () {
              //logoutButton
            },
          )
        ],
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
        Navigator.pushReplacementNamed(context, routeName); //
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
