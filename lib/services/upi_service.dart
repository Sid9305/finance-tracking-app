// import 'package:upi_pay/upi_pay.dart';

// class UpiService {
//   Future<String> initiateTransaction(String upiId, double amount) async {
//     try {
//       final transactionRef = DateTime.now().millisecondsSinceEpoch.toString();
//       final response = await UpiPay.initiateTransaction(
//         amount: amount.toStringAsFixed(2),
//         app: UpiApplication
//             .googlePay, // You can change this to other UPI apps if needed
//         receiverName: 'Savings Jar',
//         receiverUpiAddress: upiId,
//         transactionRef: transactionRef,
//         transactionNote: 'Saving for future',
//       );

//       print("Transaction Response: $response");
//       return response.status.toString();
//     } catch (e) {
//       print("Error during transaction: $e");
//       return "Transaction failed";
//     }
//   }
// }
