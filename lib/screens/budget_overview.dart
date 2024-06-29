import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/expense_provider.dart';
import '../models/expense_model.dart';
import 'package:intl/intl.dart';
import 'add_expense.dart';
import 'base_scaffold.dart';
import 'home_page.dart';

extension DateTimeExtension on DateTime {
  int get weekOfYear {
    final firstJan = DateTime(year, 1, 1);
    final dayOfYear = difference(firstJan).inDays;
    return ((dayOfYear - weekday + 10) / 7).floor();
  }
}

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
          List<int> sortedWeeks = expensesByWeek.keys.toList()
            ..sort((a, b) => b.compareTo(a));

          return ListView.builder(
            itemCount: sortedWeeks.length,
            itemBuilder: (context, weekIndex) {
              int weekNumber = sortedWeeks[weekIndex];
              List<Expense> weekExpenses = expensesByWeek[weekNumber]!;
              weekExpenses.sort((a, b) => b.date.compareTo(a.date));

              return ExpansionTile(
                title: Text('Week $weekNumber'),
                children: weekExpenses
                    .map((expense) => Dismissible(
                          key: Key(
                              expense.description + expense.date.toString()),
                          background: Container(
                            color: Color.fromARGB(255, 89, 44, 135),
                            alignment: Alignment.centerRight,
                            padding: EdgeInsets.only(right: 20.0),
                            child: Icon(Icons.delete, color: Colors.white),
                          ),
                          direction: DismissDirection.endToStart,
                          onDismissed: (direction) {
                            expenseProvider.deleteExpense(expense);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content:
                                      Text('${expense.description} deleted')),
                            );
                          },
                          child: ListTile(
                            title: Text(expense.description),
                            subtitle: Text(
                                '${expense.category} - ${DateFormat('MMM d, y').format(expense.date)}'),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('\$${expense.amount.toStringAsFixed(2)}'),
                                IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text('Delete Expense'),
                                          content: Text(
                                              'Are you sure you want to delete this expense?'),
                                          actions: <Widget>[
                                            TextButton(
                                              child: Text('Cancel'),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                            TextButton(
                                              child: Text('Delete'),
                                              onPressed: () {
                                                expenseProvider
                                                    .deleteExpense(expense);
                                                Navigator.of(context).pop();
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                      content: Text(
                                                          '${expense.description} deleted')),
                                                );
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ))
                    .toList(),
              );
            },
          );
        },
      ),
    );
  }
}
