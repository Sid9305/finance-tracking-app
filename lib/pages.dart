// Home Page
import 'package:finance_app/main.dart';
import 'package:finance_app/profile_view.dart';
import 'package:finance_app/screens/payment_screen.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  final List<Transaction> transactions;
  final double totalBalance;
  final double totalIncome;
  final double totalExpenses;
  final double savingsAmount; // New field for savings

  const HomePage({
    super.key,
    required this.transactions,
    required this.totalBalance,
    required this.totalIncome,
    required this.totalExpenses,
    required this.savingsAmount, // New field for savings
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isSavingsVisible = false;
  // Track visibility of savings jar
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildUserHeader(context),
            const SizedBox(height: 16),
            _buildTotalBalanceCard(),
            const SizedBox(height: 24),
            _buildSavingsCard(), // Add savings card here
            const SizedBox(height: 24),
            _buildRecentTransactions(context),
          ],
        ),
      ),
    );
  }

  Widget _buildSavingsCard() {
    var media = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        setState(() {
          _isSavingsVisible = !_isSavingsVisible; // Toggle visibility
        });
      },
      child: Container(
        width: media.width,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color.fromARGB(213, 17, 51, 137),
              Color.fromARGB(186, 66, 164, 245)
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Savings Jar',
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 8),
            if (_isSavingsVisible)
              Text(
                '₹${widget.savingsAmount.toStringAsFixed(2)}',
                style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              )
            else
              const Text('Hidden',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
            const SizedBox(height: 8),
            Text(
              _isSavingsVisible ? 'Tap to hide' : 'Tap to show',
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.grey[300],
              child: const Icon(Icons.person, color: Colors.white),
            ),
            const SizedBox(width: 8),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Welcome!',
                    style: TextStyle(fontSize: 14, color: Colors.grey)),
                Text('John Doe',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
        IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const ProfileView()));
            }),
      ],
    );
  }

  // Widget _buildTotalBalanceCard() {
  //   return Container(
  //     padding: const EdgeInsets.all(16),
  //     decoration: BoxDecoration(
  //       gradient: LinearGradient(
  //         colors: [Colors.purple.shade400, Colors.blue.shade400],
  //         begin: Alignment.topLeft,
  //         end: Alignment.bottomRight,
  //       ),
  //       borderRadius: BorderRadius.circular(16),
  //     ),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         const Text('Total Balance', style: TextStyle(color: Colors.white70)),
  //         Text(
  //           '₹${widget.totalBalance.toStringAsFixed(2)}',
  //           style: const TextStyle(
  //               fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
  //         ),
  //         const SizedBox(height: 16),
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: [
  //             _buildBalanceItem('Income', widget.totalIncome,
  //                 Icons.arrow_upward, Colors.green),
  //             _buildBalanceItem('Expenses', widget.totalExpenses,
  //                 Icons.arrow_downward, Colors.red),
  //           ],
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildBalanceItem(
      String label, double amount, IconData icon, Color color) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 16),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(color: Colors.white70)),
            Text('₹${amount.toStringAsFixed(2)}',
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)),
          ],
        ),
      ],
    );
  }

  Widget _buildTotalBalanceCard() {
    double totalWithSavings =
        widget.totalBalance + widget.savingsAmount; // Include savings in total
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.purple.shade400, Colors.blue.shade400],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Total Balance', style: TextStyle(color: Colors.white70)),
          Text(
            '₹${totalWithSavings.toStringAsFixed(2)}', // Update display
            style: const TextStyle(
                fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildBalanceItem('Income', widget.totalIncome,
                  Icons.arrow_upward, Colors.green),
              _buildBalanceItem('Expenses', widget.totalExpenses,
                  Icons.arrow_downward, Colors.red),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecentTransactions(BuildContext context) {
    final recentTransactions = widget.transactions.take(10).toList();

    // Optionally, add a savings transaction to the recent transactions
    if (widget.savingsAmount > 0) {
      recentTransactions.add(Transaction(
        category: 'Savings',
        type: 'Debit',
        amount: widget.savingsAmount,
        message: 'Savings added',
        date: DateTime.now(),
      ));
    }

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Recent Transactions',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              TextButton(
                onPressed: () {
                  // Navigate to the AllTransactionsPage
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AllTransactionsPage(
                          transactions: widget.transactions),
                    ),
                  );
                },
                child: const Text('View All'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              itemCount: recentTransactions.length,
              itemBuilder: (context, index) {
                final transaction = recentTransactions[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: _getCategoryColor(transaction.category),
                    child: Icon(_getCategoryIcon(transaction.category),
                        color: Colors.white),
                  ),
                  title: Text(transaction.category),
                  subtitle: Text(
                    '${DateFormat('dd MMM yyyy').format(transaction.date)}\n${transaction.message}',
                  ),
                  trailing: Text(
                    '${transaction.type == 'Debit' ? '-' : '+'} ₹${transaction.amount.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: transaction.type == 'Debit'
                          ? Colors.red
                          : Colors.green,
                    ),
                  ),
                  isThreeLine: true,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// New page to display all transactions
class AllTransactionsPage extends StatelessWidget {
  final List<Transaction> transactions;

  const AllTransactionsPage({super.key, required this.transactions});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Transactions'),
      ),
      body: ListView.builder(
        itemCount: transactions.length,
        itemBuilder: (context, index) {
          final transaction = transactions[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: _getCategoryColor(transaction.category),
              child: Icon(_getCategoryIcon(transaction.category),
                  color: Colors.white),
            ),
            title: Text(transaction.category),
            subtitle: Text(
              '${DateFormat('dd MMM yyyy').format(transaction.date)}\n${transaction.message}',
            ),
            trailing: Text(
              '${transaction.type == 'Debit' ? '-' : '+'} ₹${transaction.amount.toStringAsFixed(2)}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: transaction.type == 'Debit' ? Colors.red : Colors.green,
              ),
            ),
            isThreeLine: true,
          );
        },
      ),
    );
  }
}

