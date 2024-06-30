import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/expense_model.dart';
import '../providers/expense_provider.dart';

class AddExpensePage extends StatefulWidget {
  const AddExpensePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AddExpensePageState createState() => _AddExpensePageState();
}

class _AddExpensePageState extends State<AddExpensePage> {
  final TextEditingController amountController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  String selectedCategory = 'Dining';
  DateTime selectedDate = DateTime.now();

  final List<String> categories = [
    'Dining',
    'Groceries',
    'Shopping',
    'Fees',
    'Entertainment',
    'Income',
  ];

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      selectableDayPredicate: (DateTime val)=>val.weekday <=8,
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Expense'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: amountController,
              decoration: const InputDecoration(
                labelText: 'Enter amount',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                labelText: 'Enter description',
              ),
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: selectedCategory,
              decoration: const InputDecoration(
                labelText: 'Category',
                border: OutlineInputBorder(),
              ),
              items: categories.map((String category) {
                return DropdownMenuItem<String>(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    selectedCategory = newValue;
                  });
                }
              },
            ),
            const SizedBox(height: 20),
            ListTile(
              title: Text("Date: ${selectedDate.toLocal()}".split(' ')[0]),
              trailing: const Icon(Icons.calendar_today),
              onTap: () => _selectDate(context),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final String description = descriptionController.text;
                final double amount = double.tryParse(amountController.text) ?? 0.0;

                if (description.isNotEmpty && amount > 0) {
                  final newExpense = Expense(
                    description: description,
                    amount: amount,
                    category: selectedCategory,
                    date: selectedDate,
                  );
                  Provider.of<ExpenseProvider>(context, listen: false).addExpense(newExpense);

                  Navigator.pop(context);
                }
              },
              child: const Text('Add Expense'),
            ),
          ],
        ),
      ),
    );
  }
}