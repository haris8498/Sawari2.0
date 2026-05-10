import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'models/ride_model.dart';
import 'services/ride_service.dart';

class PassengerOrdersTab extends StatefulWidget {
  const PassengerOrdersTab({super.key});

  @override
  State<PassengerOrdersTab> createState() => _PassengerOrdersTabState();
}

class _PassengerOrdersTabState extends State<PassengerOrdersTab> {
  String _selectedFilter = 'All';

  // ignore: unused_field
  final List<Map<String, dynamic>> _legacyOrders = [
    {
      'id': '#SW-8271',
      'date': 'Today, 10:30 AM',
      'from': 'Gulshan Colony, Jalalpur Jattan',
      'to': 'GT Road, Gujrat',
      'fare': '\$12.50',
      'status': 'Completed',
      'statusColor': Colors.green,
      'vehicleType': 'Ride (Car)',
      'vehicleIcon': Icons.directions_car,
      'driver': 'Ahmed Ali',
      'plate': 'LEC-1234',
    },
    {
      'id': '#SW-9982',
      'date': 'Tomorrow, 08:00 AM',
      'from': 'Home (Model Town)',
      'to': 'Office Tower A',
      'fare': '\$10.00',
      'status': 'Upcoming',
      'statusColor': const Color(0xFFD4AF37),
      'vehicleType': 'Ride (Car)',
      'vehicleIcon': Icons.directions_car,
      'driver': 'Waiting for assignment',
      'plate': '---',
    },
    {
      'id': '#SW-7129',
      'date': 'Yesterday, 06:15 PM',
      'from': 'Kutchery Chowk, Gujrat',
      'to': 'University of Gujrat',
      'fare': '\$18.00',
      'status': 'Completed',
      'statusColor': Colors.green,
      'vehicleType': 'City to City',
      'vehicleIcon': Icons.location_city,
      'driver': 'Zaid Khan',
      'plate': 'GTR-5678',
    },
    {
      'id': '#SW-6541',
      'date': '02 May, 09:00 AM',
      'from': 'Fawara Chowk',
      'to': 'Railway Station, Gujrat',
      'fare': '\$5.00',
      'status': 'Cancelled',
      'statusColor': Colors.redAccent,
      'vehicleType': 'Rickshaw',
      'vehicleIcon': Icons.electric_rickshaw,
      'driver': 'M. Usman',
      'plate': 'RIC-992',
    },
    {
      'id': '#SW-5512',
      'date': '01 May, 11:30 PM',
      'from': 'Shadiwal Road',
      'to': 'City Hospital',
      'fare': '\$15.00',
      'status': 'Completed',
      'statusColor': Colors.green,
      'vehicleType': 'Moto',
      'vehicleIcon': Icons.two_wheeler,
      'driver': 'Ali Raza',
      'plate': 'MTO-441',
    },
  ];

  String _statusLabel(RideStatus s) {
    switch (s) {
      case RideStatus.completed:
        return 'Completed';
      case RideStatus.cancelled:
        return 'Cancelled';
      case RideStatus.requested:
      case RideStatus.accepted:
      case RideStatus.arrived:
      case RideStatus.ongoing:
        return 'Upcoming';
    }
  }

  Color _statusColor(RideStatus s) {
    switch (s) {
      case RideStatus.completed:
        return Colors.green;
      case RideStatus.cancelled:
        return Colors.redAccent;
      default:
        return const Color(0xFFD4AF37);
    }
  }

  IconData _vehicleIcon(String vt) {
    final v = vt.toLowerCase();
    if (v.contains('moto') || v.contains('bike')) return Icons.two_wheeler;
    if (v.contains('rickshaw')) return Icons.electric_rickshaw;
    if (v.contains('city')) return Icons.location_city;
    return Icons.directions_car;
  }

