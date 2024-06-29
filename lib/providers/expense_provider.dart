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
  final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
  List<double> weeklySpending = List.filled(7, 0.0);

  for (var expense in _expenses) {
    if (expense.date.isAfter(startOfWeek.subtract(Duration(days: 1))) && 
        expense.date.isBefore(now.add(Duration(days: 1)))) {
      int dayIndex = expense.date.difference(startOfWeek).inDays;
      weeklySpending[dayIndex] += expense.amount;
    }
  }

  return weeklySpending;
}
}
