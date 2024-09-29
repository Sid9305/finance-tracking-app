import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart'; // Import fluttertoast

class UPIPaymentScreen extends StatefulWidget {
  final String userId;
  final String upiId;

  const UPIPaymentScreen(
      {super.key, required this.userId, required this.upiId});

  @override
  _UPIPaymentScreenState createState() => _UPIPaymentScreenState();
}

class _UPIPaymentScreenState extends State<UPIPaymentScreen> {
  final TextEditingController amountController = TextEditingController();

  Future<void> processPayment() async {
    final double amount = double.tryParse(amountController.text) ?? 0;

    if (amount <= 0) {
      Fluttertoast.showToast(
        msg: "Please enter a valid amount.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return;
    }

// Change the gravity reference in the Fluttertoast.showToast method
    Fluttertoast.showToast(
      msg: "Payment of ₹$amount done!",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM, // Ensure this matches the latest library
      backgroundColor: Colors.green,
      textColor: Colors.white,
      fontSize: 16.0,
    );
    // Clear the text field after payment
    amountController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('UPI Payment')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter Amount',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                processPayment();
              },
              child: const Text('Pay'),
            ),
          ],
        ),
      ),
    );
  }
}
