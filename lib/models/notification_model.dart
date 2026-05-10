import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {
  final String id;
  final String title;
  final String body;
  final String type; // ride | wallet | promo | system
  final bool read;
  final DateTime createdAt;
  final Map<String, dynamic>? data;

  NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    required this.read,
    required this.createdAt,
    this.data,
  });

  factory NotificationModel.fromMap(String id, Map<String, dynamic> m) {
    return NotificationModel(
      id: id,
      title: (m['title'] ?? '') as String,
      body: (m['body'] ?? '') as String,
      type: (m['type'] ?? 'system') as String,
      read: (m['read'] ?? false) as bool,
      createdAt: (m['createdAt'] is Timestamp)
          ? (m['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
      data: (m['data'] as Map?)?.cast<String, dynamic>(),
    );
  }

  Map<String, dynamic> toMap() => {
        'title': title,
        'body': body,
        'type': type,
        'read': read,
        'createdAt': Timestamp.fromDate(createdAt),
        if (data != null) 'data': data,
      };
}