class TransactionsPage extends StatefulWidget {
  final List<Transaction> transactions;

  const TransactionsPage({super.key, required this.transactions});

  @override
  _TransactionsPageState createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage> {
  String selectedTimeFrame = 'Weekly';
  Map<String, double> categoryTotals = {};

  @override
  void initState() {
    super.initState();
    calculateCategoryTotals();
  }

  void calculateCategoryTotals() {
    categoryTotals.clear();
    for (var transaction in widget.transactions) {
      if (transaction.type == 'Debit') {
        categoryTotals[transaction.category] =
            (categoryTotals[transaction.category] ?? 0) + transaction.amount;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Transactions',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            buildTimeFrameSelector(),
            const SizedBox(height: 16),
            buildTransactionChart(),
            const SizedBox(height: 16),
            buildCategoryLegend(),
            const SizedBox(height: 16),
            Expanded(child: buildTransactionList()),
          ],
        ),
      ),
    );
  }

  Widget buildTimeFrameSelector() {
    return SegmentedButton<String>(
      segments: const [
        ButtonSegment(value: 'Weekly', label: Text('Weekly')),
        ButtonSegment(value: 'Monthly', label: Text('Monthly')),
      ],
      selected: {selectedTimeFrame},
      onSelectionChanged: (Set<String> newSelection) {
        setState(() {
          selectedTimeFrame = newSelection.first;
        });
      },
    );
  }

  Widget buildTransactionChart() {
    return SizedBox(
      height: 300,
      child: selectedTimeFrame == 'Weekly'
          ? buildWeeklyChart()
          : buildMonthlyChart(),
    );
  }

  Widget buildWeeklyChart() {
    final weeklyData = getWeeklyData();
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: weeklyData.isEmpty
            ? 100
            : weeklyData.map((d) => d.total).reduce((a, b) => a > b ? a : b),
        barTouchData: BarTouchData(enabled: false),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                if (value >= 0 && value < weeklyData.length) {
                  return Text(weeklyData[value.toInt()].day);
                }
                return const Text('');
              },
            ),
          ),
          leftTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        gridData: const FlGridData(show: false),
        borderData: FlBorderData(show: false),
        barGroups: weeklyData.asMap().entries.map((entry) {
          return BarChartGroupData(
            x: entry.key,
            barRods: entry.value.categoryAmounts.keys.map((category) {
              return BarChartRodData(
                toY: entry.value.categoryAmounts[category]!,
                color: _getCategoryColor(category),
                width: 16,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(4)),
              );
            }).toList(),
          );
        }).toList(),
      ),
    );
  }

  Widget buildMonthlyChart() {
    final monthlyData = getMonthlyData();
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: monthlyData.isEmpty
            ? 100
            : monthlyData.map((d) => d.total).reduce((a, b) => a > b ? a : b),
        barTouchData: BarTouchData(enabled: false),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                if (value >= 0 && value < monthlyData.length) {
                  return Text(monthlyData[value.toInt()].month);
                }
                return const Text('');
              },
            ),
          ),
          leftTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        gridData: const FlGridData(show: false),
        borderData: FlBorderData(show: false),
        barGroups: monthlyData.asMap().entries.map((entry) {
          return BarChartGroupData(
            x: entry.key,
            barRods: entry.value.categoryAmounts.keys.map((category) {
              return BarChartRodData(
                toY: entry.value.categoryAmounts[category]!,
                color: _getCategoryColor(category),
                width: 16,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(4)),
              );
            }).toList(),
          );
        }).toList(),
      ),
    );
  }

  Widget buildCategoryLegend() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: categoryTotals.keys.map((category) {
        return Chip(
          avatar: CircleAvatar(
            backgroundColor: _getCategoryColor(category),
            child:
                Icon(_getCategoryIcon(category), color: Colors.white, size: 16),
          ),
          label: Text(category),
        );
      }).toList(),
    );
  }

  Widget buildTransactionList() {
    return ListView.builder(
      itemCount: widget.transactions.length,
      itemBuilder: (context, index) {
        final transaction = widget.transactions[index];
        return Container(
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: _getCategoryColor(transaction.category),
              child: Icon(_getCategoryIcon(transaction.category),
                  color: Colors.white),
            ),
            title: Text(transaction.category),
            subtitle: Text(transaction.message),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${transaction.type == 'Debit' ? '-' : '+'}₹${transaction.amount.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color:
                        transaction.type == 'Debit' ? Colors.red : Colors.green,
                  ),
                ),
                Text(DateFormat('dd MMM yyyy').format(transaction.date),
                    style: const TextStyle(fontSize: 12)),
              ],
            ),
          ),
        );
      },
    );
  }

  List<WeeklyData> getWeeklyData() {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    final weeklyData = List.generate(7, (index) {
      final day = weekStart.add(Duration(days: index));
      return WeeklyData(day: DateFormat('EEE').format(day));
    });

    for (var transaction in widget.transactions) {
      if (transaction.date.isAfter(weekStart) && transaction.type == 'Debit') {
        final dayIndex = transaction.date.difference(weekStart).inDays;
        if (dayIndex >= 0 && dayIndex < 7) {
          weeklyData[dayIndex]
              .addAmount(transaction.category, transaction.amount);
        }
      }
    }

    return weeklyData;
  }

  List<MonthlyData> getMonthlyData() {
    final now = DateTime.now();
    final monthlyData = List.generate(6, (index) {
      final month = DateTime(now.year, now.month - index, 1);
      return MonthlyData(month: DateFormat('MMM').format(month));
    });

    for (var transaction in widget.transactions) {
      if (transaction.date.isAfter(DateTime(now.year, now.month - 5, 1)) &&
          transaction.type == 'Debit') {
        final monthIndex = (now.month - transaction.date.month) % 12;
        if (monthIndex >= 0 && monthIndex < 6) {
          monthlyData[monthIndex]
              .addAmount(transaction.category, transaction.amount);
        }
      }
    }

    return monthlyData.reversed.toList();
  }
}

