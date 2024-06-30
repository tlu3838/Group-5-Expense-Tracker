import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/expense_provider.dart';
import '../models/expense_model.dart';
import 'package:intl/intl.dart';
import 'add_expense.dart';
import 'base_scaffold.dart';
import 'expense_chart_page.dart';
import 'home_page.dart';

extension DateTimeExtension on DateTime {
  int get weekOfYear {
    final firstJan = DateTime(year, 1, 1);
    final dayOfYear = difference(firstJan).inDays;
    return ((dayOfYear - weekday + 10) / 7).floor();
  }
}

class BudgetOverviewPage extends StatelessWidget {
  const BudgetOverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      title: 'Budget Overview',
      currentIndex: 1,
      onTabChanged: (index) {
  if (index == 0) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomePage()),
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
        // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
        Provider.of<ExpenseProvider>(context, listen: false).notifyListeners();
      }
    });
  },
      body: Consumer<ExpenseProvider>(
        builder: (context, expenseProvider, child) {
          final expenses = expenseProvider.expenses;
          if (expenses.isEmpty) {
            return const Center(child: Text('No expenses added yet.'));
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
                            color: const Color.fromARGB(255, 89, 44, 135),
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 20.0),
                            child: const Icon(Icons.delete, color: Color.fromARGB(255, 145, 142, 142)),
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
                                  icon: const Icon(Icons.delete, color: Color.fromARGB(255, 175, 172, 172)),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text('Delete Expense'),
                                          content: const Text(
                                              'Are you sure you want to delete this expense?'),
                                          actions: <Widget>[
                                            TextButton(
                                              child: const Text('Cancel'),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                            TextButton(
                                              child: const Text('Delete'),
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
