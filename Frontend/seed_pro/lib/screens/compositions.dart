import 'package:flutter/material.dart';
import 'package:seed_pro/widgets/colors.dart';
import 'package:seed_pro/widgets/sidebar.dart';

class Compositions extends StatefulWidget {
  const Compositions({super.key});

  @override
  State<Compositions> createState() => _CompositionsState();
}

class _CompositionsState extends State<Compositions> {
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
            child: Center(
              child: Text('Main Content'),
            ),
          ),
        ],
      ),
    );
  }
}
