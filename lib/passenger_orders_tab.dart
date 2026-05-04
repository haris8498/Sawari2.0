import 'package:flutter/material.dart';

class PassengerOrdersTab extends StatefulWidget {
  const PassengerOrdersTab({super.key});

  @override
  State<PassengerOrdersTab> createState() => _PassengerOrdersTabState();
}

class _PassengerOrdersTabState extends State<PassengerOrdersTab> {
  String _selectedFilter = 'All';
  
  final List<Map<String, dynamic>> _allOrders = [
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
      'statusColor': Colors.red,
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

  List<Map<String, dynamic>> get _filteredOrders {
    if (_selectedFilter == 'All') return _allOrders;
    return _allOrders.where((order) => order['status'] == _selectedFilter).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
      appBar: AppBar(
        title: Text('Ride History', style: TextStyle(color: theme.colorScheme.onSurface, fontWeight: FontWeight.bold)),
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Professional Filter Tabs
          Container(
            color: theme.scaffoldBackgroundColor,
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
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
          
          // Orders List
          Expanded(
            child: _filteredOrders.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    physics: const BouncingScrollPhysics(),
                    itemCount: _filteredOrders.length,
                    itemBuilder: (context, index) {
                      final order = _filteredOrders[index];
                      return _buildOrderCard(order);
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
          Icon(Icons.history_outlined, size: 80, color: isDark ? Colors.white10 : Colors.grey.withOpacity(0.3)),
          const SizedBox(height: 16),
          Text(
            'No $_selectedFilter rides found',
            style: TextStyle(fontSize: 16, color: isDark ? Colors.grey[500] : const Color(0xFF64748B), fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isSelected = _selectedFilter == label;
    return GestureDetector(
      onTap: () => setState(() => _selectedFilter = label),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? theme.colorScheme.primary : (isDark ? Colors.white.withOpacity(0.05) : const Color(0xFFF1F5F9)),
          borderRadius: BorderRadius.circular(25),
          boxShadow: isSelected ? [
            BoxShadow(
              color: theme.colorScheme.primary.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ] : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : (isDark ? Colors.grey[400] : const Color(0xFF64748B)),
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildOrderCard(Map<String, dynamic> order) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.05) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
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
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withOpacity(0.05),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(order['vehicleIcon'] as IconData, size: 18, color: theme.colorScheme.primary),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          order['vehicleType'] as String,
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: theme.colorScheme.onSurface),
                        ),
                        Text(order['id'] as String, style: TextStyle(fontSize: 12, color: isDark ? Colors.grey[500] : const Color(0xFF94A3B8))),
                      ],
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: (order['statusColor'] as Color).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    order['status'] as String,
                    style: TextStyle(color: order['statusColor'] as Color, fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
          
          Divider(height: 1, color: isDark ? Colors.white10 : const Color(0xFFE2E8F0)),
          
          // Route info
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Route line
                Column(
                  children: [
                    Icon(Icons.radio_button_checked, size: 16, color: theme.colorScheme.primary),
                    Container(width: 1.5, height: 35, color: isDark ? Colors.white10 : const Color(0xFFE2E8F0)),
                    const Icon(Icons.location_on, size: 16, color: Color(0xFFD4AF37)),
                  ],
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(order['from'] as String, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: theme.colorScheme.onSurface)),
                      const SizedBox(height: 24),
                      Text(order['to'] as String, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: theme.colorScheme.onSurface)),
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
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isDark ? Colors.black26 : const Color(0xFFF8FAFC),
              borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 14,
                  backgroundColor: isDark ? Colors.white10 : const Color(0xFFE2E8F0),
                  child: Icon(Icons.person, size: 16, color: isDark ? Colors.grey[400] : const Color(0xFF64748B)),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(order['driver'] as String, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: isDark ? Colors.grey[300] : const Color(0xFF475569))),
                      Text(order['plate'] as String, style: TextStyle(fontSize: 10, color: isDark ? Colors.grey[500] : const Color(0xFF94A3B8))),
                    ],
                  ),
                ),
                Text(
                  order['date'] as String,
                  style: TextStyle(fontSize: 11, color: isDark ? Colors.grey[500] : const Color(0xFF64748B), fontWeight: FontWeight.w500),
                ),
                const SizedBox(width: 8),
                Icon(Icons.chevron_right, size: 18, color: isDark ? Colors.grey[700] : const Color(0xFF94A3B8)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
