import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/expense_provider.dart';
import '../models/expense_model.dart';  // Make sure to import the Expense model
import 'base_scaffold.dart';
import 'home_page.dart';
import 'package:intl/intl.dart';

class BudgetOverviewPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      title: 'Budget Overview',
      currentIndex: 1,
      onTabChanged: (index) {
        if (index == 0) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
          );
        }
      },
      body: Consumer<ExpenseProvider>(
        builder: (context, expenseProvider, child) {
          final expenses = expenseProvider.expenses;
          if (expenses.isEmpty) {
            return Center(child: Text('No expenses added yet.'));
          }

          // Group expenses by week
          Map<int, List<Expense>> expensesByWeek = {};
          for (var expense in expenses) {
            int weekNumber = expense.date.weekOfYear;
            if (!expensesByWeek.containsKey(weekNumber)) {
              expensesByWeek[weekNumber] = [];
            }
            expensesByWeek[weekNumber]!.add(expense);
          }

          // Sort weeks
          List<int> sortedWeeks = expensesByWeek.keys.toList()..sort();

          return ListView.builder(
            itemCount: sortedWeeks.length,
            itemBuilder: (context, index) {
              int weekNumber = sortedWeeks[index];
              List<Expense> weekExpenses = expensesByWeek[weekNumber]!;
              
              return ExpansionTile(
                title: Text('Week $weekNumber'),
                children: weekExpenses.map((expense) => ListTile(
                  title: Text(expense.description),
                  subtitle: Text('${expense.category} - ${DateFormat('MMM d, y').format(expense.date)}'),
                  trailing: Text('\$${expense.amount.toStringAsFixed(2)}'),
                )).toList(),
              );
            },
          );
        },
      ),
    );
  }
}

extension DateTimeExtension on DateTime {
  int get weekOfYear {
    final firstJan = DateTime(year, 1, 1);
    final daysOffset = firstJan.weekday - 1;
    final firstMonday = firstJan.add(Duration(days: (7 - daysOffset) % 7));
    final diff = difference(firstMonday);
    return (diff.inDays / 7).floor() + 1;
  }
}