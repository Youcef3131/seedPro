import 'package:flutter/material.dart';
import 'package:seed_pro/widgets/appBar.dart';
import 'package:seed_pro/widgets/colors.dart';
import 'package:seed_pro/widgets/sidebar.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
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
                children: [appBar()],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
