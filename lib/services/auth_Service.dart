import 'package:http/http.dart' as http;

Future<void> triggerWorkflow(String userId, String upiId, double amount) async {
  final response = await http.post(
    Uri.parse('http://localhost:3000/api/start-workflow'),
    body: {
      'userId': userId,
      'upiId': upiId,
      'amount': amount.toString(),
    },
  );
  if (response.statusCode == 200) {
    print("Workflow started successfully");
  } else {
    print("Failed to start workflow");
  }
}
