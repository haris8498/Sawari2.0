import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/wallet_transaction.dart';

class WalletService {
  WalletService._();
  static final WalletService instance = WalletService._();

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  DocumentReference<Map<String, dynamic>> _userDoc(String uid) =>
      _db.collection('users').doc(uid);

  CollectionReference<Map<String, dynamic>> _txns(String uid) =>
      _userDoc(uid).collection('transactions');

  Stream<double> balanceStream(String uid) {
    return _userDoc(uid).snapshots().map((s) {
      final v = s.data()?['walletBalance'];
      return (v is num) ? v.toDouble() : 0.0;
    });
  }

  Stream<List<WalletTransaction>> transactionsStream(String uid) {
    return _txns(uid)
        .orderBy('createdAt', descending: true)
        .limit(100)
        .snapshots()
        .map((s) => s.docs
            .map((d) => WalletTransaction.fromMap(d.id, d.data()))
            .toList());
  }

  Future<void> topUp({
    required double amount,
    String note = 'Wallet top-up',
  }) async {
    final uid = _auth.currentUser!.uid;
    final ref = _userDoc(uid);
    final txnRef = _txns(uid).doc();
    await _db.runTransaction((tx) async {
      final snap = await tx.get(ref);
      final current = (snap.data()?['walletBalance'] ?? 0).toDouble();
      tx.update(ref, {'walletBalance': current + amount});
      tx.set(
        txnRef,
        WalletTransaction(
          id: txnRef.id,
          type: TxnType.topup,
          amount: amount,
          note: note,
          createdAt: DateTime.now(),
        ).toMap(),
      );
    });
  }

  Future<void> chargeRide({
    required String rideId,
    required double amount,
  }) async {
    final uid = _auth.currentUser!.uid;
    final ref = _userDoc(uid);
    final txnRef = _txns(uid).doc();
    await _db.runTransaction((tx) async {
      final snap = await tx.get(ref);
      final current = (snap.data()?['walletBalance'] ?? 0).toDouble();
      if (current < amount) {
        throw StateError('Insufficient balance');
      }
      tx.update(ref, {'walletBalance': current - amount});
      tx.set(
        txnRef,
        WalletTransaction(
          id: txnRef.id,
          type: TxnType.ridePayment,
          amount: -amount,
          rideId: rideId,
          note: 'Ride payment',
          createdAt: DateTime.now(),
        ).toMap(),
      );
    });
  }
}