  List<RideModel> _filter(List<RideModel> rides) {
    if (_selectedFilter == 'All') return rides;
    return rides.where((r) => _statusLabel(r.status) == _selectedFilter).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
            'Ride History',
            style: TextStyle(
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.5,
            )
        ),
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Professional Filter Tabs
          Container(
            color: theme.scaffoldBackgroundColor,
            padding: const EdgeInsets.only(top: 8, bottom: 16),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  _buildFilterChip('All'),
                  _buildFilterChip('Upcoming'),
                  _buildFilterChip('Completed'),
                  _buildFilterChip('Cancelled'),
                ],
              ),
            ),
          ),

          // Orders List (live)
          Expanded(
            child: Builder(builder: (context) {
              final uid = FirebaseAuth.instance.currentUser?.uid;
              if (uid == null) return _buildEmptyState();
              return StreamBuilder<List<RideModel>>(
                stream: RideService.instance.passengerRides(uid),
                builder: (context, snap) {
                  if (snap.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final rides = _filter(snap.data ?? const <RideModel>[]);
                  if (rides.isEmpty) return _buildEmptyState();
                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    physics: const BouncingScrollPhysics(),
                    itemCount: rides.length,
                    itemBuilder: (context, index) =>
                        _buildOrderCard(rides[index]),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: isDark ? Colors.white.withOpacity(0.05) : const Color(0xFFF1F5F9),
              shape: BoxShape.circle,
            ),
            child: Icon(
                Icons.receipt_long_outlined,
                size: 64,
                color: isDark ? Colors.grey[600] : const Color(0xFFCBD5E1)
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No $_selectedFilter rides found',
            style: TextStyle(
              fontSize: 18,
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your ride history will appear here',
            style: TextStyle(
              fontSize: 14,
              color: isDark ? Colors.grey[500] : const Color(0xFF64748B),
            ),
          ),
          const SizedBox(height: 60), // Optical centering
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isSelected = _selectedFilter == label;

    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: Material(
        color: isSelected ? theme.colorScheme.primary : (isDark ? Colors.white.withOpacity(0.05) : const Color(0xFFF1F5F9)),
        borderRadius: BorderRadius.circular(24),
        elevation: isSelected ? 2 : 0,
        shadowColor: theme.colorScheme.primary.withOpacity(0.4),
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: () => setState(() => _selectedFilter = label),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : (isDark ? Colors.grey[400] : const Color(0xFF64748B)),
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOrderCard(RideModel ride) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final statusColor = _statusColor(ride.status);
    final order = <String, dynamic>{
      'id': '#${ride.id.substring(0, ride.id.length > 6 ? 6 : ride.id.length).toUpperCase()}',
      'date': DateFormat('MMM d, h:mm a').format(ride.requestedAt),
      'from': ride.pickup.address.isEmpty ? '—' : ride.pickup.address,
      'to': ride.dropoff.address.isEmpty ? '—' : ride.dropoff.address,
      'fare': '\$${ride.fare.toStringAsFixed(2)}',
      'status': _statusLabel(ride.status),
      'vehicleType': ride.vehicleType,
      'vehicleIcon': _vehicleIcon(ride.vehicleType),
      'driver': ride.driverName ?? 'Waiting for assignment',
      'plate': ride.vehiclePlate ?? '---',
    };

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.04),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: isDark ? Colors.white.withOpacity(0.05) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () {
            // Future order details navigation
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: Status and ID
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(order['vehicleIcon'] as IconData, size: 20, color: theme.colorScheme.primary),
                        ),
                        const SizedBox(width: 14),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              order['vehicleType'] as String,
                              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: theme.colorScheme.onSurface),
                            ),
                            const SizedBox(height: 2),
                            Text(
                                order['id'] as String,
                                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: isDark ? Colors.grey[500] : const Color(0xFF94A3B8))
                            ),
                          ],
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: isDark ? statusColor.withOpacity(0.15) : statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: statusColor.withOpacity(0.3)),
                      ),
                      child: Text(
                        order['status'] as String,
                        style: TextStyle(color: statusColor, fontWeight: FontWeight.w700, fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),

              Divider(height: 1, thickness: 1, color: isDark ? Colors.white.withOpacity(0.05) : const Color(0xFFF1F5F9)),

              // Route info
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Route line
                    Column(
                      children: [
                        Icon(Icons.radio_button_checked, size: 18, color: theme.colorScheme.primary),
                        Container(
                            width: 2,
                            height: 32,
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            color: isDark ? Colors.white.withOpacity(0.1) : const Color(0xFFE2E8F0)
                        ),
                        const Icon(Icons.location_on, size: 18, color: Color(0xFFD4AF37)),
                      ],
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            order['from'] as String,
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: theme.colorScheme.onSurface),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 28),
                          Text(
                            order['to'] as String,
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: theme.colorScheme.onSurface),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    // Fare
                    Text(
                      order['fare'] as String,
                      style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18, color: theme.colorScheme.primary),
                    ),
                  ],
                ),
              ),

              // Footer: Driver info and Action
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                decoration: BoxDecoration(
                  color: isDark ? Colors.black.withOpacity(0.2) : const Color(0xFFF8FAFC),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: isDark ? Colors.white.withOpacity(0.1) : Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: isDark ? Colors.transparent : const Color(0xFFE2E8F0)),
                      ),
                      child: Icon(Icons.person, size: 16, color: isDark ? Colors.grey[400] : const Color(0xFF64748B)),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              order['driver'] as String,
                              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: isDark ? Colors.grey[300] : theme.colorScheme.onSurface)
                          ),
                          const SizedBox(height: 2),
                          Text(
                              order['plate'] as String,
                              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: isDark ? Colors.grey[500] : const Color(0xFF64748B))
                          ),
                        ],
                      ),
                    ),
                    Text(
                      order['date'] as String,
                      style: TextStyle(fontSize: 12, color: isDark ? Colors.grey[500] : const Color(0xFF64748B), fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(width: 8),
                    Icon(Icons.chevron_right_rounded, size: 20, color: isDark ? Colors.grey[600] : const Color(0xFF94A3B8)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}