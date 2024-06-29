import 'package:flutter/material.dart';
import '../models/expense_model.dart';

class ExpenseProvider with ChangeNotifier {
  final List<Expense> _expenses = [];

  List<Expense> get expenses => _expenses;

  void addExpense(Expense expense) {
    _expenses.add(expense);
    notifyListeners();
  }
//delete method for budget overview screen
  void deleteExpense(Expense expense) {
    _expenses.remove(expense);
    notifyListeners();
  }

  List<double> getWeeklySpending() {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday % 7));
    List<double> weeklySpending = List.filled(7, 0.0);

    for (var expense in _expenses) {
      if (expense.date.isAfter(startOfWeek.subtract(Duration(days: 1))) &&
          expense.date.isBefore(startOfWeek.add(Duration(days: 7)))) {
        int dayIndex = expense.date
            .difference(startOfWeek)
            .inDays; // changed to set sunday to 0..tuesday is 2..etc
        if (dayIndex >= 0 && dayIndex < 7) {
          weeklySpending[dayIndex] += expense.amount;
        }
      }
    }

    return weeklySpending;
  }
}
