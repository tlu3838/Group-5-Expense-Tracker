import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:group_5_project/screens/add_expense.dart';

void main() {
  testWidgets('AddExpensePage has all required fields', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: AddExpensePage()));
    await tester.pumpAndSettle();
    expect(find.byType(TextField), findsAtLeastNWidgets(2)); 
    expect(find.byWidgetPredicate((widget) => widget is DropdownButtonFormField || widget is DropdownButton), findsAtLeastNWidgets(1));
    expect(find.byIcon(Icons.calendar_today), findsOneWidget); 
    expect(find.widgetWithText(ElevatedButton, 'Add Expense'), findsOneWidget);
  });
}