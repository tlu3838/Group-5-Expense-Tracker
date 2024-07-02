import 'package:flutter_test/flutter_test.dart';
import 'package:group_5_project/providers/expense_provider.dart';
import 'package:group_5_project/models/expense_model.dart';

void main() {
  test('ExpenseProvider add and retrieve expense', () {
    final provider = ExpenseProvider();
    final expense = Expense(
      description: 'Test',
      amount: 50.0,
      category: 'Food',
      date: DateTime(2023, 7, 1),
    );

    provider.addExpense(expense);

    expect(provider.expenses.length, 1);
    expect(provider.expenses.first.description, 'Test');
    expect(provider.expenses.first.amount, 50.0);
  });
}