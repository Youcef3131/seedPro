import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:seed_pro/widgets/colors.dart';

class SalesChart extends StatelessWidget {
  final List<int> salesData;

  const SalesChart(this.salesData);

  @override
  Widget build(BuildContext context) {
    return _buildChartContainer(context);
  }

  Widget _buildChartContainer(BuildContext context) {
    return Container(
      height: 300.0,
      width: MediaQuery.of(context).size.width * 0.3,
      child: BarChart(
        BarChartData(
          barGroups: _generateBarGroups(),
          titlesData: FlTitlesData(
            bottomTitles: _buildBottomTitles(),
            leftTitles: SideTitles(showTitles: false),
            rightTitles: SideTitles(showTitles: false),
            topTitles: SideTitles(showTitles: false),
          ),
          borderData: FlBorderData(
            show: true,
            border: Border.all(color: Colors.transparent),
          ),
          gridData: FlGridData(
            show: true,
            drawHorizontalLine: true, // Draw horizontal lines
            drawVerticalLine: false, // Remove vertical grid lines
          ),
        ),
      ),
    );
  }

  List<BarChartGroupData> _generateBarGroups() {
    final defaultSalesValue =
        0; // You can set this to any default value you prefer

    return List.generate(
      salesData.length,
      (index) {
        final currentSales = salesData[index];

        if (currentSales.isFinite) {
          return BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                y: currentSales.toDouble(),
                colors: [AppColors.green],
                width: 10, // Adjust the width as needed
              ),
            ],
          );
        } else {
          // Handle the case where the sales data is non-finite
          // Replace non-finite values with a default value
          return BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                y: defaultSalesValue.toDouble(),
                colors: [AppColors.green],
                width: 10, // Adjust the width as needed
              ),
            ],
          );
        }
      },
    );
  }

  SideTitles _buildBottomTitles() {
    return SideTitles(
      showTitles: true,
      getTitles: (value) {
        if (value.isFinite) {
          switch (value.truncate()) {
            case 0:
              return 'Today';
            case 1:
              return 'Yesterday';
            case 2:
              return '2 Days Ago';
            case 3:
              return '3 Days Ago';
            case 4:
              return '4 Days Ago';
            default:
              return '';
          }
        } else {
          return ''; // Handle the case where value is Infinity or NaN
        }
      },
    );
  }
}
