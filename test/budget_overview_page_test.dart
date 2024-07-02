import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:group_5_project/screens/base_scaffold.dart';
import 'package:provider/provider.dart';
import 'package:group_5_project/providers/expense_provider.dart';
import 'package:group_5_project/models/expense_model.dart';
import 'package:group_5_project/screens/budget_overview.dart';
void main() {
  testWidgets('BudgetOverviewPage basic structure test', (WidgetTester tester) async {
    final provider = ExpenseProvider();
    provider.addExpense(Expense(
      description: 'Test Expense',
      amount: 50.0,
      category: 'Food',
      date: DateTime.now(),
    ));
    await tester.pumpWidget(
      ChangeNotifierProvider<ExpenseProvider>.value(
        value: provider,
        child: const MaterialApp(home: BudgetOverviewPage()),
      ),
    );         
    expect(find.byType(ExpansionTile), findsOneWidget);    
    expect(find.textContaining('Week'), findsOneWidget);    
    expect(find.byType(BaseScaffold), findsOneWidget);    
    expect(find.byIcon(Icons.add), findsOneWidget);
  });
}