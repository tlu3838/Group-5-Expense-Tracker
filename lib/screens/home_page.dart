import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'add_expense.dart';
import 'budget_overview.dart';
import '../providers/expense_provider.dart';
import 'weekly_spending_chart.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weekly Expense Overview'),
      ),
      body: Consumer<ExpenseProvider>(
        builder: (context, expenseProvider, child) {
          List<double> weeklySpending = expenseProvider.getWeeklySpending();
          
          return SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(16),
                  color: Color.fromARGB(255, 79, 54, 93),
                  child: WeeklySpendingChart(dailySpending: weeklySpending),
                ),
                SizedBox(height: 20),
                Text('Total Spent this week:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 20),               
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddExpensePage()),
          ).then((result) {
            if (result == true) {
              // An expense was added, so notify listeners to rebuild the UI
              Provider.of<ExpenseProvider>(context, listen: false).notifyListeners();
            }
          });
        },
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 5.0,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.home),
              onPressed: () {
                setState(() {
                  _currentIndex = 0;
                });
              },
            ),
            IconButton(
              icon: Icon(Icons.list_alt_rounded),
              onPressed: () {
                setState(() {
                  _currentIndex = 1;
                });
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChangeNotifierProvider.value(
                      value: Provider.of<ExpenseProvider>(context, listen: false),
                      child: BudgetOverviewPage(),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}