class WeeklyData {
  final String day;
  double total = 0;
  Map<String, double> categoryAmounts = {};

  WeeklyData({required this.day});

  void addAmount(String category, double amount) {
    total += amount;
    categoryAmounts[category] = (categoryAmounts[category] ?? 0) + amount;
  }
}

class MonthlyData {
  final String month;
  double total = 0;
  Map<String, double> categoryAmounts = {};

  MonthlyData({required this.month});

  void addAmount(String category, double amount) {
    total += amount;
    categoryAmounts[category] = (categoryAmounts[category] ?? 0) + amount;
  }
}

// AddExpensePage
class AddExpensePage extends StatefulWidget {
  final Function(String, double, String, String, DateTime) onAddTransaction;
  final Function(double) onAddToSavings; // New function to handle savings
  final double balance;
  final double income;
  final double totalExpenses;

  const AddExpensePage({
    super.key,
    required this.onAddTransaction,
    required this.onAddToSavings, // Add this line
    required this.balance,
    required this.income,
    required this.totalExpenses,
  });

  @override
  _AddExpensePageState createState() => _AddExpensePageState();
}

class _AddExpensePageState extends State<AddExpensePage> {
  final formKey = GlobalKey<FormState>();
  final amountController = TextEditingController();
  final noteController = TextEditingController();
  String selectedCategory = 'Food';
  String transactionType = 'Debit';

