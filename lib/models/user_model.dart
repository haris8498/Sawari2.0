import 'package:cloud_firestore/cloud_firestore.dart';

enum UserRole { passenger, driver }

class UserModel {
  final String uid;
  final String name;
  final String phone;
  final String cnic;
  final String email; // synthesized: <cnic>@sawari.app
  final UserRole role;
  final String? photoUrl;
  final double rating;
  final int totalRides;
  final bool isVerified;
  final bool isActive;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String? fcmToken;

  // Driver-specific (null for passengers)
  final String? licenseNumber;
  final String? vehicleMakeModel;
  final String? vehicleRegistration;
  final String? driverStatus; // online | offline | on_trip
  final String? approvalStatus; // pending | approved | rejected
  final double? totalEarnings;

  // Passenger-specific
  final double? walletBalance;

  UserModel({
    required this.uid,
    required this.name,
    required this.phone,
    required this.cnic,
    required this.email,
    required this.role,
    this.photoUrl,
    this.rating = 5.0,
    this.totalRides = 0,
    this.isVerified = false,
    this.isActive = true,
    required this.createdAt,
    this.updatedAt,
    this.fcmToken,
    this.licenseNumber,
    this.vehicleMakeModel,
    this.vehicleRegistration,
    this.driverStatus,
    this.approvalStatus,
    this.totalEarnings,
    this.walletBalance,
  });

  factory UserModel.fromMap(String uid, Map<String, dynamic> m) {
    return UserModel(
      uid: uid,
      name: (m['name'] ?? '') as String,
      phone: (m['phone'] ?? '') as String,
      cnic: (m['cnic'] ?? '') as String,
      email: (m['email'] ?? '') as String,
      role: (m['role'] == 'driver') ? UserRole.driver : UserRole.passenger,
      photoUrl: m['photoUrl'] as String?,
      rating: (m['rating'] ?? 5.0).toDouble(),
      totalRides: (m['totalRides'] ?? 0) as int,
      isVerified: (m['isVerified'] ?? false) as bool,
      isActive: (m['isActive'] ?? true) as bool,
      createdAt: (m['createdAt'] is Timestamp)
          ? (m['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
      updatedAt: (m['updatedAt'] is Timestamp)
          ? (m['updatedAt'] as Timestamp).toDate()
          : null,
      fcmToken: m['fcmToken'] as String?,
      licenseNumber: m['licenseNumber'] as String?,
      vehicleMakeModel: m['vehicleMakeModel'] as String?,
      vehicleRegistration: m['vehicleRegistration'] as String?,
      driverStatus: m['driverStatus'] as String?,
      approvalStatus: m['approvalStatus'] as String?,
      totalEarnings: (m['totalEarnings'] as num?)?.toDouble(),
      walletBalance: (m['walletBalance'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toMap() => {
        'name': name,
        'phone': phone,
        'cnic': cnic,
        'email': email,
        'role': role == UserRole.driver ? 'driver' : 'passenger',
        if (photoUrl != null) 'photoUrl': photoUrl,
        'rating': rating,
        'totalRides': totalRides,
        'isVerified': isVerified,
        'isActive': isActive,
        'createdAt': Timestamp.fromDate(createdAt),
        if (updatedAt != null) 'updatedAt': Timestamp.fromDate(updatedAt!),
        if (fcmToken != null) 'fcmToken': fcmToken,
        if (licenseNumber != null) 'licenseNumber': licenseNumber,
        if (vehicleMakeModel != null) 'vehicleMakeModel': vehicleMakeModel,
        if (vehicleRegistration != null)
          'vehicleRegistration': vehicleRegistration,
        if (driverStatus != null) 'driverStatus': driverStatus,
        if (approvalStatus != null) 'approvalStatus': approvalStatus,
        if (totalEarnings != null) 'totalEarnings': totalEarnings,
        if (walletBalance != null) 'walletBalance': walletBalance,
      };
}
