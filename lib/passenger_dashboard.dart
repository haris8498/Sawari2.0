import 'package:flutter/material.dart';
import 'passenger_home_tab.dart';
import 'passenger_orders_tab.dart';
import 'passenger_wallet_tab.dart';
import 'passenger_profile_tab.dart';
import 'driver_sign_up.dart';

class PassengerDashboard extends StatefulWidget {
  const PassengerDashboard({super.key});

  @override
  State<PassengerDashboard> createState() => _PassengerDashboardState();
}

class _PassengerDashboardState extends State<PassengerDashboard> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const PassengerHomeTab(),
    const PassengerOrdersTab(),
    const PassengerWalletTab(),
    const PassengerProfileTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildDrawer(),
      body: _pages[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: const Color(0xFF0F265C),
          unselectedItemColor: const Color(0xFF94A3B8),
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.route_outlined),
              activeIcon: Icon(Icons.route),
              label: 'Ride',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long_outlined),
              activeIcon: Icon(Icons.receipt_long),
              label: 'My orders',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_balance_wallet_outlined),
              activeIcon: Icon(Icons.account_balance_wallet),
              label: 'Wallet',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.only(top: 60, bottom: 20, left: 24, right: 24),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: AssetImage('lib/assets/images/passenger.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Mah',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF0F265C)),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.star, size: 16, color: Color(0xFF0F265C)),
                          const Icon(Icons.star, size: 16, color: Color(0xFF0F265C)),
                          const Icon(Icons.star, size: 16, color: Color(0xFF0F265C)),
                          const Icon(Icons.star, size: 16, color: Color(0xFF0F265C)),
                          const Icon(Icons.star, size: 16, color: Color(0xFF0F265C)),
                          const SizedBox(width: 4),
                          Text(
                            '4.80 (0)',
                            style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, color: Color(0xFF0F265C)),
              ],
            ),
          ),
          
          const Divider(),

          // Menu Items
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildDrawerItem(Icons.directions_car_outlined, 'City'),
                _buildDrawerItem(Icons.access_time, 'Request history'),
                _buildDrawerItem(Icons.public, 'City to City', isSelected: true),
                _buildDrawerItem(Icons.notifications_none, 'Notifications'),
                _buildDrawerItem(Icons.verified_user_outlined, 'Safety'),
                _buildDrawerItem(Icons.settings_outlined, 'Settings'),
                _buildDrawerItem(Icons.info_outline, 'Help'),
                _buildDrawerItem(Icons.chat_bubble_outline, 'Support'),
              ],
            ),
          ),

          // Driver Mode Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Close drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const DriverSignUpScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0F265C),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
              ),
              child: const Text(
                'Driver Mode',
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),

          // Social Icons
          Padding(
            padding: const EdgeInsets.only(bottom: 30, top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildSocialIcon(Icons.facebook),
                const SizedBox(width: 20),
                _buildSocialIcon(Icons.camera_alt_outlined), // Instagram proxy
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, {bool isSelected = false}) {
    return Container(
      color: isSelected ? const Color(0xFF0F265C).withValues(alpha: 0.1) : Colors.transparent,
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFF0F265C), size: 28),
        title: Text(
          title,
          style: TextStyle(
            color: const Color(0xFF0F265C),
            fontSize: 18,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          ),
        ),
        onTap: () {},
      ),
    );
  }

  Widget _buildSocialIcon(IconData icon) {
    return Icon(icon, color: const Color(0xFF0F265C), size: 30);
  }
}
