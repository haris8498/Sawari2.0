import 'package:cloud_firestore/cloud_firestore.dart';

enum RideStatus { requested, accepted, arrived, ongoing, completed, cancelled }

RideStatus rideStatusFromString(String? s) {
  switch (s) {
    case 'accepted':
      return RideStatus.accepted;
    case 'arrived':
      return RideStatus.arrived;
    case 'ongoing':
      return RideStatus.ongoing;
    case 'completed':
      return RideStatus.completed;
    case 'cancelled':
      return RideStatus.cancelled;
    default:
      return RideStatus.requested;
  }
}

String rideStatusToString(RideStatus s) => s.name;

class RideLocation {
  final String address;
  final double lat;
  final double lng;
  RideLocation({required this.address, required this.lat, required this.lng});

  factory RideLocation.fromMap(Map<String, dynamic> m) => RideLocation(
        address: (m['address'] ?? '') as String,
        lat: (m['lat'] ?? 0).toDouble(),
        lng: (m['lng'] ?? 0).toDouble(),
      );

  Map<String, dynamic> toMap() => {
        'address': address,
        'lat': lat,
        'lng': lng,
      };
}

class RideModel {
  final String id;
  final String passengerId;
  final String? driverId;
  final String? passengerName;
  final String? driverName;
  final String? vehiclePlate;
  final String vehicleType; // Car, Moto, Rickshaw, City to City, etc.
  final RideLocation pickup;
  final RideLocation dropoff;
  final RideStatus status;
  final double fare;
  final double? distanceKm;
  final int? durationMin;
  final String paymentMethod; // cash | wallet | card
  final DateTime requestedAt;
  final DateTime? acceptedAt;
  final DateTime? completedAt;
  final double? passengerRating;
  final double? driverRating;
  final String? cancelReason;

  RideModel({
    required this.id,
    required this.passengerId,
    this.driverId,
    this.passengerName,
    this.driverName,
    this.vehiclePlate,
    required this.vehicleType,
    required this.pickup,
    required this.dropoff,
    required this.status,
    required this.fare,
    this.distanceKm,
    this.durationMin,
    this.paymentMethod = 'cash',
    required this.requestedAt,
    this.acceptedAt,
    this.completedAt,
    this.passengerRating,
    this.driverRating,
    this.cancelReason,
  });

  factory RideModel.fromMap(String id, Map<String, dynamic> m) {
    return RideModel(
      id: id,
      passengerId: (m['passengerId'] ?? '') as String,
      driverId: m['driverId'] as String?,
      passengerName: m['passengerName'] as String?,
      driverName: m['driverName'] as String?,
      vehiclePlate: m['vehiclePlate'] as String?,
      vehicleType: (m['vehicleType'] ?? 'Car') as String,
      pickup: RideLocation.fromMap(
          (m['pickup'] as Map?)?.cast<String, dynamic>() ?? {}),
      dropoff: RideLocation.fromMap(
          (m['dropoff'] as Map?)?.cast<String, dynamic>() ?? {}),
      status: rideStatusFromString(m['status'] as String?),
      fare: (m['fare'] ?? 0).toDouble(),
      distanceKm: (m['distanceKm'] as num?)?.toDouble(),
      durationMin: (m['durationMin'] as num?)?.toInt(),
      paymentMethod: (m['paymentMethod'] ?? 'cash') as String,
      requestedAt: (m['requestedAt'] is Timestamp)
          ? (m['requestedAt'] as Timestamp).toDate()
          : DateTime.now(),
      acceptedAt: (m['acceptedAt'] is Timestamp)
          ? (m['acceptedAt'] as Timestamp).toDate()
          : null,
      completedAt: (m['completedAt'] is Timestamp)
          ? (m['completedAt'] as Timestamp).toDate()
          : null,
      passengerRating: (m['passengerRating'] as num?)?.toDouble(),
      driverRating: (m['driverRating'] as num?)?.toDouble(),
      cancelReason: m['cancelReason'] as String?,
    );
  }

  Map<String, dynamic> toMap() => {
        'passengerId': passengerId,
        if (driverId != null) 'driverId': driverId,
        if (passengerName != null) 'passengerName': passengerName,
        if (driverName != null) 'driverName': driverName,
        if (vehiclePlate != null) 'vehiclePlate': vehiclePlate,
        'vehicleType': vehicleType,
        'pickup': pickup.toMap(),
        'dropoff': dropoff.toMap(),
        'status': rideStatusToString(status),
        'fare': fare,
        if (distanceKm != null) 'distanceKm': distanceKm,
        if (durationMin != null) 'durationMin': durationMin,
        'paymentMethod': paymentMethod,
        'requestedAt': Timestamp.fromDate(requestedAt),
        if (acceptedAt != null) 'acceptedAt': Timestamp.fromDate(acceptedAt!),
        if (completedAt != null)
          'completedAt': Timestamp.fromDate(completedAt!),
        if (passengerRating != null) 'passengerRating': passengerRating,
        if (driverRating != null) 'driverRating': driverRating,
        if (cancelReason != null) 'cancelReason': cancelReason,
      };
}
