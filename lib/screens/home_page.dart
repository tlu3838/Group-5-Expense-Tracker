import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'add_expense.dart';
import 'budget_overview.dart';
import '../providers/expense_provider.dart';
import 'expense_chart_page.dart';
import 'weekly_spending_chart.dart';
import 'base_scaffold.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      title: 'Weekly Expense',
      currentIndex: 0,
      onTabChanged: (index) {
        if (index == 1) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const BudgetOverviewPage()),
          );
        } else if (index == 2) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => ExpenseChartPage()),
          );
        }
      },
      onAddExpense: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AddExpensePage()),
        ).then((result) {
          if (result == true) {
            Provider.of<ExpenseProvider>(context, listen: false)
                // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
                .notifyListeners();
          }
        });
      },
      body: Consumer<ExpenseProvider>(
        builder: (context, expenseProvider, child) {
          List<double> weeklySpending = expenseProvider.getWeeklySpending();
          double totalSpent = weeklySpending.reduce((a, b) => a + b);

          return SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(18),
                  color: const Color.fromARGB(255, 55, 54, 93),
                  child: WeeklySpendingChart(dailySpending: weeklySpending),
                ),
                const SizedBox(height: 30),
                const Text('Total Spent this week:',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 87, 178, 126),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '\$${totalSpent.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }
}
