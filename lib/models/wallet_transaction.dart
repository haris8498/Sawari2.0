import 'package:cloud_firestore/cloud_firestore.dart';

enum TxnType { topup, ridePayment, refund, withdrawal, bonus }

TxnType txnTypeFromString(String? s) {
  switch (s) {
    case 'ridePayment':
      return TxnType.ridePayment;
    case 'refund':
      return TxnType.refund;
    case 'withdrawal':
      return TxnType.withdrawal;
    case 'bonus':
      return TxnType.bonus;
    default:
      return TxnType.topup;
  }
}

class WalletTransaction {
  final String id;
  final TxnType type;
  final double amount; // positive credit, negative debit
  final String? rideId;
  final String status; // pending | completed | failed
  final String? note;
  final DateTime createdAt;

  WalletTransaction({
    required this.id,
    required this.type,
    required this.amount,
    this.rideId,
    this.status = 'completed',
    this.note,
    required this.createdAt,
  });

  factory WalletTransaction.fromMap(String id, Map<String, dynamic> m) {
    return WalletTransaction(
      id: id,
      type: txnTypeFromString(m['type'] as String?),
      amount: (m['amount'] ?? 0).toDouble(),
      rideId: m['rideId'] as String?,
      status: (m['status'] ?? 'completed') as String,
      note: m['note'] as String?,
      createdAt: (m['createdAt'] is Timestamp)
          ? (m['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() => {
        'type': type.name,
        'amount': amount,
        if (rideId != null) 'rideId': rideId,
        'status': status,
        if (note != null) 'note': note,
        'createdAt': Timestamp.fromDate(createdAt),
      };
}
