import 'package:flutter/material.dart';
import 'add_expense.dart';
import 'budget_overview.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Expense Tracker'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Overview of Spending'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddExpensePage()),
                );
              },
              child: Text('Add Expense'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BudgetOverviewPage()),
                );
              },
              child: Text('Budget Overview'),
            ),
          ],
        ),
      ),
    );
  }
}
