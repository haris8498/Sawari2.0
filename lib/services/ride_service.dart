import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/ride_model.dart';

class RideService {
  RideService._();
  static final RideService instance = RideService._();

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  CollectionReference<Map<String, dynamic>> get _rides =>
      _db.collection('rides');

  Future<RideModel> requestRide({
    required RideLocation pickup,
    required RideLocation dropoff,
    required String vehicleType,
    required double estimatedFare,
    String paymentMethod = 'cash',
    String? passengerName,
  }) async {
    final uid = _auth.currentUser!.uid;
    final doc = _rides.doc();
    final ride = RideModel(
      id: doc.id,
      passengerId: uid,
      passengerName: passengerName,
      vehicleType: vehicleType,
      pickup: pickup,
      dropoff: dropoff,
      status: RideStatus.requested,
      fare: estimatedFare,
      paymentMethod: paymentMethod,
      requestedAt: DateTime.now(),
    );
    await doc.set(ride.toMap());
    return ride;
  }

  Future<void> cancelRide(String rideId, {String? reason}) async {
    await _rides.doc(rideId).update({
      'status': rideStatusToString(RideStatus.cancelled),
      if (reason != null) 'cancelReason': reason,
    });
  }

  Future<void> acceptRide(String rideId,
      {required String driverId,
      required String driverName,
      String? plate}) async {
    await _rides.doc(rideId).update({
      'driverId': driverId,
      'driverName': driverName,
      if (plate != null) 'vehiclePlate': plate,
      'status': rideStatusToString(RideStatus.accepted),
      'acceptedAt': Timestamp.fromDate(DateTime.now()),
    });
  }

  Future<void> updateStatus(String rideId, RideStatus status) async {
    final patch = <String, dynamic>{'status': rideStatusToString(status)};
    if (status == RideStatus.completed) {
      patch['completedAt'] = Timestamp.fromDate(DateTime.now());
    }
    await _rides.doc(rideId).update(patch);
  }

  /// Stream of the current passenger's rides (history + active).
  Stream<List<RideModel>> passengerRides(String passengerUid) {
    return _rides
        .where('passengerId', isEqualTo: passengerUid)
        .orderBy('requestedAt', descending: true)
        .snapshots()
        .map((s) =>
            s.docs.map((d) => RideModel.fromMap(d.id, d.data())).toList());
  }

  /// Stream of a driver's completed/active trips.
  Stream<List<RideModel>> driverRides(String driverUid) {
    return _rides
        .where('driverId', isEqualTo: driverUid)
        .orderBy('requestedAt', descending: true)
        .snapshots()
        .map((s) =>
            s.docs.map((d) => RideModel.fromMap(d.id, d.data())).toList());
  }

  /// Open ride requests visible to nearby drivers (server-side filtering by
  /// geo can be added with GeoFlutterFire; this is a basic feed).
  Stream<List<RideModel>> openRequests() {
    return _rides
        .where('status', isEqualTo: 'requested')
        .orderBy('requestedAt', descending: true)
        .limit(50)
        .snapshots()
        .map((s) =>
            s.docs.map((d) => RideModel.fromMap(d.id, d.data())).toList());
  }

  Stream<RideModel?> rideStream(String rideId) {
    return _rides.doc(rideId).snapshots().map(
        (s) => s.exists ? RideModel.fromMap(s.id, s.data()!) : null);
  }
}
