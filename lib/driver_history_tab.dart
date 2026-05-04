import 'package:flutter/material.dart';

class DriverHistoryTab extends StatefulWidget {
  const DriverHistoryTab({super.key});

  @override
  State<DriverHistoryTab> createState() => _DriverHistoryTabState();
}

class _DriverHistoryTabState extends State<DriverHistoryTab> {
  String _selectedFilter = 'All';

  // Dummy data tailored for a Driver's perspective
  final List<Map<String, dynamic>> _allRides = [
    {
      'id': '#TRP-8271',
      'date': 'Today, 2:45 PM',
      'passenger': 'Zaid Khan',
      'rating': '4.8',
      'from': 'University of Gujrat',
      'to': 'Kutchery Chowk',
      'earnings': '+\$14.50',
      'paymentType': 'Wallet',
      'status': 'Completed',
      'statusColor': const Color(0xFF10B981), // Emerald Green
    },
    {
      'id': '#TRP-9982',
      'date': 'Today, 11:20 AM',
      'passenger': 'Sarah Ahmed',
      'rating': '5.0',
      'from': 'Model Town',
      'to': 'City Hospital',
      'earnings': '+\$8.00',
      'paymentType': 'Cash',
      'status': 'Completed',
      'statusColor': const Color(0xFF10B981),
    },
    {
      'id': '#TRP-7129',
      'date': 'Yesterday, 3:15 PM',
      'passenger': 'M. Usman',
      'rating': '4.5',
      'from': 'Railway Station',
      'to': 'Fawara Chowk',
      'earnings': '+\$6.50',
      'paymentType': 'Wallet',
      'status': 'Completed',
      'statusColor': const Color(0xFF10B981),
    },
    {
      'id': '#TRP-6541',
      'date': 'Yesterday, 1:00 PM',
      'passenger': 'Ali Raza',
      'rating': '4.9',
      'from': 'Gulshan Colony',
      'to': 'GT Road',
      'earnings': '\$0.00',
      'paymentType': '-',
      'status': 'Cancelled',
      'statusColor': Colors.redAccent,
    },
    {
      'id': '#TRP-5512',
      'date': '02 May, 09:30 AM',
      'passenger': 'Hassan Tariq',
      'rating': '4.7',
      'from': 'Shadiwal Road',
      'to': 'Service Mor',
      'earnings': '+\$12.00',
      'paymentType': 'Cash',
      'status': 'Completed',
      'statusColor': const Color(0xFF10B981),
    },
  ];

  List<Map<String, dynamic>> get _filteredRides {
    if (_selectedFilter == 'All') return _allRides;
    return _allRides.where((ride) => ride['status'] == _selectedFilter).toList();
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
          ),
        ),
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Weekly Summary Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'This Week',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.grey[400] : const Color(0xFF64748B),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '42 Rides',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Text(
                    '+\$342.50',
                    style: TextStyle(
                      color: Color(0xFF10B981),
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Professional Filter Tabs
          Container(
            padding: const EdgeInsets.only(bottom: 16),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  _buildFilterChip('All'),
                  _buildFilterChip('Completed'),
                  _buildFilterChip('Cancelled'),
                ],
              ),
            ),
          ),

          // Orders List
          Expanded(
            child: _filteredRides.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              physics: const BouncingScrollPhysics(),
              itemCount: _filteredRides.length,
              itemBuilder: (context, index) {
                final ride = _filteredRides[index];
                return _buildRideCard(ride);
              },
            ),
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
              Icons.list_alt_rounded,
              size: 64,
              color: isDark ? Colors.grey[600] : const Color(0xFFCBD5E1),
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
            'Your driving history will appear here',
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

  Widget _buildRideCard(Map<String, dynamic> ride) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final statusColor = ride['statusColor'] as Color;
    final isCompleted = ride['status'] == 'Completed';

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
            // Future ride details navigation
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: Earnings and Status
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
                            color: isDark ? Colors.white.withOpacity(0.05) : const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(Icons.receipt_long, size: 20, color: isDark ? Colors.grey[400] : const Color(0xFF64748B)),
                        ),
                        const SizedBox(width: 14),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              ride['earnings'] as String,
                              style: TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 18,
                                color: isCompleted ? const Color(0xFF10B981) : theme.colorScheme.onSurface,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              ride['date'] as String,
                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: isDark ? Colors.grey[500] : const Color(0xFF94A3B8)),
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
                        ride['status'] as String,
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
                            color: isDark ? Colors.white.withOpacity(0.1) : const Color(0xFFE2E8F0)),
                        const Icon(Icons.location_on, size: 18, color: Color(0xFFD4AF37)),
                      ],
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            ride['from'] as String,
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: theme.colorScheme.onSurface),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 28),
                          Text(
                            ride['to'] as String,
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: theme.colorScheme.onSurface),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Footer: Passenger info and Action
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                decoration: BoxDecoration(
                  color: isDark ? Colors.black.withOpacity(0.2) : const Color(0xFFF8FAFC),
                ),
                child: Row(
                  children: [
                    // Passenger Avatar
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

                    // Passenger Details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            ride['passenger'] as String,
                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: isDark ? Colors.grey[300] : theme.colorScheme.onSurface),
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              const Icon(Icons.star, size: 12, color: Color(0xFFF59E0B)), // Star icon
                              const SizedBox(width: 4),
                              Text(
                                ride['rating'] as String,
                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: isDark ? Colors.grey[400] : const Color(0xFF64748B)),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),

                    // Payment Method Badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: isDark ? Colors.white.withOpacity(0.05) : const Color(0xFFE2E8F0),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            ride['paymentType'] == 'Cash' ? Icons.payments_outlined : Icons.account_balance_wallet_outlined,
                            size: 14,
                            color: isDark ? Colors.grey[300] : const Color(0xFF475569),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            ride['paymentType'] as String,
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: isDark ? Colors.grey[300] : const Color(0xFF475569)),
                          ),
                        ],
                      ),
                    ),
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