import 'package:flutter_test/flutter_test.dart';
import 'package:group_5_project/models/expense_model.dart';

//setup
//test

void main() {
  test('Expense model creation', () {
    final expense = Expense(
      description: 'Test',
      amount: 50.0,
      category: 'Food',
      date: DateTime(2023, 7, 1),
    );
    expect(expense.description, 'Test');
    expect(expense.amount, 50.0);
    expect(expense.category, 'Food');
    expect(expense.date, DateTime(2023, 7, 1));
  });
}