import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
            'Settings',
            style: TextStyle(
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.5,
            )
        ),
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: theme.colorScheme.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          children: [
            _buildSettingsSection(
              context,
              'App Settings',
              [
                _buildSettingsItem(
                  context,
                  Icons.notifications_none,
                  'Push Notifications',
                  trailing: Switch(
                      value: true,
                      activeColor: theme.colorScheme.primary,
                      onChanged: (v) {}
                  ),
                ),
                _buildSettingsItem(
                  context,
                  Icons.language,
                  'Language',
                  trailing: Text(
                      'English',
                      style: TextStyle(
                        color: isDark ? Colors.grey[400] : const Color(0xFF64748B),
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      )
                  ),
                ),
                _buildSettingsItem(
                  context,
                  Icons.location_on_outlined,
                  'Location Accuracy',
                  trailing: Text(
                      'High',
                      style: TextStyle(
                        color: isDark ? Colors.grey[400] : const Color(0xFF64748B),
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      )
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            _buildSettingsSection(
              context,
              'Account',
              [
                _buildSettingsItem(context, Icons.person_outline, 'Privacy Settings'),
                _buildSettingsItem(context, Icons.security, 'Security Checkup'),
                _buildSettingsItem(
                  context,
                  Icons.delete_outline,
                  'Delete Account',
                  textColor: Colors.redAccent,
                ),
              ],
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsSection(BuildContext context, String title, List<Widget> items) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Inject subtle dividers between items
    List<Widget> separatedItems = [];
    for (int i = 0; i < items.length; i++) {
      separatedItems.add(items[i]);
      if (i < items.length - 1) {
        separatedItems.add(
          Divider(
            height: 1,
            thickness: 1,
            indent: 64, // Aligns divider with text start
            endIndent: 20,
            color: isDark ? Colors.white.withOpacity(0.05) : const Color(0xFFF1F5F9),
          ),
        );
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 12),
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
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(isDark ? 0.3 : 0.03),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Material(
            color: isDark ? Colors.white.withOpacity(0.05) : Colors.white,
            borderRadius: BorderRadius.circular(24),
            clipBehavior: Clip.antiAlias, // Keeps ripples inside the rounded corners
            child: Column(
              children: separatedItems,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsItem(BuildContext context, IconData icon, String title, {Widget? trailing, Color? textColor}) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final contentColor = textColor ?? theme.colorScheme.onSurface;
    final iconColor = textColor ?? theme.colorScheme.primary;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: textColor != null
              ? textColor.withOpacity(0.1)
              : (isDark ? Colors.white.withOpacity(0.05) : const Color(0xFFF1F5F9)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: iconColor, size: 22),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
          color: contentColor,
        ),
      ),
      trailing: trailing ?? Icon(
        Icons.chevron_right_rounded,
        color: isDark ? Colors.grey[600] : const Color(0xFFCBD5E1),
      ),
      onTap: () {
        // Future settings navigation logic
      },
    );
  }
}