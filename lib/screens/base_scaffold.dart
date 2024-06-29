import 'package:flutter/material.dart';

class BaseScaffold extends StatelessWidget {
  final Widget body;
  final String title;
  final int currentIndex;
  final Function(int) onTabChanged;
  final Function()? onAddExpense;

  const BaseScaffold({
    super.key,
    required this.body,
    required this.title,
    required this.currentIndex,
    required this.onTabChanged,
    this.onAddExpense,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: body,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 5.0,
        clipBehavior: Clip.antiAlias,
        child: SizedBox(
          height: kBottomNavigationBarHeight,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              IconButton(
                icon: const Icon(Icons.home),
                color: currentIndex == 0 ? Color.fromARGB(255, 37, 185, 71) : null,
                onPressed: () => onTabChanged(0),
              ),
              IconButton(
                icon: const Icon(Icons.list_alt_rounded),
                color: currentIndex == 1 ? Color.fromARGB(255, 56, 158, 221) : null,
                onPressed: () => onTabChanged(1),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: onAddExpense != null
          ? FloatingActionButton(
              onPressed: onAddExpense,
              child: Icon(Icons.add),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}