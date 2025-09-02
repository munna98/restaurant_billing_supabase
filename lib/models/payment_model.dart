class PaymentModel {
  final String id;
  final double amount;
  final PaymentMethod method;
  final PaymentStatus status;
  final DateTime timestamp;
  final String? transactionId;

  PaymentModel({
    required this.id,
    required this.amount,
    required this.method,
    required this.status,
    required this.timestamp,
    this.transactionId,
  });

  factory PaymentModel.fromMap(Map<String, dynamic> map) {
    return PaymentModel(
      id: map['id'] ?? '',
      amount: (map['amount'] ?? 0).toDouble(),
      method: PaymentMethod.values.firstWhere(
        (e) => e.name.toLowerCase() == (map['method'] ?? '').toLowerCase(),
        orElse: () => PaymentMethod.cash,
      ),
      status: PaymentStatus.values.firstWhere(
        (e) => e.name.toLowerCase() == (map['status'] ?? '').toLowerCase(),
        orElse: () => PaymentStatus.pending,
      ),
      timestamp: DateTime.parse(map['timestamp'] ?? DateTime.now().toIso8601String()),
      transactionId: map['transactionId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'amount': amount,
      'method': method.name,
      'status': status.name,
      'timestamp': timestamp.toIso8601String(),
      'transactionId': transactionId,
    };
  }
}

enum PaymentMethod { cash, card, upi, netBanking }
enum PaymentStatus { pending, completed, failed, refunded }