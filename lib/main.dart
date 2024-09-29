import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'pages.dart'; // Assuming we've put all our page widgets in a separate file called pages.dart

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Expense Tracker',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Roboto',
      ),
      home: const ExpenseTrackerHome(),
    );
  }
}

class ExpenseTrackerHome extends StatefulWidget {
  const ExpenseTrackerHome({super.key});

  @override
  _ExpenseTrackerHomeState createState() => _ExpenseTrackerHomeState();
}

class _ExpenseTrackerHomeState extends State<ExpenseTrackerHome> {
  List<Transaction> transactions = [];
  double totalBalance = 0.0;
  double totalIncome = 0.0;
  double totalExpenses = 0.0;
  bool isLoading = true;
  double savingsJar = 0.0; // New state variable for savings jar

  static const smsChannel = MethodChannel("smsPlatform");

  @override
  void initState() {
    super.initState();
    fetchSmsMessages();
  }

  Future<void> fetchSmsMessages() async {
    setState(() {
      isLoading = true;
    });
    try {
      final result = await smsChannel.invokeMethod('readAllSms');
      debugPrint("SMS Result: $result"); // Check what you are getting here
      if (result is String) {
        String cleanString =
            result.replaceAll('[', '').replaceAll(']', '').trim();
        List<String> stringList = cleanString.split(',');
        processMessages(
            stringList.map((e) => e.replaceAll('""', '').trim()).toList());
      } else {
        debugPrint("Received non-string result: $result");
      }
    } on PlatformException catch (e) {
      debugPrint("Failed to get SMS: '${e.message}'.");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
    return;
  }

  void processMessages(List<String> messages) {
    for (var message in messages) {
      final lowerCaseMessage = message.toLowerCase();
      if (lowerCaseMessage.contains('debited')) {
        addTransaction(
            'Debit', extractAmount(message), 'SMS', message, DateTime.now());
      } else if (lowerCaseMessage.contains('credited')) {
        addTransaction(
            'Credit', extractAmount(message), 'SMS', message, DateTime.now());
      }
    }
    calculateTotals();
  }

  double extractAmount(String message) {
    final RegExp regex = RegExp(r'\d+(?:,\d{3})*(?:\.\d{1,2})?');
    final match = regex.firstMatch(message);
    if (match != null) {
      return double.parse(match.group(0)!.replaceAll(',', ''));
    }
    return 0.0;
  }

  void addTransaction(String type, double amount, String category,
      String message, DateTime date) {
    setState(() {
      transactions.add(Transaction(
        type: type,
        amount: amount,
        category: category,
        message: message,
        date: date,
      ));
      transactions.sort((a, b) => b.date.compareTo(a.date));
    });
    calculateTotals();
  }

  void calculateTotals() {
    totalExpenses = transactions
        .where((t) => t.type == 'Debit')
        .fold(0, (sum, item) => sum + item.amount);
    totalIncome = transactions
        .where((t) => t.type == 'Credit')
        .fold(0, (sum, item) => sum + item.amount);
    totalBalance = totalIncome -
        totalExpenses -
        savingsJar; // Update to account for savings
  }

  void addToSavings(double amount) {
    setState(() {
      savingsJar += amount;
      totalBalance -= amount;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    } else {
      return ExpenseTrackerApp(
        transactions: transactions,
        totalBalance: totalBalance,
        totalIncome: totalIncome,
        totalExpenses: totalExpenses,
        savingsJar: savingsJar,
        onAddTransaction: addTransaction,
        onAddToSavings: addToSavings,
      );
    }
  }
}

class ExpenseTrackerApp extends StatefulWidget {
  final List<Transaction> transactions;
  final double totalBalance;
  final double totalIncome;
  final double totalExpenses;
  final double savingsJar;
  final Function(String, double, String, String, DateTime) onAddTransaction;
  final Function(double) onAddToSavings;

  const ExpenseTrackerApp({
    super.key,
    required this.transactions,
    required this.totalBalance,
    required this.totalIncome,
    required this.totalExpenses,
    required this.savingsJar,
    required this.onAddTransaction,
    required this.onAddToSavings,
  });

  @override
  _ExpenseTrackerAppState createState() => _ExpenseTrackerAppState();
}

class _ExpenseTrackerAppState extends State<ExpenseTrackerApp> {
  int _selectedIndex = 0;
  double _savingsAmount = 0; // State variable to track savings amount

  void _updateSavingsAmount(double amount) {
    setState(() {
      _savingsAmount += amount; // Update savings amount
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Tracker'),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          HomePage(
            transactions: widget.transactions,
            totalBalance: widget.totalBalance,
            totalIncome: widget.totalIncome,
            totalExpenses: widget.totalExpenses,
            savingsAmount: _savingsAmount,
          ),
          TransactionsPage(transactions: widget.transactions),
          AddExpensePage(
            onAddTransaction: widget.onAddTransaction,
            onAddToSavings: _updateSavingsAmount,
            balance: widget.totalBalance,
            income: widget.totalIncome,
            totalExpenses: widget.totalExpenses,
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Transactions',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Add Expense',
          ),
        ],
      ),
    );
  }
}

class Transaction {
  final String type;
  final double amount;
  final String category;
  final String message;
  final DateTime date;

  Transaction({
    required this.type,
    required this.amount,
    required this.category,
    required this.message,
    required this.date,
  });
}
