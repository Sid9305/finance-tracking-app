import 'dart:convert'; // Import to use jsonEncode
import 'package:http/http.dart' as http;

Future<void> triggerWorkflow(String userId, String upiId, double amount) async {
  final response = await http.post(
    Uri.parse('http://localhost:3000/api/start-workflow'),
    headers: {
      'Content-Type': 'application/json', // Set the content type to JSON
    },
    body: jsonEncode({
      // Encode the body as JSON
      'userId': userId,
      'upiId': upiId,
      'amount': amount.toString(),
    }),
  );

  if (response.statusCode == 200) {
    print("Workflow started successfully");
  } else {
    // You might want to log the response body for debugging
    print(
        "Failed to start workflow: ${response.statusCode} - ${response.body}");
  }
}
