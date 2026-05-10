import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/notification_model.dart';

class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  CollectionReference<Map<String, dynamic>> _items(String uid) => _db
      .collection('users')
      .doc(uid)
      .collection('notifications');

  Stream<List<NotificationModel>> stream() {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return Stream.value([]);
    return _items(uid)
        .orderBy('createdAt', descending: true)
        .limit(100)
        .snapshots()
        .map((s) => s.docs
            .map((d) => NotificationModel.fromMap(d.id, d.data()))
            .toList());
  }

  Future<void> markRead(String id) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;
    await _items(uid).doc(id).update({'read': true});
  }

  Future<void> markAllRead() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;
    final batch = _db.batch();
    final unread =
        await _items(uid).where('read', isEqualTo: false).get();
    for (final d in unread.docs) {
      batch.update(d.reference, {'read': true});
    }
    await batch.commit();
  }
}
