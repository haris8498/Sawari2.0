import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  StorageService._();
  static final StorageService instance = StorageService._();

  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> uploadProfilePhoto(File file) async {
    final uid = _auth.currentUser!.uid;
    final ext = file.path.split('.').last;
    final ref = _storage.ref('users/$uid/profile.$ext');
    await ref.putFile(file);
    return ref.getDownloadURL();
  }

  Future<String> uploadDriverDocument(File file, String docName) async {
    final uid = _auth.currentUser!.uid;
    final ext = file.path.split('.').last;
    final ref = _storage.ref('drivers/$uid/$docName.$ext');
    await ref.putFile(file);
    return ref.getDownloadURL();
  }
}
