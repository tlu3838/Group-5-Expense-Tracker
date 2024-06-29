import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'add_expense.dart';
import 'budget_overview.dart';
import '../providers/expense_provider.dart';
import 'weekly_spending_chart.dart';
import 'base_scaffold.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      title: 'Weekly Expense',
      currentIndex: 0,
      onTabChanged: (index) {
        if (index == 1) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChangeNotifierProvider.value(
                value: Provider.of<ExpenseProvider>(context, listen: false),
                child: BudgetOverviewPage(),
              ),
            ),
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
          List<double> weeklySpending = expenseProvider.getWeeklySpending();
          double totalSpent = weeklySpending.reduce((a, b) => a + b);

          return SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(18),
                  color: Color.fromARGB(255, 55, 54, 93),
                  child: WeeklySpendingChart(dailySpending: weeklySpending),
                ),
                SizedBox(height: 30),
                Text('Total Spent this week:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 87, 178, 126),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '\$${totalSpent.toStringAsFixed(2)}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }
}