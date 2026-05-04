import 'package:flutter/material.dart';
import 'driver_home_tab.dart';
import 'driver_earnings_tab.dart';
import 'passenger_dashboard.dart';
import 'main.dart'; // For themeNotifier
import 'notifications_screen.dart';
import 'settings_screen.dart';
import 'driver_history_tab.dart';
import 'driver_profile_tab.dart';


class DriverDashboard extends StatefulWidget {
  const DriverDashboard({super.key});

  @override
  State<DriverDashboard> createState() => _DriverDashboardState();
}

class _DriverDashboardState extends State<DriverDashboard> {
  int _currentIndex = 0;
  final List<Widget?> _pages = [null, null, null, null];

  Widget _getPage(int index) {
    if (_pages[index] == null) {
      switch (index) {
        case 0:
          _pages[index] = const DriverHomeTab();
          break;
        case 1:
          _pages[index] = const DriverEarningsTab();
          break;
        case 2:
          _pages[index] = const DriverHistoryTab();
          break;
        case 3:
          _pages[index] = const DriverProfileTab();
          break;
      }
    }
    return _pages[index]!;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      drawer: _buildDrawer(),
      body: _getPage(_currentIndex),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.4 : 0.05),
              blurRadius: 15,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          type: BottomNavigationBarType.fixed,
          backgroundColor: theme.scaffoldBackgroundColor,
          selectedItemColor: theme.colorScheme.primary,
          unselectedItemColor: isDark ? Colors.grey[500] : const Color(0xFF94A3B8),
          elevation: 0,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
          items: const [
            BottomNavigationBarItem(
              icon: Padding(padding: EdgeInsets.only(bottom: 4.0), child: Icon(Icons.drive_eta_outlined)),
              activeIcon: Padding(padding: EdgeInsets.only(bottom: 4.0), child: Icon(Icons.drive_eta)),
              label: 'Drive',
            ),
            BottomNavigationBarItem(
              icon: Padding(padding: EdgeInsets.only(bottom: 4.0), child: Icon(Icons.account_balance_wallet_outlined)),
              activeIcon: Padding(padding: EdgeInsets.only(bottom: 4.0), child: Icon(Icons.account_balance_wallet)),
              label: 'Earnings',
            ),
            BottomNavigationBarItem(
              icon: Padding(padding: EdgeInsets.only(bottom: 4.0), child: Icon(Icons.list_alt_outlined)),
              activeIcon: Padding(padding: EdgeInsets.only(bottom: 4.0), child: Icon(Icons.list_alt)),
              label: 'History',
            ),
            BottomNavigationBarItem(
              icon: Padding(padding: EdgeInsets.only(bottom: 4.0), child: Icon(Icons.person_outline)),
              activeIcon: Padding(padding: EdgeInsets.only(bottom: 4.0), child: Icon(Icons.person)),
              label: 'Account',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawer() {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Drawer(
      backgroundColor: theme.scaffoldBackgroundColor,
      child: SafeArea(
        child: Column(
          children: [
            // Driver Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Row(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: theme.colorScheme.primary.withOpacity(0.2), width: 2),
                    ),
                    child: const CircleAvatar(
                      backgroundImage: AssetImage('lib/assets/images/driver.png'),
                      backgroundColor: Colors.transparent,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Ahmed Ali',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onSurface,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFFD4AF37).withOpacity(0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.star, size: 14, color: Color(0xFFD4AF37)),
                              SizedBox(width: 4),
                              Text(
                                '4.95 Pro',
                                style: TextStyle(color: Color(0xFFD4AF37), fontSize: 12, fontWeight: FontWeight.bold),
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

            Divider(color: isDark ? Colors.grey[800] : Colors.grey[200], thickness: 1, height: 1),
            const SizedBox(height: 8),

            // Menu Items
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                physics: const BouncingScrollPhysics(),
                children: [
                  _buildDrawerItem(Icons.dashboard_outlined, 'Dashboard', isSelected: true, onTap: () => Navigator.pop(context)),
                  _buildDrawerItem(Icons.directions_car_outlined, 'Vehicle Details'),
                  _buildDrawerItem(Icons.description_outlined, 'Documents'),
                  _buildDrawerItem(Icons.public, 'City to City Requests'),
                  const SizedBox(height: 8),
                  Divider(color: isDark ? Colors.grey[800] : Colors.grey[200], indent: 24, endIndent: 24),
                  const SizedBox(height: 8),
                  _buildDrawerItem(
                      Icons.notifications_none,
                      'Notifications',
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const NotificationsScreen()));
                      }
                  ),
                  _buildDrawerItem(
                      Icons.settings_outlined,
                      'Settings',
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsScreen()));
                      }
                  ),
                ],
              ),
            ),

            // Switch to Passenger Mode Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: OutlinedButton.icon(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const PassengerDashboard()),
                        (route) => false,
                  );
                },
                icon: Icon(Icons.swap_horiz, color: theme.colorScheme.primary),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: BorderSide(color: theme.colorScheme.primary.withOpacity(0.5), width: 1.5),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  minimumSize: const Size(double.infinity, 54),
                ),
                label: Text(
                  'Switch to Passenger',
                  style: TextStyle(
                    color: theme.colorScheme.primary,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, {bool isSelected = false, VoidCallback? onTap}) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        selected: isSelected,
        selectedTileColor: theme.colorScheme.primary.withOpacity(0.1),
        leading: Icon(
            icon,
            color: isSelected ? theme.colorScheme.primary : theme.colorScheme.onSurfaceVariant,
            size: 26
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isSelected ? theme.colorScheme.primary : theme.colorScheme.onSurface,
            fontSize: 16,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
        onTap: onTap ?? () {},
      ),
    );
  }
}