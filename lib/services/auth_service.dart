import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/user_model.dart';

/// Centralized auth + user-profile service.
///
/// Sign-up takes a real email; verification is done via the standard Firebase
/// `sendEmailVerification` link. The user's CNIC, phone, name etc. are stored
/// in Firestore at `users/{uid}`.
class AuthService {
  AuthService._();
  static final AuthService instance = AuthService._();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;
  Stream<User?> authStateChanges() => _auth.authStateChanges();

  // --------------------------------------------------------------------------
  // Sign up
  // --------------------------------------------------------------------------

  /// Creates Firebase Auth user with synthesized email + password and writes
  /// the corresponding `users/{uid}` document.
  Future<UserModel> signUpPassenger({
    required String name,
    required String email,
    required String phone,
    required String cnic,
    required String password,
  }) async {
    final cred = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    final uid = cred.user!.uid;
    await cred.user!.sendEmailVerification();

    final user = UserModel(
      uid: uid,
      name: name,
      phone: phone,
      cnic: cnic,
      email: email,
      role: UserRole.passenger,
      createdAt: DateTime.now(),
      walletBalance: 0,
    );
    await _db.collection('users').doc(uid).set(user.toMap());
    return user;
  }

  Future<UserModel> signUpDriver({
    required String name,
    required String email,
    required String phone,
    required String cnic,
    required String password,
    required String licenseNumber,
    required String vehicleMakeModel,
    required String vehicleRegistration,
  }) async {
    final cred = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    final uid = cred.user!.uid;
    await cred.user!.sendEmailVerification();

    final user = UserModel(
      uid: uid,
      name: name,
      phone: phone,
      cnic: cnic,
      email: email,
      role: UserRole.driver,
      licenseNumber: licenseNumber,
      vehicleMakeModel: vehicleMakeModel,
      vehicleRegistration: vehicleRegistration,
      driverStatus: 'offline',
      approvalStatus: 'pending',
      totalEarnings: 0,
      createdAt: DateTime.now(),
    );
    await _db.collection('users').doc(uid).set(user.toMap());
    return user;
  }

  // --------------------------------------------------------------------------
  // Email verification
  // --------------------------------------------------------------------------

  Future<void> sendVerificationEmail() async {
    final u = _auth.currentUser;
    if (u == null) throw StateError('Not signed in');
    if (u.emailVerified) return;
    await u.sendEmailVerification();
  }

  /// Re-fetches the user from Firebase and returns whether their email is
  /// verified. Also flips `users/{uid}.isVerified` in Firestore once verified.
  Future<bool> reloadAndCheckVerified() async {
    final u = _auth.currentUser;
    if (u == null) return false;
    await u.reload();
    final fresh = _auth.currentUser;
    final verified = fresh?.emailVerified ?? false;
    if (verified) {
      await _db.collection('users').doc(fresh!.uid).update({
        'isVerified': true,
        'updatedAt': Timestamp.fromDate(DateTime.now()),
      });
    }
    return verified;
  }

  // --------------------------------------------------------------------------
  // Sign in
  // --------------------------------------------------------------------------

  Future<UserModel> signInWithEmail({
    required String email,
    required String password,
  }) async {
    final cred = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    final uid = cred.user!.uid;
    final snap = await _db.collection('users').doc(uid).get();
    if (!snap.exists) {
      throw FirebaseAuthException(
        code: 'user-profile-missing',
        message: 'Account exists but profile is missing.',
      );
    }
    return UserModel.fromMap(uid, snap.data()!);
  }

  Future<void> signOut() => _auth.signOut();

  // --------------------------------------------------------------------------
  // Phone OTP verification (links phone credential to existing user)
  // --------------------------------------------------------------------------

  /// Sends an OTP code to [phone]. Pass the resulting verificationId into
  /// [confirmOtp]. Phone numbers must be in E.164 format (e.g. +923001234567).
  Future<void> sendOtp({
    required String phone,
    required void Function(String verificationId, int? resendToken) onCodeSent,
    required void Function(FirebaseAuthException e) onFailed,
    void Function(PhoneAuthCredential cred)? onAutoVerified,
  }) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phone,
      timeout: const Duration(seconds: 60),
      verificationCompleted: (cred) async {
        if (onAutoVerified != null) onAutoVerified(cred);
      },
      verificationFailed: onFailed,
      codeSent: onCodeSent,
      codeAutoRetrievalTimeout: (_) {},
    );
  }

  /// Confirms the SMS code; if a user is signed in, links phone credential
  /// to that user. Otherwise signs in with the phone credential directly.
  Future<void> confirmOtp({
    required String verificationId,
    required String smsCode,
  }) async {
    final cred = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: smsCode,
    );
    final user = _auth.currentUser;
    if (user != null) {
      try {
        await user.linkWithCredential(cred);
      } on FirebaseAuthException catch (e) {
        // If already linked or provider conflict, just sign in.
        if (e.code != 'provider-already-linked' &&
            e.code != 'credential-already-in-use') {
          rethrow;
        }
      }
      await _db.collection('users').doc(user.uid).update({
        'isVerified': true,
        'updatedAt': Timestamp.fromDate(DateTime.now()),
      });
    } else {
      await _auth.signInWithCredential(cred);
    }
  }

  // --------------------------------------------------------------------------
  // Profile helpers
  // --------------------------------------------------------------------------

  Future<UserModel?> getCurrentProfile() async {
    final u = _auth.currentUser;
    if (u == null) return null;
    final snap = await _db.collection('users').doc(u.uid).get();
    if (!snap.exists) return null;
    return UserModel.fromMap(u.uid, snap.data()!);
  }

  Stream<UserModel?> currentProfileStream() {
    final u = _auth.currentUser;
    if (u == null) return Stream.value(null);
    return _db
        .collection('users')
        .doc(u.uid)
        .snapshots()
        .map((s) => s.exists ? UserModel.fromMap(s.id, s.data()!) : null);
  }

  Future<void> updateProfile(Map<String, dynamic> patch) async {
    final u = _auth.currentUser;
    if (u == null) throw StateError('Not signed in');
    patch['updatedAt'] = Timestamp.fromDate(DateTime.now());
    await _db.collection('users').doc(u.uid).update(patch);
  }
}
