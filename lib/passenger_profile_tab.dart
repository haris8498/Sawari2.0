import 'package:flutter/material.dart';
import 'auth_gate.dart';
import 'main.dart'; // Import to access themeNotifier
import 'models/user_model.dart';
import 'services/auth_service.dart';

class PassengerProfileTab extends StatelessWidget {
  const PassengerProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF0F172A)
          : const Color(0xFFF1F5F9),
      body: StreamBuilder<UserModel?>(
        stream: AuthService.instance.currentProfileStream(),
        builder: (context, snap) {
          final user = snap.data;
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                _buildHeader(context, user),

            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 24.0,
              ),
              child: Column(
                children: [
                  // Stats Section (live)
                  _buildStatsRow(context, user),
                  const SizedBox(height: 32),

                  // Menu Sections
                  _buildSectionTitle(context, 'Account Settings'),
                  _buildProfileMenuItem(
                    context,
                    Icons.person_outline,
                    'Personal Information',
                    'Name, Email, Phone',
                  ),
                  _buildProfileMenuItem(
                    context,
                    Icons.lock_outline,
                    'Password & Security',
                    'Manage your password',
                  ),
                  _buildProfileMenuItem(
                    context,
                    Icons.credit_card_outlined,
                    'Payment Methods',
                    'Manage cards and wallet',
                  ),

                  const SizedBox(height: 32),
                  _buildSectionTitle(context, 'Preferences'),
                  _buildProfileMenuItem(
                    context,
                    Icons.language_outlined,
                    'Language',
                    'English (US)',
                  ),
                  _buildProfileMenuItem(
                    context,
                    Icons.notifications_none_outlined,
                    'Notifications',
                    'App sounds and alerts',
                  ),

                  // Interactive Theme Toggle
                  ValueListenableBuilder<ThemeMode>(
                    valueListenable: themeNotifier,
                    builder: (context, currentMode, _) {
                      final isDarkNow = currentMode == ThemeMode.dark;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Material(
                          color: isDarkNow
                              ? Colors.white.withOpacity(0.05)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(16),
                            onTap: () {
                              themeNotifier.value = isDarkNow
                                  ? ThemeMode.light
                                  : ThemeMode.dark;
                            },
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                              leading: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: isDarkNow
                                      ? Colors.white.withOpacity(0.05)
                                      : const Color(0xFFF1F5F9),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  isDarkNow
                                      ? Icons.dark_mode_outlined
                                      : Icons.light_mode_outlined,
                                  color: theme.colorScheme.primary,
                                  size: 22,
                                ),
                              ),
                              title: Text(
                                'Appearance',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: theme.colorScheme.onSurface,
                                ),
                              ),
                              subtitle: Text(
                                isDarkNow ? 'Dark Mode' : 'Light Mode',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: isDarkNow
                                      ? Colors.grey[500]
                                      : const Color(0xFF94A3B8),
                                ),
                              ),
                              trailing: Switch(
                                value: isDarkNow,
                                activeColor: theme.colorScheme.primary,
                                onChanged: (val) {
                                  themeNotifier.value = val
                                      ? ThemeMode.dark
                                      : ThemeMode.light;
                                },
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 32),
                  _buildSectionTitle(context, 'Support & Legal'),
                  _buildProfileMenuItem(
                    context,
                    Icons.help_outline,
                    'Help Center',
                    'FAQs and Support',
                  ),
                  _buildProfileMenuItem(
                    context,
                    Icons.description_outlined,
                    'Privacy Policy',
                    'Data usage and rights',
                  ),
                  _buildProfileMenuItem(
                    context,
                    Icons.info_outline,
                    'About Sawari',
                    'Version 1.0.0',
                  ),

                  const SizedBox(height: 40),

                  // Log Out Button
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () async {
                        await AuthService.instance.signOut();
                        if (!context.mounted) return;
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (_) => const AuthGate()),
                          (_) => false,
                        );
                      },
                      icon: const Icon(Icons.logout, color: Colors.redAccent, size: 22),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: BorderSide(
                            color: Colors.redAccent.withOpacity(0.5),
                            width: 1.5
                        ),
                        backgroundColor: Colors.redAccent.withOpacity(0.05),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      label: const Text(
                        'Log Out',
                        style: TextStyle(
                          color: Colors.redAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context, UserModel? user) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final topPadding = MediaQuery.of(context).padding.top;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primary,
            isDark ? theme.colorScheme.primary.withOpacity(0.6) : theme.colorScheme.primaryContainer,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
      ),
      padding: EdgeInsets.only(top: topPadding + 32, bottom: 40, left: 24, right: 24),
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                width: 116,
                height: 116,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white.withOpacity(0.8), width: 4),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(isDark ? 0.4 : 0.15),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ],
                  image: const DecorationImage(
                    image: AssetImage('lib/assets/images/passenger.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 4,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFD4AF37), // Brand Gold
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.edit, color: Colors.white, size: 16),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                user?.name.isNotEmpty == true ? user!.name : 'Passenger',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Color(0xFFD4AF37),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check, color: Colors.white, size: 14),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            user?.phone.isNotEmpty == true ? user!.phone : '',
            style: TextStyle(
              color: Colors.white.withOpacity(0.85),
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow(BuildContext context, UserModel? user) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.05) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.04),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildStatItem(context, 'Total Rides', '${user?.totalRides ?? 0}'),
          _buildDivider(context),
          _buildStatItem(context, 'Rating', (user?.rating ?? 5.0).toStringAsFixed(1)),
          _buildDivider(context),
          _buildStatItem(context, 'Wallet', '\$${(user?.walletBalance ?? 0).toStringAsFixed(0)}'),
        ],
      ),
    );
  }

  Widget _buildStatItem(BuildContext context, String label, String value) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.grey[400] : const Color(0xFF64748B),
          ),
        ),
      ],
    );
  }

  Widget _buildDivider(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: 1,
      height: 36,
      color: isDark ? Colors.white.withOpacity(0.1) : const Color(0xFFE2E8F0),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 12),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title.toUpperCase(),
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w800,
            color: isDark ? Colors.grey[500] : const Color(0xFF94A3B8),
            letterSpacing: 1.2,
          ),
        ),
      ),
    );
  }

  Widget _buildProfileMenuItem(
      BuildContext context,
      IconData icon,
      String title,
      String subtitle,
      ) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: isDark ? Colors.white.withOpacity(0.05) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        clipBehavior: Clip.antiAlias, // Ensures the ripple stays inside the rounded corners
        child: InkWell(
          onTap: () {
            // Future tap logic
          },
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            leading: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.white.withOpacity(0.05)
                    : const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: theme.colorScheme.primary, size: 22),
            ),
            title: Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: theme.colorScheme.onSurface,
              ),
            ),
            subtitle: Text(
              subtitle,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: isDark ? Colors.grey[500] : const Color(0xFF94A3B8),
              ),
            ),
            trailing: Icon(
              Icons.chevron_right,
              color: isDark ? Colors.grey[600] : const Color(0xFFCBD5E1),
            ),
          ),
        ),
      ),
    );
  }
}