  @override
  void dispose() {
    amountController.dispose();
    noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Add Transaction',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 24),
              SegmentedButton<String>(
                segments: const [
                  ButtonSegment(value: 'Debit', label: Text('Expense')),
                  ButtonSegment(value: 'Credit', label: Text('Income')),
                ],
                selected: {transactionType},
                onSelectionChanged: (Set<String> newSelection) {
                  setState(() {
                    transactionType = newSelection.first;
                  });
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: amountController,
                decoration: const InputDecoration(
                  labelText: 'Amount',
                  prefixIcon: Icon(Icons.currency_rupee),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an amount';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedCategory,
                decoration: const InputDecoration(
                  labelText: 'Category',
                  prefixIcon: Icon(Icons.category),
                ),
                items: ['Food', 'Shopping', 'Entertainment', 'Travel', 'Other']
                    .map((category) => DropdownMenuItem(
                        value: category, child: Text(category)))
                    .toList(),
                onChanged: (value) => setState(() => selectedCategory = value!),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: noteController,
                decoration: const InputDecoration(
                  labelText: 'Note',
                  prefixIcon: Icon(Icons.note),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: submitTransaction,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('Save', style: TextStyle(fontSize: 18)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void submitTransaction() {
    if (formKey.currentState!.validate()) {
      final amount = double.parse(amountController.text);
      widget.onAddTransaction(
        transactionType,
        amount,
        selectedCategory,
        noteController.text,
        DateTime.now(),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${transactionType == 'Debit' ? 'Expense' : 'Income'} added successfully',
          ),
        ),
      );

      // Show savings popup only for expenses (Debit transactions)
      if (transactionType == 'Debit') {
        showSavingsPopup(amount, widget.onAddToSavings);
      }

      amountController.clear();
      noteController.clear();
      setState(() {
        selectedCategory = 'Food';
        transactionType = 'Debit';
      });
    }
  }

  void showSavingsPopup(double amount, Function(double) onAddToSavings) {
    final savingsAmount = amount * 0.05; // Calculate 5% of the expense
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Save for the future?'),
          content: Text(
            'Would you like to save ₹${savingsAmount.toStringAsFixed(2)} (5% of your expense) in your savings jar?',
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Yes'),
              onPressed: () {
                // Call the callback to add the savings amount to the savings jar
                onAddToSavings(savingsAmount);
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      '₹${savingsAmount.toStringAsFixed(2)} added to your savings jar!',
                    ),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}

// Utility functions
Color _getCategoryColor(String category) {
  switch (category.toLowerCase()) {
    case 'food':
      return Colors.orange;
    case 'shopping':
      return Colors.purple;
    case 'entertainment':
      return Colors.red;
    case 'travel':
      return Colors.blue;
    default:
      return Colors.grey;
  }
}

IconData _getCategoryIcon(String category) {
  switch (category.toLowerCase()) {
    case 'food':
      return Icons.restaurant;
    case 'shopping':
      return Icons.shopping_bag;
    case 'entertainment':
      return Icons.movie;
    case 'travel':
      return Icons.flight;
    default:
      return Icons.category;
  }
}
