import 'package:flutter/material.dart';
import 'package:seed_pro/widgets/colors.dart';

class CustomInputCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String label2;
  final String value2;

  const CustomInputCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.label2,
    required this.value2,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 550,
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.grey, width: 1),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Icon(
              icon,
              size: 50,
              color: AppColors.grey,
            ),
            SizedBox(
              width: 20,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  "$label: $value",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: AppColors.grey,
                  ),
                ),
                Text(
                  "$label2: $value2",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: AppColors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CustomInputCard2 extends StatelessWidget {
  final IconData icon;

  final String label2;
  final String value2;

  const CustomInputCard2({
    required this.icon,
    required this.label2,
    required this.value2,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 550,
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.grey, width: 1),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Icon(
              icon,
              size: 50,
              color: AppColors.grey,
            ),
            SizedBox(
              width: 20,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  "$label2: $value2",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: AppColors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
