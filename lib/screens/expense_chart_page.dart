import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/expense_provider.dart';
import '../models/expense_model.dart';
import 'add_expense.dart';
import 'base_scaffold.dart';
import 'budget_overview.dart';
import 'home_page.dart';

class ExpenseChartPage extends StatelessWidget {
  final List<Color> categoryColors = [
    Colors.blue,
    Colors.green,
    Colors.red,
    Colors.yellow,
    Colors.purple,
  ];

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      title: 'Spending Breakdown',
      currentIndex: 2,
      onTabChanged: (index) {
        if (index == 0) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
          );
        } else if (index == 1) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => BudgetOverviewPage()),
          );
        }
      },
      onAddExpense: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AddExpensePage()),
        ).then((result) {
          if (result == true) {
            Provider.of<ExpenseProvider>(context, listen: false).notifyListeners();
          }
        });
      },
      body: Consumer<ExpenseProvider>(
        
        builder: (context, expenseProvider, child) {
          Map<String, double> categoryTotals = {
            'Dining': 0,
            'Groceries': 0,
            'Shopping': 0,
            'Fees': 0,
            'Entertainment': 0,
          };

          for (var expense in expenseProvider.expenses) {
            if (expense.category != 'Income' && categoryTotals.containsKey(expense.category)) {
              categoryTotals[expense.category] = (categoryTotals[expense.category] ?? 0) + expense.amount;
            }
          }

          List<PieChartSectionData> sections = [];
          double total = categoryTotals.values.reduce((a, b) => a + b);

          int i = 0;
          categoryTotals.forEach((category, amount) {
            if (amount > 0) {
              sections.add(
                PieChartSectionData(
                  color: categoryColors[i % categoryColors.length],
                  value: amount,
                  title: '${(amount / total * 100).toStringAsFixed(1)}%',
                  radius: 100,
                  titleStyle: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              );
            }
            i++;
          });

          return Container(
            color: Color.fromARGB(239, 160, 148, 172),
            child: Column(
              children: [
                Expanded(
                  child: PieChart(
                    PieChartData(
                      sections: sections,
                      sectionsSpace: 0,
                      centerSpaceRadius: 40,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: categoryTotals.entries.map((entry) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 20,
                                height: 20,
                                color: categoryColors[categoryTotals.keys.toList().indexOf(entry.key) % categoryColors.length],
                              ),
                              SizedBox(width: 8),
                              Text(entry.key),
                            ],
                          ),
                          Text('\$${entry.value.toStringAsFixed(2)}'),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}