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
  final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
  final endOfWeek = startOfWeek.add(Duration(days: 6));
  List<double> weeklySpending = List.filled(7, 0.0);

  for (var expense in _expenses) {
    if (expense.date.isAfter(startOfWeek.subtract(Duration(days: 1))) && 
        expense.date.isBefore(endOfWeek.add(Duration(days: 1))) &&
        expense.date.year == now.year &&
        expense.date.month == now.month) {
      int dayIndex = expense.date.weekday - 1; // Monday is 0, Sunday is 6
      weeklySpending[dayIndex] += expense.amount;
    }
  }

  return weeklySpending;
}
}
