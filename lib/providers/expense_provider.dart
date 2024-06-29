import 'package:flutter/material.dart';
import '../models/expense_model.dart';

class ExpenseProvider with ChangeNotifier {
  final List<Expense> _expenses = [];

  List<Expense> get expenses => _expenses;

  void addExpense(Expense expense) {
    _expenses.add(expense);
    notifyListeners();
  }
  List<double> getWeeklySpending() {
  final now = DateTime.now();
  List<double> weeklySpending = List.filled(7, 0.0);

  for (var expense in _expenses) {
    // Find the start of the week (Sunday) for this expense
    final startOfWeek = expense.date.subtract(Duration(days: expense.date.weekday % 7));
    final endOfWeek = startOfWeek.add(Duration(days: 6));

    // Check if the expense is within the current week
    if (now.isAfter(startOfWeek) && now.isBefore(endOfWeek.add(Duration(days: 1)))) {
      int dayIndex = expense.date.weekday % 7; // 0 for Sunday, 1 for Monday, etc.
      weeklySpending[dayIndex] += expense.amount;
    }
  }

  return weeklySpending;
}
}
