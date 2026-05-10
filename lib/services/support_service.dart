import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SupportService {
  SupportService._();
  static final SupportService instance = SupportService._();

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> submitTicket({
    required String subject,
    required String message,
  }) async {
    final uid = _auth.currentUser?.uid;
    await _db.collection('supportTickets').add({
      'uid': uid,
      'subject': subject,
      'message': message,
      'status': 'open',
      'createdAt': Timestamp.fromDate(DateTime.now()),
    });
  }
}
