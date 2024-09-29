class Payment {
  final String userId;
  final String upiId;
  final double amount;
  final DateTime timestamp;

  Payment({
    required this.userId,
    required this.upiId,
    required this.amount,
    required this.timestamp,
  });
}
