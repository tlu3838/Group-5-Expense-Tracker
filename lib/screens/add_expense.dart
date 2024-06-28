import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/expense_model.dart';
import '../providers/expense_provider.dart';

class AddExpensePage extends StatelessWidget {
  final TextEditingController amountController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Expense'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: amountController,
              decoration: InputDecoration(
                labelText: 'Enter amount',
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 10),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(
                labelText: 'Enter description',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final String description = descriptionController.text;
                final double amount = double.tryParse(amountController.text) ?? 0.0;

                if (description.isNotEmpty && amount > 0) {
                  final newExpense = Expense(description: description, amount: amount);
                  Provider.of<ExpenseProvider>(context, listen: false).addExpense(newExpense);

                  Navigator.pop(context);
                }
              },
              child: Text('Add Expense'),
            ),
          ],
        ),
      ),
    );
  }
}
