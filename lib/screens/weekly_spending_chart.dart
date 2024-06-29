import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
// import '../providers/expense_provider.dart';

class WeeklySpendingChart extends StatelessWidget {
  final List<double> dailySpending;

  const WeeklySpendingChart({super.key, required this.dailySpending});

  @override
  Widget build(BuildContext context) {
    double maxSpending = dailySpending.reduce((curr, next) => curr > next ? curr : next);
    
    return AspectRatio(
      aspectRatio: 2,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: maxSpending,
          barTouchData: BarTouchData(enabled: false),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  const titles = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
                  return Text(titles[value.toInt()], style: const TextStyle(color: Colors.white, fontSize: 12));
                },
              ),
            ),
            leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
          barGroups: dailySpending.asMap().entries.map((entry) {
            return BarChartGroupData(
              x: entry.key,
              barRods: [
                BarChartRodData(
                  toY: entry.value,
                  color: Colors.white,
                  width: 16,
                  borderRadius: BorderRadius.circular(4),
                  backDrawRodData: BackgroundBarChartRodData(
                    show: true,
                    toY: maxSpending,
                    color: Colors.white.withOpacity(0.1),
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}